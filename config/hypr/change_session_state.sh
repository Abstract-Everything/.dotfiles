#!/usr/bin/env bash

function lock_session {
	swaylock \
		--screenshots \
		--clock \
		--indicator \
		--indicator-radius 100 \
		--indicator-thickness 7 \
		--effect-blur 7x5 \
		--effect-vignette 0.5:0.5 \
		--ring-color bb00cc \
		--key-hl-color 880033 \
		--line-color 00000000 \
		--inside-color 00000088 \
		--separator-color 00000000 \
		--grace $1 \
		--fade-in 0.2 \
		-f
}

case "$1" in
	lock)
		lock_session 0
		;;
	lock-graceful)
		lock_session 10
		;;
	logout)
		hyprctl dispatch exit
		;;
	suspend)
		systemctl suspend
		;;
	hibernate)
		systemctl hibernate
		;;
	reboot)
		systemctl reboot
		;;
	poweroff)
		systemctl poweroff
		;;
	*)
		echo "Usage: $0 {lock|lock-graceful|logout|suspend|hibernate|reboot|poweroff}"
		exit 2
esac

exit 0
