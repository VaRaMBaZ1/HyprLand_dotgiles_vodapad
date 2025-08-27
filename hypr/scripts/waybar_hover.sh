#!/bin/bash

# Порог активации (зона в верхней части экрана)
ACTIVATION_THRESHOLD=40

# Переменная для отслеживания состояния Waybar (1 = запущен, 0 = не запущен)
WAYBAR_STATUS=0

while true; do
    # Получаем координату Y курсора
    CURSOR_Y=$(hyprctl cursorpos -j | jq -r '.y')
    
    # Проверяем, находится ли курсор в зоне активации
    if (( CURSOR_Y < ACTIVATION_THRESHOLD )); then
        # Если курсор в зоне и Waybar не запущен, запускаем его
        if [ "$WAYBAR_STATUS" -eq 0 ]; then
            waybar &
            WAYBAR_STATUS=1
            sleep 0.5 # Даём Waybar время на запуск
        fi
    else
        # Если курсор вне зоны и Waybar запущен, завершаем процесс
        if [ "$WAYBAR_STATUS" -eq 1 ]; then
            pkill waybar
            WAYBAR_STATUS=0
            sleep 0.5 # Даём Waybar время на завершение
        fi
    fi
    
    # Небольшая задержка, чтобы избежать слишком частых проверок
    sleep 0.1
done