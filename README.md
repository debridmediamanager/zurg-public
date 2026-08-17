# zurg

A self-hosted Real-Debrid webdav server written from scratch. Together with [rclone](https://rclone.org/) it can mount your Real-Debrid torrent library into your file system like Dropbox. It's meant to be used with Infuse (webdav server) and Plex (mount zurg webdav with rclone).

This repository holds the public release and the quick-start bundle — `config.yml`, `docker-compose.yml`, `rclone.conf` and the Plex update scripts. The binaries live under [Releases](https://github.com/debridmediamanager/zurg-public/releases).

## Requirements

- A [Real-Debrid](http://real-debrid.com/?id=440161) account and [API token](http://real-debrid.com/?id=440161)
- `rclone` and `ffprobe` are **automatically downloaded** on first run if not already installed

## Download

[Release Cycle](https://github.com/debridmediamanager/zurg-public/wiki/Release-cycle)

### Stable version: v1.0.0 (Public)

The current release, and what this repository documents.

[Download the binary](https://github.com/debridmediamanager/zurg-public/releases) or use docker

```sh
docker pull ghcr.io/debridmediamanager/zurg-testing:latest
# or pin the release
docker pull ghcr.io/debridmediamanager/zurg-testing:v1.0.0
```

> The image name is still `zurg-testing`, from before this repository was renamed to `zurg-public`. It is the current and correct image for stable releases, and `:latest` on it always points at the newest one.

### Nightly (Sponsors only)

Date-stamped nightlies — `YYYY.MM.DD.HHMM-nightly` — carrying work that has not landed in a stable release yet, including backends beyond Real-Debrid (TorBox, AllDebrid and Usenet).

Nightlies need an **active sponsorship** on [GitHub Sponsors](https://github.com/sponsors/debridmediamanager) or [Patreon](https://www.patreon.com/debridmediamanager), linked to the GitHub account that should receive access:

1. Sponsor on GitHub Sponsors or Patreon.
2. Go to [gatekeeper.debridmediamanager.com](https://gatekeeper.debridmediamanager.com/) and press **Connect GitHub Account** — that account is the one granted access.
3. Sponsoring through Patreon? Press **Connect Patreon Account** too, so the pledge can be matched to you. GitHub sponsors need no second link.
4. Press **Complete Registration**.

Sponsoring on Patreon and stopping there grants nothing, because a pledge on its own cannot say which GitHub account is yours. Until access is granted the private repo answers **404** rather than a permission error, which is what a private repo looks like to an account that cannot see it — not a broken link. Access is removed again if the sponsorship lapses.

[Download the binary](https://github.com/debridmediamanager/zurg/releases) or use docker

Instructions on [HOW TO PULL THE PRIVATE DOCKER IMAGE](https://www.patreon.com/posts/guide-to-pulling-105779285)

```sh
docker pull ghcr.io/debridmediamanager/zurg:latest
```

## How to run zurg in 5 steps for Plex with Docker

1. Clone the repo `git clone https://github.com/debridmediamanager/zurg-public.git`
2. Add your token in `config.yml`
3. `sudo mkdir -p /mnt/zurg`
4. Run `docker compose up -d`
5. `time ls -1R /mnt/zurg` You're done! If you do edits on your config.yml just do `docker compose restart zurg`.

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
