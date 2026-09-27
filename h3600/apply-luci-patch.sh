#!/bin/sh
# Add the "Hardware LAN switching" checkbox to LuCI's firewall page, the only
# H3600 change to the feeds. Run after ./scripts/feeds update; safe to re-run.
#   apply-luci-patch.sh [tree]    (default: this OpenWrt tree; "." in the SDK)
set -e
P="$(cd "$(dirname "$0")" && pwd)/luci-app-firewall-hardware-LAN-switching.patch"
TREE=$(cd "${1:-$(dirname "$0")/..}" && pwd)

if git -C "$TREE/feeds/luci" apply --reverse --check "$P" 2>/dev/null; then
	echo "luci: already applied"
else
	git -C "$TREE/feeds/luci" apply "$P"
	echo "luci: applied"
fi
