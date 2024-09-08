#!/usr/bin/env bash

xprop -spy -root _NET_ACTIVE_WINDOW | while read -r; do
    xdotool getwindowfocus getwindowname
done | cut -c -80

