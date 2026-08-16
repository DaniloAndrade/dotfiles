#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

MODE=$(aerospace list-modes --current)
MODE_UPPER=$(echo "$MODE" | tr '[:lower:]' '[:upper:]')

case "$MODE" in
  window)
    COLOR="$COLOR_MODE_WINDOW"
    ;;
  resize)
    COLOR="$COLOR_MODE_RESIZE"
    ;;
  service)
    COLOR="$COLOR_MODE_SERVICE"
    ;;
  *)
    COLOR="$COLOR_BG"
    ;;
esac

sketchybar --set aerospace_mode label="$MODE_UPPER" background.color="$COLOR" label.color="$COLOR_FG"
