#!/usr/bin/env bash

# readx v2 - fully self-contained readline emulator with internal auto-completion

#set -euo pipefail

# Initial directory (default: current directory)
START_DIR="${1:-$(pwd)}"
CURRENT_DIR="$START_DIR"
LINE=""
TAB_CYCLE=0

# Enable raw mode
stty -echo -icanon time 0 min 1
cleanup() {
  stty sane
  echo
}
trap cleanup EXIT

# Prompt
print_prompt() {
  printf "\r\033[K%s> %s" "$CURRENT_DIR" "$LINE"
}

# Extract last word from LINE
get_last_token() {
  echo "${LINE##* }"
}

# Replace last token in LINE with a given string
replace_last_token() {
  local new_token="$1"
  LINE="${LINE% *}"
  [[ "$LINE" ]] && LINE+=" $new_token" || LINE="$new_token"
}

# Generate completions for the last token in the current directory
generate_completions() {
  local fragment="$1"
  COMPREPLY=()
  local output=""
  echo "[DEBUG] generating completions for: '$fragment'" >&2
  if [[ -z "$fragment" ]]; then
    output="$({ bash -c "compgen -f -- \"$CURRENT_DIR/\""; } || true)"
  else
    output="$({ bash -c "compgen -f -- \"$CURRENT_DIR/$fragment\""; } || true)"
  fi
  echo "[DEBUG] raw output: $output" >&2
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    line="${line#$CURRENT_DIR/}"
    [[ -d "$CURRENT_DIR/$line" ]] && line+="/"
    COMPREPLY+=("$line")
  done <<< "$output"
  echo "[DEBUG] COMPREPLY: ${COMPREPLY[*]}" >&2
}

# Find longest common prefix
longest_common_prefix() {
  local prefix="$1"
  shift
  for word in "$@"; do
    while [[ "${word:0:${#prefix}}" != "$prefix" && -n "$prefix" ]]; do
      prefix="${prefix:0:$((${#prefix}-1))}"
    done
  done
  echo "$prefix"
}

# Main loop
print_prompt
while true; do
  IFS= read -rsn1 char || continue

  echo "[DEBUG] char: '$char' (ord: $(printf '%d' "'${char}'"))" >&2

  if [[ "$char" == $'\e' ]]; then
    read -rsn2 discard  # skip over arrow key sequences
    continue
  fi

  case "$char" in
    '')  # ENTER
      printf "\r\033[K"
      echo "$LINE"
      exit 0
      ;;
    $'\177')  # BACKSPACE
      [[ -n "$LINE" ]] && LINE="${LINE:0:${#LINE}-1}"
      TAB_CYCLE=0
      ;;
    $'\t')  # TAB
      fragment="$(get_last_token)"
      echo "[DEBUG] get_last_token: '$fragment'" >&2
      generate_completions "$fragment"

      if (( ${#COMPREPLY[@]} == 0 )); then
        echo "[DEBUG] no completions found" >&2
        TAB_CYCLE=0
      elif (( ${#COMPREPLY[@]} == 1 )); then
        echo "[DEBUG] single completion: ${COMPREPLY[0]}" >&2
        replace_last_token "${COMPREPLY[0]}"
        TAB_CYCLE=0
      else
        common="$(longest_common_prefix "${COMPREPLY[@]}")"
        echo "[DEBUG] common prefix: '$common'" >&2
        if [[ "$common" != "$fragment" ]]; then
          replace_last_token "$common"
          TAB_CYCLE=0
        else
          ((TAB_CYCLE++))
          if (( TAB_CYCLE >= 2 )); then
            echo
            printf "%s\n" "${COMPREPLY[@]}" | paste -sd ' ' - | fold -s -w $(tput cols)
            TAB_CYCLE=0
          fi
        fi
      fi
      ;;
    *)
      LINE+="$char"
      TAB_CYCLE=0
      ;;
  esac

  print_prompt
done
