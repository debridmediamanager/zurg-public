<h1 align="center">zurg</h1>

<p align="center"><b>Every debrid account and Usenet in one folder.</b></p>

<p align="center">
  <a href="https://zurg.debridmediamanager.com/">Website</a> ·
  <a href="https://github.com/debridmediamanager/zurg-public/releases">Download</a> ·
  <a href="https://notes.debridmediamanager.com/zurg/">Docs</a> ·
  <a href="https://discord.com/invite/7u4YjMThXP">Discord</a> ·
  <a href="https://gatekeeper.debridmediamanager.com/">Sponsor</a>
</p>

This is zurg's public stable release for Real-Debrid. Sponsor nightlies add TorBox, AllDebrid, Premiumize, Debrid-Link, Offcloud and Usenet. [The website](https://zurg.debridmediamanager.com/) shows the options.

zurg serves your Real-Debrid library over WebDAV. [rclone](https://rclone.org/) mounts it so Plex can read it. Infuse can read WebDAV directly.

This repository holds the public release and its quick-start files: `config.yml`, `docker-compose.yml`, `rclone.conf` and Plex update scripts. Download binaries from [Releases](https://github.com/debridmediamanager/zurg-public/releases).

## Requirements

- A [Real-Debrid](http://real-debrid.com/?id=20476026) account and [API token](http://real-debrid.com/?id=20476150)
- `rclone` and `ffprobe` are **automatically downloaded** on first run if not already installed

## Download

[Release Cycle](https://github.com/debridmediamanager/zurg-public/wiki/Release-cycle)

### Stable version: v1.0.0 (Public)

This repository documents the current release.

[Download the binary](https://github.com/debridmediamanager/zurg-public/releases) or use docker

```sh
docker pull ghcr.io/debridmediamanager/zurg-public:latest
# or pin the release
docker pull ghcr.io/debridmediamanager/zurg-public:v1.0.0
```

> The same build is also pushed to the old `zurg-testing` name, byte for byte, so existing installs keep pulling without a compose edit. New installs should use `zurg-public`.

### Nightly (Sponsors only)

Date-stamped nightlies use `YYYY.MM.DD.HHMM-nightly`. They add backends beyond Real-Debrid including TorBox, AllDebrid, Premiumize, Debrid-Link, Offcloud and Usenet.

Nightlies need an **active sponsorship**. Start at [gatekeeper](https://gatekeeper.debridmediamanager.com/):

1. Press **Connect GitHub**. That account gets access.
2. Pay there or sponsor on GitHub Sponsors or Patreon. For Patreon also press **Connect Patreon** so the pledge can be matched.
3. Press **Register**.

Patreon alone grants no access because it cannot identify your GitHub account. Until access is granted the private repo answers **404**. Access ends when the sponsorship lapses.

The same sponsorship opens DMM's sponsor features including the wanted list that zurg fetches for you and the Jellyfin and Emby plugins. [What a sponsorship gives you](https://notes.debridmediamanager.com/guides/sponsorship/) lists every perk.

[Download the binary](https://github.com/debridmediamanager/zurg/releases) or use docker

Pulling the private Docker image is step 1 of the [Docker guide](https://notes.debridmediamanager.com/zurg/setup/docker/#1-install-docker-and-unlock-the-image).

```sh
docker pull ghcr.io/debridmediamanager/zurg:latest
```

## How to run zurg in 5 steps for Plex with Docker

1. Clone the repo and enter it with `git clone https://github.com/debridmediamanager/zurg-public.git && cd zurg-public`
2. Add your token to `config.yml`
3. Create the mount with `sudo mkdir -p /mnt/zurg`
4. Start zurg with `docker compose up -d`
5. Check the mount with `time ls -1R /mnt/zurg`

After a config change run `docker compose restart zurg`.

Stuck? Ask in the **zurg-support** forum on [Discord](https://discord.com/invite/7u4YjMThXP).

A web server is now running at `localhost:9999`, with the dashboard at `localhost:9999/config/`.

### Binary

Download the binary and run it. zurg creates a config and downloads `ffprobe` and `rclone` when needed.

```bash
./zurg                           # creates config.yml, downloads bin/ffprobe + bin/rclone
# edit config.yml → add your Real-Debrid token
./zurg                           # starts the server on http://localhost:9999
```

The `TOKEN` (or `RD_TOKEN`) environment variable auto-creates a config on first run, so Docker users can skip the config file entirely. `PORT` overrides the configured port.

### Note: when using zurg in a server outside of your home network, ensure that "Use my Remote Traffic automatically when needed" is unchecked on your [Account page](https://real-debrid.com/account)

## Command-line utility

```
Usage:
  zurg [flags]
  zurg [command]

Available Commands:
  download-requirements Download ffprobe and rclone into a directory and update config paths
  clear-downloads Clear all downloads (unrestricted links) in your account
  clear-torrents  Clear all torrents in your account
  completion      Generate the autocompletion script for the specified shell
  help            Help about any command
  network-test    Run a network test
  version         Prints zurg's current version

Flags:
  -c, --config string   config file path (default "./config.yml")
  -h, --help            help for zurg

Use "zurg [command] --help" for more information about a command.
```

<a id="why-zurg-why-not-x"></a>

## What it does

- Library changes appear quickly when Plex picks them up ([details](./scripts/plex_update.sh)).
- `config.yml` can filter directories by name and file content. [Need help?](https://github.com/debridmediamanager/zurg-public/wiki/Config)
- Dead links are checked when a file is opened and repaired when possible.

## Windows

Windows needs WinFsp and one extra rclone flag. See [WINDOWS.md](WINDOWS.md).

## Please read our [wiki](https://github.com/debridmediamanager/zurg-public/wiki) for more information!

## [zurg's version history](https://github.com/debridmediamanager/zurg-public/wiki/History)

---

**More from DMM:** [Debrid Media Manager](https://debridmediamanager.com/) · [zurg](https://zurg.debridmediamanager.com/) · [rex](https://rex.debridmediamanager.com/) · [Docs](https://notes.debridmediamanager.com/) · [Sponsor](https://gatekeeper.debridmediamanager.com/) · [Discord](https://discord.com/invite/7u4YjMThXP) · [Reddit](https://www.reddit.com/r/debridmediamanager/)
