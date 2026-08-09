# Windows Setup Guide

zurg runs natively on Windows. There are two things Windows needs that Linux and macOS do not: **WinFsp**, and the `--links` rclone flag.

## 1. Install WinFsp

rclone's mount needs WinFsp. Install it from [winfsp.dev](https://winfsp.dev/rel/), or silently from PowerShell:

```powershell
$url = "https://github.com/winfsp/winfsp/releases/download/v2.1/winfsp-2.1.25156.msi"
Invoke-WebRequest -Uri $url -OutFile "$env:TEMP\winfsp.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i", "$env:TEMP\winfsp.msi", "/qn", "/norestart" -Wait
```

Reboot if the installer asks for it.

## 2. Get zurg

Download the Windows zip from [Releases](https://github.com/debridmediamanager/zurg-public/releases) and extract it into a folder you own, e.g. `C:\zurg`. Take the `windows-amd64` zip unless you are on 32-bit Windows, in which case take `windows-386`. Each zip contains a single `zurg.exe`.

## 3. First run

Open PowerShell in that folder and run it once:

```powershell
.\zurg.exe
```

On first run zurg creates `data\`, `dump\`, `logs\`, `strm\` and `bin\`, downloads `ffprobe.exe` and `rclone.exe` into `bin\`, writes a default `config.yml`, and tells you to add your token. You do not need to install rclone or ffmpeg yourself.

## 4. Configure

Edit `config.yml`. A minimal working Windows config:

```yaml
zurg: v1
token: YOUR_RD_API_TOKEN

port: 9999
mount_path: "Z:"

rclone_enabled: true
rclone_binary: bin\rclone.exe
ffprobe_binary: bin\ffprobe.exe
rclone_extra_args:
  - "--links"

directories:
  shows:
    group: media
    group_order: 10
    filters:
      - has_episodes: true
  movies:
    group: media
    group_order: 20
    only_show_the_biggest_file: true
    filters:
      - regex: /.*/
```

Then run `.\zurg.exe` again. The dashboard is at <http://localhost:9999/config/> and your library mounts at `Z:`.

### `--links` is required

Without it, rclone fails to mount and the log shows:

```
ERROR : symlinks not supported without the --links flag: /
```

zurg mounts a union of a local folder (`data\local`, for artwork and `.strm` files) and its own WebDAV server. The local half of that union makes rclone check for symlinks, which errors out on Windows unless `--links` is set. Leave it in `rclone_extra_args`.

### Paths use backslashes

`rclone_binary: bin\rclone.exe` and `ffprobe_binary: bin\ffprobe.exe` — as written above, unquoted. A backslash means nothing special in an unquoted YAML value, so the path stays literal.

`mount_path` is different: a bare drive letter ends in a colon, and `mount_path: Z:` is a YAML syntax error (`mapping values are not allowed here`) that stops zurg from starting. Always quote it: `mount_path: "Z:"`.

## Running it in the background

### Start it at logon (recommended)

The mount belongs to the Windows session that started it, so start zurg from the desktop you actually use. The simplest reliable way is a shortcut in your Startup folder:

1. Press `Win+R`, enter `shell:startup`
2. Put a shortcut to `zurg.exe` there (right-click → New → Shortcut)
3. Set "Start in" to your zurg folder so it finds `config.yml`

To hide the console window, point the shortcut at a one-line VBS wrapper instead:

```vbs
CreateObject("WScript.Shell").Run """C:\zurg\zurg.exe""", 0, False
```

### Why not a service or a scheduled task run over SSH

A WinFsp mount is visible only inside the Windows session that created it. Services and SSH sessions run in **session 0**; your desktop is **session 1 or higher**. So zurg started as a service, or launched by `schtasks /run` over SSH, will mount a drive that your desktop — and therefore Plex, Jellyfin or Explorer — cannot see. The process runs fine and the log looks healthy; the drive just is not there.

A scheduled task with an **At log on** trigger works, because it fires inside your interactive session. Triggering that same task remotely does not.

If you need zurg reachable headlessly, run it without the mount (`rclone_enabled: false`) and consume the WebDAV endpoint at `http://localhost:9999/dav/` directly — Infuse and Kodi can, and Plex can via a separately-mounted drive.

### `--network-mode` is not recommended

Adding `--network-mode` to `rclone_extra_args` makes WinFsp publish a network share (`\\server\zurg{HASH}`) instead of a drive letter. It is visible across sessions, but the generated `{HASH}` suffix is unpredictable and `net use Z: \\server\zurg{HASH}` fails with error 67, so it is not usable for drive-letter mapping.

## Plex library updates

Set `on_library_update` to the PowerShell script shipped in this repo, and edit the Plex URL, token and mount path at the top of it:

```yaml
on_library_update: '& powershell -ExecutionPolicy Bypass -File .\plex_update.ps1 --% "$args"'
```

## Troubleshooting

| Symptom | Cause |
|---|---|
| `symlinks not supported without the --links flag` | `--links` missing from `rclone_extra_args` |
| Mount never appears, no error in the log | zurg was started in another Windows session — start it from your desktop |
| `The system cannot find the file specified` on mount | WinFsp not installed, or a reboot is still pending |
| Drive letter already in use | Change `mount_path` to a free letter |
| zurg starts, library empty | Check the token, then watch the log — a bad token loops on `Failed to get user information` |

Logs are in `logs\`. For a bug report, use <http://localhost:9999/debug/upload> — it uploads your logs and a redacted config.
