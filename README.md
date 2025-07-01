# 🖥️ panssh – Pantheon Interactive SSH Session Emulator

`panssh` emulates an interactive SSH connection to a Pantheon site's application environment using only their available (limited) SSH service. It provides command history, local editing of remote files and an emulated current working directory.

You can do almost everything that you could if a standard SSH login were available, and it looks and feels near identical.

##### A short summary by ChatGPT of why you may want to use it:

[Finally, real SSH-like access on Pantheon](https://chatgpt.com/s/t_685ee5f3b51c8191b826430aeaf94aa0)

---

## 📌 Usage

### Interactive
```
panssh site.env
```

### Non-Interactive
```
# From command-line:
panssh site.env "command1; command2; ..."

# From stdin:
panssh site.env < script.sh
echo "commands" | panssh site.env
```

- `site` — the Pantheon site name.
- `env` — the environment identifier (`dev`, `test`, `live`, or multidev ID).

---

## 🧰 Commands

### Standard
- Use shell commands in the normal way.
- Type `exit` to close the interactive session.

### Special
- `.vw <filepath>` — View a remote file (download and open in viewer/editor).
- `.ed <filepath>` — Edit a remote file (download, edit locally, upload).
- `.ls` — Toggle automatic `ls` after directory change.

---

## ✅ Requirements

- A Pantheon user account with SSH access configured.
- SSH client with a key pair registered in your Pantheon account.
- Bash 3.2+
- For local file viewing / editing:
  - A terminal-based editor (e.g., `nano`, `vim`) or a configured `$EDITOR` variable.
  - Standard `scp` and `shasum` utilities.
- [Terminus CLI](https://pantheon.io/docs/terminus) (needed only to fetch a list of your accessible sites).

---

## 📦 Installation

Just mark the script as executable, then copy or move it to any suitable directory that's included in your PATH.

```
chmod +x panssh
sudo mv panssh /usr/local/bin/
```

---

## ⚙️ Configuration

A simple CSV file holding name and ID of the sites you want to connect to is required at:

```
$HOME/.panssh.sites
```

To generate or update it, run:

```
terminus site:list --format=csv --fields=name,id > $HOME/.panssh.sites
```

This file maps Pantheon site names to internal site IDs used for SSH routing.

---

## ✨ Features

- Most things will just work as you would expect. A few won't (see limitations, below).
- Provides local viewing and editing of remote files, with automatic download and upload.
- Supports non-interactive execution from local scripts or piped input.
- Supports arrow-key command history for the current session.
- Offers optional auto-listing of files after directory changes.
- Uses persistent SSH connections for best responsiveness.

---

## ⚠️ Limitations

- No support for interactive input (`more`, `rm -i`, `drush` confirmation prompts, etc). Some such programs will act as if ENTER was pressed and use a default value. Others will simply not work.
- Some behaviours will differ compared with a real interactive SSH session.
- No tab completion for remote filenames or commands yet. It's underdevelopment and will be available in a new release very soon.
- Relies on discoverable but publicly undocumented features of Pantheon's SSH service, and their user and host naming conventions.

---

## 👤 Author

**Andy Inman**  
[andy@lastcallmedia.com](mailto:andy@lastcallmedia.com)

---

## 🪪 License

**MIT**
