#!/bin/sh
# macOS system preferences. Not sourced by anything — run once per machine:
#   sh ~/.config/macos/defaults.sh
# Then log out and back in; the settings below are read at login.
# Safe to re-run; re-asserts anything an OS upgrade reset.

set -e

# Stop Finder writing .DS_Store files to volumes that aren't this Mac's disk,
# so flash drives and shared folders don't get littered with them.
# Note: USB covers USB-attached disks only. Apple never shipped an equivalent
# for Thunderbolt or direct SATA/NVMe enclosures, so those still get .DS_Store.
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Done. Log out and back in for these to take effect."
