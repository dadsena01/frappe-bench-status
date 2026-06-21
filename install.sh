#!/usr/bin/env bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/manisherp/bench-status/main"
BIN="$HOME/.local/bin"

echo " Looking for Frappe bench..."

# detect bench directory
BENCH_DIR=""
for guess in "$HOME/frappe-bench" "$HOME/bench" "$PWD" "$(dirname "$(pwd)")"; do
	if [ -f "$guess/sites/common_site_config.json" ]; then
		BENCH_DIR="$guess"
		break
	fi
done

if [ -z "$BENCH_DIR" ]; then
	read -r -p "Could not find bench directory. Enter path: " BENCH_DIR
fi

# download
echo " Downloading bench-status..."
mkdir -p "$BENCH_DIR"
if command -v curl &>/dev/null; then
	curl -sL "$REPO/bench-status" -o "$BENCH_DIR/bench-status"
elif command -v wget &>/dev/null; then
	wget -q "$REPO/bench-status" -O "$BENCH_DIR/bench-status"
else
	echo " Need curl or wget."
	exit 1
fi

chmod +x "$BENCH_DIR/bench-status"

# symlink
mkdir -p "$BIN"
ln -sf "$BENCH_DIR/bench-status" "$BIN/bench-status"

echo " Installed to $BENCH_DIR/bench-status"
echo " Symlinked to $BIN/bench-status"

# bashrc hook
if ! grep -q "bench-status" "$HOME/.bashrc" 2>/dev/null; then
	read -r -p "Add auto-show on 'cd' into bench directory? [Y/n] " yn
	case "$yn" in
		n|N) echo " Skipped." ;;
		*)
			cat >> "$HOME/.bashrc" <<-EOF

# bench-status auto-show
__bench_status_cd() {
	if [[ "\$PWD" == "$BENCH_DIR"* && "\$PWD" != "\$_last_bench_pwd" ]]; then
		_last_bench_pwd="\$PWD"
		command bench-status
	fi
}
PROMPT_COMMAND="__bench_status_cd; \$PROMPT_COMMAND"
EOF
			echo " Added to ~/.bashrc. Run 'source ~/.bashrc' or open a new terminal."
			;;
	esac
fi

echo " Done! Run 'bench-status' to start."
