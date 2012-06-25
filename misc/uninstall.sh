#!/bin/sh

# Banshee
rm -r "$APPDATA/banshee-1"

# LibreOffice
rm "$PROGRAMFILES"/LibreOffice*
rm -r "$APPDATA/LibreOffice"

# Microsoft Office
rm -r "$APPDATA/Microsoft/Office"
rm -r "$LOCALAPPDATA/Microsoft/Office"

# Qbittorrent
rm -rf "$APPDATA/qBittorrent"
rm -rf "$LOCALAPPDATA/qBittorrent"
# Bash doesnt allow parenthesis in variable name.
rm -rf "$PROGRAMFILES/qBittorrent"
