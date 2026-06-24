#!/bin/bash
# Install dotfiles by symlinking user-space files and deploying system files.
# Run from anywhere; resolves paths relative to this script.

set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME_FILES=(
    ".local/bin/auto-rotate"
    ".local/share/libwacom/gpd-pocket3-0113.tablet"
    ".config/autostart/auto-rotate.desktop"
    ".config/monitors.xml"
)

echo "==> Symlinking user files..."
for f in "${HOME_FILES[@]}"; do
    src="$DOTFILES/$f"
    dst="$HOME/$f"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  already linked: $dst"
    elif [ -e "$dst" ]; then
        echo "  backing up existing: $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
        ln -s "$src" "$dst"
    else
        ln -s "$src" "$dst"
        echo "  linked: $dst"
    fi
done

echo ""
echo "==> Deploying system files (requires sudo)..."
SYSTEM_FILES=(
    "etc/udev/rules.d/99-gpd-pocket3-touch.rules"
    "etc/X11/xorg.conf.d/99-touchscreen.conf"
    "usr/local/bin/rotate.sh"
)
for f in "${SYSTEM_FILES[@]}"; do
    src="$DOTFILES/system/$f"
    dst="/$f"
    sudo install -Dm644 "$src" "$dst"
    echo "  installed: $dst"
done
sudo chmod +x /usr/local/bin/rotate.sh
sudo udevadm control --reload-rules

echo ""
echo "==> Applying dconf settings..."
dconf load /org/mate/panel/toplevels/ < "$DOTFILES/dconf/mate-panel-toplevels.conf"
dconf load /org/mate/desktop/session/ < "$DOTFILES/dconf/mate-session.conf"
echo "  panel size and dock settings applied"

echo ""
echo "Done. Log out and back in (or reboot) to apply autostart changes."
