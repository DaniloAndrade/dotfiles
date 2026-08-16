#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Fires via exec-on-workspace-change (aerospace.toml), which reliably sets
# AEROSPACE_FOCUSED_WORKSPACE. An earlier version queried
# `aerospace list-workspaces --focused` instead, wired to the more general
# on-focus-changed callback — that version is preserved in git history at
# commit 4d47248 if this ever needs to be reverted.

for ws in DEV WEB COMM DOCS PERSONAL MONITORING; do
  if [ "$ws" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    sketchybar --set "workspace_${ws}" background.color="$COLOR_WORKSPACE_FOCUSED" label.color="$COLOR_BG"
  else
    sketchybar --set "workspace_${ws}" background.color="$COLOR_BG" label.color="$COLOR_FG"
  fi
done
