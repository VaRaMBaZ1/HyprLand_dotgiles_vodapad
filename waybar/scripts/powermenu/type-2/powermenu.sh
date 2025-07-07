#!/usr/bin/env bash

# Uptime и hostname
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Опции
shutdown=' Shutdown'
reboot=' Reboot'
logout='󰍃 Logout'
yes='Yes'
no='No'

# Wofi CMD
wofi_cmd() {
	wofi --dmenu --prompt="Uptime: $uptime"
}

# Confirmation CMD
confirm_cmd() {
	echo -e "$yes\n$no" | wofi --dmenu --prompt="Are you sure?"
}

# Главное меню
run_wofi() {
	echo -e "$shutdown\n$reboot\n$logout" | wofi_cmd
}

# Выполнение команды
run_cmd() {
	selected="$(confirm_cmd)"
	if [[ "$selected" == "$yes" ]]; then
		case $1 in
			'--shutdown') systemctl poweroff ;;
			'--reboot') systemctl reboot ;;
			'--logout') hyprctl dispatch exit;;
		esac
	else
		exit 0
	fi
}

# Запуск
chosen="$(run_wofi)"
case ${chosen} in
    *Shutdown) run_cmd --shutdown ;;
    *Reboot) run_cmd --reboot ;;
    *Logout) run_cmd --logout ;;
esac
