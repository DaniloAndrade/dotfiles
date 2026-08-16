#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

for ws in DEV WEB COMM DOCS PERSONAL MONITORING; do
  if [ "$ws" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    sketchybar --set "workspace_${ws}" background.color="$COLOR_WORKSPACE_FOCUSED" label.color="$COLOR_BG"
  else
    sketchybar --set "workspace_${ws}" background.color="$COLOR_BG" label.color="$COLOR_FG"
  fi
done
