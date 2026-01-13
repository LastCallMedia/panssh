# 🖥️ PanSSH
## An emulated SSH login for Pantheon sites

PanSSH emulates an interactive SSH connection to a Pantheon site's application environment using only their available (limited) SSH service. It provides command history, local editing of remote files and an emulated current working directory.

You can do almost everything that you could if a standard SSH login were available, and it looks and feels so familiar that you may not notice the difference.

### Quick start

##### Download and run the main script

```
curl -so panssh https://raw.githubusercontent.com/LastCallMedia/panssh/refs/heads/lando/panssh
chmod +x panssh
./panssh
```
Further instructions will then be displayed.

### Recent changes
* 1.2.1: Added [.lando.panssh.yml](https://github.com/LastCallMedia/panssh/blob/lando/lando/.lando.panssh.yml), which provides [easy setup](https://github.com/LastCallMedia/panssh/blob/lando/lando/README.md) of PanSSH in a [Lando](https://lando.dev/) project.
* 1.2.0: Tab-completion is now included, on supporting systems:
  * Local site and environment names.
  * Remote directory and file names.

---

## 📌 Usage

### Interactive
```
panssh site.env
```

### Non-Interactive

##### From command-line:
```
panssh site.env "command1; command2; ..."
```
##### From stdin:
```
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
- Bash 3.2+ for basic operation.
- Bash 4.0+ to support tab-completion of remote directory and file names.
- Common Linux/Unix utilities.
- For local file viewing / editing:
  - A text-based editor such as `nano` or `vim`, or a suitably configured `$EDITOR`.
  - Standard `scp` and `shasum` utilities.
- [Terminus CLI](https://pantheon.io/docs/terminus) (needed only to fetch a list of your accessible sites).

---

## 📦 Installation

### No installation

The only required file is the `panssh` script.

##### Download just the main script

```
curl -so panssh https://raw.githubusercontent.com/LastCallMedia/panssh/refs/heads/lando/panssh
```
* Mark the script as executable: `chmod +x panssh`
* Run it as just `./panssh` to see further instructions.

### Minimal installation

Clone the [PanSSH repository](https://github.com/LastCallMedia/panssh) or download and unzip the [zip archive](https://github.com/LastCallMedia/panssh/archive/refs/heads/lando.zip).

Mark the main `panssh` script as executable, then copy or move it to any suitable directory that's included in your PATH.

```
chmod +x panssh
sudo mv panssh /usr/local/bin/
```

Run it as just `panssh` to see further instructions.

### Optional: tab-completion of local site and environment names

Copy the `panssh` completion script from `bash-completion/` to the `bash-completions/completions` directory on your system.
* For recent Ubuntu distributions, you can probably use `/usr/local/share/bash-completion/completions/`
* For MacOS, maybe `/opt/homebrew/etc/bash_completion.d/` or `usr/local/etc/bash_completion.d`, depending on your system.

Test tab-completion by entering `panssh ` then pressing the tab key (create a sites configuration file first).

### Optional: tab-completion of remote directory and file names

This feature requires Bash 4 or higher. 

* **On MacOS:**
  * You can install Bash 5 with [Homebrew](https://formulae.brew.sh/formula/bash).
  * You will also need [bash-completion](https://formulae.brew.sh/formula/bash-completion) or [bash-completion@2](https://formulae.brew.sh/formula/bash-completion@2)

Copy `readx.source.sh` to one of:
  * The same location as the main `panssh` script.
  * A subdirectory `../lib/panssh` relative to the location of the main `panssh` script.
    * For example: `/usr/local/lib/panssh/` if `panssh` itself is in `/usr/local/bin/`

Test tab-completion by using `panssh` to connect to a Pantheon site, then press the tab key once or twice - the remote directory contents should be listed.

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

This file maps Pantheon site names to their site IDs, which are used to form SSH host and user names.

---

## ✨ Features

- Most things will just work as you would expect. A few won't (see limitations, below).
- Local viewing and editing of remote files, with automatic download and upload.
- Non-interactive execution from local scripts or piped input.
- Arrow-key command history for the current session.
- Local tab-completion of site and environment names.
- Tab-completion of remote directory and file names.
- Optional automatic listing of directory contents after switching directory.
- Uses persistent SSH connections for best responsiveness.

---

## ⚠️ Limitations

- No support for interactive input (`more`, `rm -i`, `drush` confirmation prompts, etc). Some such programs will act as if ENTER was pressed and use a default value. Others will simply not work.
- Some behaviours will differ compared with a real interactive SSH session.
- Tab-completion for remote directory and file names requires Bash 4+.
- **Relies on discoverable but publicly undocumented features of Pantheon's SSH service, and their user and host naming conventions.**

---

## 👤 Author

**Andy Inman**  
[andy@lastcallmedia.com](mailto:andy@lastcallmedia.com)

---

## 🪪 License

**MIT**
