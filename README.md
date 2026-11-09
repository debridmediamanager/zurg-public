<h1 align="center">zurg</h1>

<p align="center"><b>Every debrid account and Usenet in one folder.</b></p>

<p align="center">
  <a href="https://zurg.debridmediamanager.com/">Website</a> ·
  <a href="https://github.com/debridmediamanager/zurg-public/releases">Download</a> ·
  <a href="https://notes.debridmediamanager.com/zurg/">Docs</a> ·
  <a href="https://discord.com/invite/7u4YjMThXP">Discord</a> ·
  <a href="https://gatekeeper.debridmediamanager.com/">Sponsor</a>
</p>

This is zurg's public stable release. It is Real-Debrid only. The sponsor nightlies add TorBox, AllDebrid, Premiumize, Debrid-Link, Offcloud and Usenet in the same folder. [The website](https://zurg.debridmediamanager.com/) shows what they do.

zurg is a self-hosted Real-Debrid WebDAV server written from scratch. Together with [rclone](https://rclone.org/) it mounts your Real-Debrid torrent library into your file system like Dropbox. Infuse reads it directly and Plex reads the rclone mount.

This repository holds the public release and the quick-start bundle — `config.yml`, `docker-compose.yml`, `rclone.conf` and the Plex update scripts. The binaries live under [Releases](https://github.com/debridmediamanager/zurg-public/releases).

## Requirements

- A [Real-Debrid](http://real-debrid.com/?id=20476026) account and [API token](http://real-debrid.com/?id=20476150)
- `rclone` and `ffprobe` are **automatically downloaded** on first run if not already installed

## Download

[Release Cycle](https://github.com/debridmediamanager/zurg-public/wiki/Release-cycle)

### Stable version: v1.0.0 (Public)

The current release, and what this repository documents.

[Download the binary](https://github.com/debridmediamanager/zurg-public/releases) or use docker

```sh
docker pull ghcr.io/debridmediamanager/zurg-public:latest
# or pin the release
docker pull ghcr.io/debridmediamanager/zurg-public:v1.0.0
```

> The same build is also pushed to the old `zurg-testing` name, byte for byte, so existing installs keep pulling without a compose edit. New installs should use `zurg-public`.

### Nightly (Sponsors only)

Date-stamped nightlies — `YYYY.MM.DD.HHMM-nightly` — carrying work that has not landed in a stable release yet, including backends beyond Real-Debrid (TorBox, AllDebrid, Premiumize, Debrid-Link, Offcloud and Usenet).

Nightlies need an **active sponsorship**. Start at [gatekeeper](https://gatekeeper.debridmediamanager.com/):

1. Press **Connect GitHub**. That account is the one granted access.
2. Pay by card there, or sponsor on GitHub Sponsors or Patreon. Sponsoring through Patreon? Press **Connect Patreon Account** too, so the pledge can be matched to you.
3. Press **Complete Registration**.

Sponsoring on Patreon and stopping there grants nothing, because a pledge on its own cannot say which GitHub account is yours. Until access is granted the private repo answers **404** rather than a permission error, which is what a private repo looks like to an account that cannot see it — not a broken link. Access is removed again if the sponsorship lapses.

The same sponsorship opens DMM's sponsor features too, like the wanted list that zurg fetches for you, DMM as an indexer for Sonarr and Radarr, and the Jellyfin and Emby plugins. [What a sponsorship gives you](https://notes.debridmediamanager.com/guides/sponsorship/) lists every one.

[Download the binary](https://github.com/debridmediamanager/zurg/releases) or use docker

Pulling the private Docker image is step 1 of the [Docker guide](https://notes.debridmediamanager.com/zurg/setup/docker/#1-install-docker-and-unlock-the-image).

```sh
docker pull ghcr.io/debridmediamanager/zurg:latest
```

## How to run zurg in 5 steps for Plex with Docker

1. Clone the repo `git clone https://github.com/debridmediamanager/zurg-public.git`
2. Add your token in `config.yml`
3. `sudo mkdir -p /mnt/zurg`
4. Run `docker compose up -d`
5. `time ls -1R /mnt/zurg` You're done! If you do edits on your config.yml just do `docker compose restart zurg`.

Stuck? Ask in the **zurg-support** forum on [Discord](https://discord.com/invite/7u4YjMThXP).

A web server is now running at `localhost:9999`, with the dashboard at `localhost:9999/config/`.

### Binary

Download the binary, run it, and zurg handles the rest — it auto-creates a default config and downloads `ffprobe` and `rclone` for you.

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

## Why zurg? Why not X?

- Better performance than anything out there; changes in your library appear instantly ([assuming Plex picks it up fast enough](./scripts/plex_update.sh))
- You can configure a flexible directory structure in `config.yml`, filtering torrents by name, file contents, size, age and more. [Need help?](https://github.com/debridmediamanager/zurg-public/wiki/Config)
- If you've ever experienced Plex scanner being stuck on a file and thereby freezing Plex completely, it should not happen anymore because zurg does a comprehensive check if a torrent is dead or not. You can run `ps aux --sort=-time | grep "Plex Media Scanner"` to check for stuck scanner processes.
- zurg guarantees that your library is **always available** because of its repair abilities! Dead links are detected on-demand when content is accessed and automatically repaired — no background polling of the RD API required.

## Windows

Windows needs WinFsp and one extra rclone flag. See [WINDOWS.md](WINDOWS.md).

## Please read our [wiki](https://github.com/debridmediamanager/zurg-public/wiki) for more information!

## [zurg's version history](https://github.com/debridmediamanager/zurg-public/wiki/History)

---

**More from DMM:** [Debrid Media Manager](https://debridmediamanager.com/) · [zurg](https://zurg.debridmediamanager.com/) · [rex](https://rex.debridmediamanager.com/) · [Docs](https://notes.debridmediamanager.com/) · [Sponsor](https://gatekeeper.debridmediamanager.com/) · [Discord](https://discord.com/invite/7u4YjMThXP) · [Reddit](https://www.reddit.com/r/debridmediamanager/)
