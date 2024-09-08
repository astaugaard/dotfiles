#!/usr/bin/env bash

open=`eww windows | grep dash`

if [[ $open == \** ]]; then
    eww close dash
else
    eww open dash
    fish ~/.config/eww/scripts/updateWeather.fish
    eww update todolist="`todohs generateEww todolist eww 10`"
fi
