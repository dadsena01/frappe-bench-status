# bench-status

One-screen dashboard for your Frappe bench. See all your sites, hosts, and apps — then run common commands without leaving the terminal.

![screenshot](screenshot.png)

## Install

```bash
curl -sL https://raw.githubusercontent.com/dadsena01/bench-status/main/install.sh | bash
```

No dependencies beyond what you already have. Run `bench-status` from anywhere after install.

**Uninstall**: delete the symlink (`rm ~/.local/bin/bench-status`) and the script (`rm <bench-dir>/bench-status`).

## How it works

A single bash script that lives in your bench directory. Symlinked to `~/.local/bin/` so it's always in PATH. Reads your bench filesystem — no database queries, no API calls, no config changes.

## Features

### Dashboard

When you run `bench-status`, it shows:

| Column | What it means |
|---|---|
| **Site** | All sites found in `sites/*/site_config.json` |
| **Host** | ✓ if the site has a `/etc/hosts` entry, ✗ if not. Shows `dev` if `developer_mode=1` |
| **Status** | ● live if the bench port is listening, ○ idle if not |

The header bar shows total sites, total apps, port, whether bench is running, and the bench path.

### Interactive actions

| Key | Action | Description |
|---|---|---|
| `m` | **Migrate** | Pick a site → runs `bench --site <s> migrate`. 5-minute timeout. |
| `c` | **Clear cache** | Pick a site → runs `bench --site <s> clear-cache`. 30-second timeout. |
| `o` | **Open in browser** | Pick a site → opens `http://<site>:<port>` in your default browser. |
| `g` | **Git status** | Shows branch, dirty file count, and ahead/behind for every app with a git repo. |
| `b` | **Open in VS Code** | Pick an app → opens `code apps/<app>`. |
| `l` | **Tail error logs** | Shows the last 5 lines of each site's `logs/error.log`. |
| `n` | **New site / app** | Multi-step wizard: create a new app or a new site with app selection. |
| `q` | **Quit** | Exits the menu. |

### New site/app wizard

Press `n` to start:

1. Choose **New app** or **New site**
2. **New app**: enter a name → runs `bench new-app` → runs `bench setup requirements`
3. **New site**: enter a name → pick apps to install by number (space-separated, or 0 for none) → runs `bench new-site` with selected apps → runs `add-to-hosts`

### Auto-show on cd

The install script asks whether you want this. If yes, every time you `cd` into the bench directory, `bench-status` runs automatically. Controlled by a `PROMPT_COMMAND` hook in `.bashrc`.

## Requirements

- **bash 4.3+** — needed for the `pick()` function (uses nameref `local -n`)
- **`bench`** in PATH — obviously
- **`ss`** — for port check (ships with `iproute2` on Linux, installed by default)
- **`python3`** — optional, used for parsing `common_site_config.json`. Falls back to port 8000.

Works on Linux. Should work on macOS if you have the same tools.

## Troubleshooting

| Problem | Fix |
|---|---|
| **Nothing shows up** | Run from inside the bench directory (the script finds its parent folder) |
| **bench-status: command not found** | Make sure `~/.local/bin` is in your PATH. Re-run install if needed. |
| **Sites list is empty** | Check that `sites/*/site_config.json` files exist |
| **Progress bars flood the screen** | They should be filtered out — if not, open an issue |
| **Ctrl+C doesn't work cleanly** | It should — there's a `trap INT` handler. If it leaves the terminal messy, run `reset` |

## Development

The repo is one file that matters — `bench-status`. Edit it, test it:

```bash
./bench-status    # run directly from repo
```

Submit changes via pull request.

### What not to touch

The script explicitly avoids:
- Modifying any file inside `apps/`, `sites/`, or `config/`
- Running any `frappe.*` Python code
- Writing to any database
- Changing bench configuration

It reads:
- `sites/*/site_config.json` (list sites, check developer mode)
- `sites/apps.txt` (count apps)
- `sites/common_site_config.json` (get port)
- `/etc/hosts` (check host entries)
- Process list and port list via `pgrep` and `ss`

It never writes anything unless you explicitly trigger a bench command from the menu.

## Contributing

Issues, feature requests, and pull requests welcome. Feature backlog (not yet implemented):

| Key | Feature |
|---|---|
| `r` | Restart bench web process |
| `u` | Update apps (pull + build + migrate) |
| `k` | Backup a site |
| `d` | Show database sizes |
| `s` | Open Frappe Python console |
| `p` | Show process stats (CPU/memory) |
| `a` | Clear Redis cache |
| `t` | Run tests for an app |
| `=` | Show disk usage |

Open an issue or PR if you want to work on one.

## License

MIT. Do whatever you want with it.
