#!/bin/sh

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

case "$1" in
  full)
    grim "$FILE"
    ;;
  area)
    grim -g "$(slurp)" "$FILE"
    ;;
  *)
    grim "$FILE"
    ;;
esac

[ -f "$FILE" ] || exit 1

wl-copy < "$FILE"

dunstify -i "$FILE" "Screenshot saved" "$FILE"
