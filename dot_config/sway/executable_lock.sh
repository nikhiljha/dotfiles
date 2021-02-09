#!/usr/bin/env bash

source "$HOME/.cache/wal/colors.sh"

swaylock \
  --image "$HOME/.config/sway/background.png" \
  --indicator-radius 160 \
  --indicator-thickness 20 \
  --inside-color 00000000 \
  --inside-clear-color 00000000 \
  --inside-ver-color 00000000 \
  --inside-wrong-color 00000000 \
  --key-hl-color "$color1" \
  --bs-hl-color "$color2" \
  --ring-color "$background" \
  --ring-clear-color "$color2" \
  --ring-wrong-color "$color5" \
  --ring-ver-color "$color3" \
  --line-uses-ring \
  --line-color 00000000 \
  --font 'FiraCode Nerd Font Mono,Regular 40' \
  --text-color 00000000 \
  --text-clear-color 00000000 \ #"$color2" \
  --text-wrong-color 00000000 \ #"$color5" \
  --text-ver-color 00000000 \ #"$color4" \
  --separator-color 00000000 \
