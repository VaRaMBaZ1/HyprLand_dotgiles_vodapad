#!/bin/bash

# Путь для хранения истории вычислений
HISTORY_FILE="$HOME/.cache/rofi-calc-history"

# Создаем файл истории, если он не существует
mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"

# Функция для обработки вычислений
calculate() {
    local expr="$1"
    # Удаляем пробелы в начале и конце
    expr=$(echo "$expr" | sed 's/^[ \t]*//;s/[ \t]*$//')
    # Вычисляем выражение с помощью qalc
    result=$(qalc -t "$expr" 2>/dev/null | tr -d '\n')
    if [ -n "$result" ]; then
        # Выводим результат в message
        echo -e "\0message\x1f$result"
        # Копируем результат в буфер обмена
        echo -n "$result" | xclip -selection clipboard
        # Добавляем выражение и результат в историю
        echo "$expr = $result" >> "$HISTORY_FILE"
    else
        echo -e "\0message\x1fОшибка в выражении"
    fi
}

# Если Rofi передает ввод (RETV=1 или 2)
if [ -n "$ROFI_RETV" ]; then
    case $ROFI_RETV in
        0)  # Начальный запуск: выводим историю
            cat "$HISTORY_FILE"
            ;;
        1)  # Пользователь ввел текст и нажал Enter
            input="$@"
            if [[ "$input" == =* ]]; then
                # Удаляем '=' из начала выражения
                expr="${input#=}"
                calculate "$expr"
            else
                # Если не начинается с '=', ничего не делаем (drun обработает)
                exit 0
            fi
            ;;
        2)  # Пользователь выбрал элемент из истории
            input="$@"
            # Извлекаем выражение до '=' из исторической записи
            expr=$(echo "$input" | cut -d'=' -f1 | sed 's/[ \t]*$//')
            calculate "$expr"
            ;;
    esac
    exit 0
fi

# Начальный запуск: выводим историю
cat "$HISTORY_FILE"