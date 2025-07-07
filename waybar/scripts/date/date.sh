#!/bin/bash

time=$(date '+%H:%M %a, %d %b %Y' | sed 's/Mon/Пн/; s/Tue/Вт/; s/Wed/Ср/; s/Thu/Чт/; s/Fri/Пт/; s/Sat/Сб/; s/Sun/Вс/; s/Jan/янв/; s/Feb/фев/; s/Mar/мар/; s/Apr/апр/; s/May/май/; s/Jun/июн/; s/Jul/июл/; s/Aug/авг/; s/Sep/сен/; s/Oct/окт/; s/Nov/ноя/; s/Dec/дек/')

calendar=$(cal -m)

# Удаляем кавычки и экранируем переносы строк
calendar_escaped=$(echo "$calendar" | sed ':a;N;$!ba;s/\n/\\n/g')

echo "{\"text\": \"$time\", \"tooltip\": \"$calendar_escaped\"}"
