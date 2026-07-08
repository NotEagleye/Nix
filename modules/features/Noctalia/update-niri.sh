#!/usr/bin/env bash

PRIMARY=$(jq -r '.mPrimary' ~/.config/noctalia/colors.json)
SURFACE=$(jq -r '.mSurface' ~/.config/noctalia/colors.json)

LAYOUT_FILE="$HOME/.config/niri/cfg/layout.kdl"

sed -i "s/active-color \"#[0-9a-fA-F]*\"/active-color \"${PRIMARY}\"/" "$LAYOUT_FILE"
sed -i "s/inactive-color \"#[0-9a-fA-F]*\"/inactive-color \"${SURFACE}\"/" "$LAYOUT_FILE"
