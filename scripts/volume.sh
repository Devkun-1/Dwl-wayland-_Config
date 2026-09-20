#!/bin/sh
# volume.sh - adjust volume and show progress in dunst
# Usage: volume.sh up|down|mute

STEP=5
# Fixed notification ID so dunst replaces the previous popup instead of stacking
NOTIF_ID=9991

case "$1" in
  up)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%+
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%-
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
esac

# Get current volume info from wpctl
VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$VOL_RAW" | awk '{print int($2 * 100)}')
MUTED=$(echo "$VOL_RAW" | grep -q "MUTED" && echo "yes" || echo "no")

if [ "$MUTED" = "yes" ]; then
    ICON="audio-volume-muted"
    TITLE="Volume Muted"
else
    # Pick icon based on volume level
    if [ "$VOL" -ge 70 ]; then
        ICON="audio-volume-high"
    elif [ "$VOL" -ge 30 ]; then
        ICON="audio-volume-medium"
    else
        ICON="audio-volume-low"
    fi
    TITLE="Volume: ${VOL}%"
fi

# Show notification with progress bar (hint value=VOL creates the bar)
dunstify -r "$NOTIF_ID" -i "$ICON" -h int:value:"$VOL" -t 1500 "$TITLE"
