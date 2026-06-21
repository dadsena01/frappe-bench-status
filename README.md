# bench-status

See all your Frappe sites, hosts, apps — plus run common commands — from one screen. No install, no setup fuss.

![screenshot](screenshot.png)

## Install

```bash
curl -sL https://raw.githubusercontent.com/manisherp/bench-status/main/install.sh | bash
```

That's it. Run `bench-status` from anywhere after.

## What it shows

- All sites on this bench (scans `sites/*/site_config.json`)
- Which ones have entries in `/etc/hosts`
- Which ones are live (port is listening)
- Developer mode sites highlighted separately
- Total apps installed, bench directory, port

## What you can do

| Key | Action |
|---|---|
| `m` | migrate a site |
| `c` | clear cache on a site |
| `o` | open a site in browser |
| `g` | git status across all apps |
| `b` | open an app in VS Code |
| `l` | tail last 5 error log lines per site |
| `n` | create a new app or new site (picks which apps to install) |
| `q` | quit |

## Auto-show on cd

The install script asks if you want this. If you say yes, running `cd ~/frappe-bench` (or wherever your bench is) shows the status automatically.

## How it works

One bash script. Sits in your bench directory. Symlinked to `~/.local/bin/`. No Python, no node, no Frappe app install. Zero changes to bench core.

## Requirements

- bash 4.3+ (for nameref in the pick function)
- `bench` in PATH (obviously)
- `ss` (for port check — comes with iproute2 on Linux)
- optional: `python3` (for parsing JSON — falls back to port 8000)

Works on Linux. Probably works on macOS too if you have the tools — let me know.
