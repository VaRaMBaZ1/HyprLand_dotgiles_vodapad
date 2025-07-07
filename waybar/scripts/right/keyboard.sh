#!/bin/bash

previous=""

# Бесконечный цикл
while true; do
    current=$(hyprctl devices | grep 'active keymap' | sed -n '5p' | awk -F': ' '{print toupper(substr($2,1,2))}')

    if [ "$current" != "$previous" ]; then
        echo "$current"
        previous="$current"
    fi

    # Небольшая пауза, чтобы не грузить проц
    sleep 0.2
done
