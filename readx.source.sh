# readx — drop-in replacement for `read -e -r`, with custom tab-complete logic.
# Use as: source <path-to>/readx.source.sh

# Warn and exit if executed directly.
[[ "${BASH_SOURCE[0]}" != "${0}" ]] || {
  echo "This script should be sourced, not executed." >&2
  exit 1
}

readx() {
  local var

  if [[ "$1" == "-p" ]]; then
    _READX_PROMPT=$2
    shift 2
  fi

  var=$1
  if [[ -z "$var" ]]; then
    echo "Usage: readx [-p prompt] variable_name" >&2
    return 2
  fi

  local __readx_input status

  bind -x '"\t":_readx_tab_handler' 2>/dev/null
  read -e -r -p "${_READX_PROMPT}" __readx_input
  status=$?
  bind '"\t": complete' 2>/dev/null

  printf -v "$var" '%s' "$__readx_input"
  return $status
}

_readx_tab_handler() {
  local line="$READLINE_LINE"
  local point=$READLINE_POINT
  local before=${line:0:point}
  local after=${line:point}

  local current_word="${before##*[[:space:]]}"
  local word_start=$((point - ${#current_word}))
  local prefix="${before:0:word_start}"

  # Get current word and check if input has a space
  local current_word="${before##*[[:space:]]}"

  local completions
  if [[ "$before" == *" "* ]]; then
    completions=$(_readx_exec "compgen -f $current_word")
  else
    completions=$(_readx_exec "compgen -c $current_word")
  fi

  # No input or no matches: sound bell and return.
  if [[ -z "$line" ]] || (( ${#completions[@]} == 0 )); then
    echo -ne "\a" >&2
    return
  fi

  # Remove duplicates.
  completions=( $(printf "%s\n" "${completions[@]}" | awk '!seen[$0]++') )

  # Handle single match (exact completion)
  if (( ${#completions[@]} == 1 )); then
    local match="${completions[0]}"
    local quote=""

    if [[ "$current_word" == \"* ]]; then
      quote="\""
      current_word="${current_word#\"}"
    elif [[ "$current_word" == \'* ]]; then
      quote="'"
      current_word="${current_word#\'}"
    fi

    if [[ -n "$quote" ]]; then
      if _readx_exec "[ -d \"$match\" ]"; then 
        match="${quote}${match}/"
      else
        match="${quote}${match}${quote} "
      fi
    else
      if _readx_exec "[ -d \"$match\" ]"; then 
        match="${match}/"
      else
        match+=" "
      fi
    fi

    READLINE_LINE="${prefix}${match}${after}"
    READLINE_POINT=$(( ${#prefix} + ${#match} ))
    return
  fi

  # Multiple matches: find longest common prefix (LCP)
  local lcp="${completions[0]}"
  for match in "${completions[@]:1}"; do
    local i=0
    while [[ "${lcp:i:1}" == "${match:i:1}" && $i -lt ${#lcp} ]]; do
      ((i++))
    done
    lcp="${lcp:0:i}"
  done

  # Insert LCP delta if longer than what was typed
  if [[ "$lcp" != "$current_word" ]]; then
    local inserted="${lcp#$current_word}"
    READLINE_LINE="${before}${inserted}${after}"
    READLINE_POINT=$((point + ${#inserted}))
  fi

  echo -ne "\a" >&2  # Bell.

  # Display a limited number of matches.
  local max_show=25
  local total=${#completions[@]}
  local display=("${completions[@]:0:$max_show}")

  {
    echo "$_READX_PROMPT$line";

    if (( total <= max_show )); then
      printf "%s\n" "${display[@]}" | LC_ALL=C sort | column
    else
      echo "($total matches)"
    fi
  } >&2
}

_readx_exec() {
  ssh_exec "export $REMOTE_ENV; cd \"$current_dir\" && $1"
}
