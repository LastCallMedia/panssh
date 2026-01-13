# 🖥️ PanSSH under Lando

This file is an optional part of the [PanSSH](https://github.com/LastCallMedia/panssh) utility. It provides service and tooling setup to facilitate use of PanSSH under [Lando](https://lando.dev/).

## ✅ Requirements

- A Lando application built using the [Lando Pantheon Plugin](https://docs.lando.dev/plugins/pantheon/index.html) or other configuration which meets [PanSSH requirements](https://github.com/LastCallMedia/panssh/blob/main/README.md#-requirements).

## 📦 Installation

1. Either clone the [PanSSH repository](https://github.com/LastCallMedia/panssh) or download `.lando.panssh.yml` directly:

```
curl -so .lando.panssh.yml https://raw.githubusercontent.com/LastCallMedia/panssh/refs/heads/lando/lando/.lando.panssh.yml
```
2. Place `.lando.panssh.yml` in the same location as your application's `.lando.yml` file.

2. Do one of:
     1. Rename it to `.lando.local.yml`, or merge it into your existing `.lando.local.yml` file, if present.
     2. Add `.lando.panssh.yml` into the `postLandoFiles` section of your `~/.lando/config.yml` (recommended).

    ⚙️ In either case, see: https://docs.lando.dev/landofile/#configuration for further information. You may need to create `~/.lando/config.yml` if it is currently missing or empty.

3. Run `lando rebuild` to apply the changes. This will download and install the relevant components into your Lando application:
   * PanSSH scripts.
   * Supporting OS packages.
   * PanSSH sites configuration file (runs Terminus).

## Commands provided:

* `lando panssh <site.env>` — starts PanSSH for the specified site and environment.
* `lando pssh` — starts PanSSH for the related site and environment name matching your current git branch.

---
