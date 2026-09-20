#!/bin/sh
# brightness.sh - adjust screen brightness and show progress in dunst
# Usage: brightness.sh up|down

STEP=5
NOTIF_ID=9992

case "$1" in
  up)
    brightnessctl set +${STEP}%
    ;;
  down)
    brightnessctl set ${STEP}%-
    ;;
esac

# Calculate current brightness percentage
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
PERCENT=$(( CURRENT * 100 / MAX ))

# Pick icon based on brightness level
if [ "$PERCENT" -ge 70 ]; then
    ICON="display-brightness-high"
elif [ "$PERCENT" -ge 30 ]; then
    ICON="display-brightness-medium"
else
    ICON="display-brightness-low"
fi

dunstify -r "$NOTIF_ID" -i "$ICON" -h int:value:"$PERCENT" -t 1500 "Brightness: ${PERCENT}%"
