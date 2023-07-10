#!/usr/bin/env bash

swayidle -w \
	before-sleep '~/.config/hypr/change_session_state.sh lock-graceful' \
	lock '~/.config/hypr/change_session_state.sh lock-graceful' \
	timeout 300 '~/.config/hypr/change_session_state.sh lock-graceful' \
	timeout 310 'hyprctl dispatch dpms off' \
	resume 'hyprctl dispatch dpms on' \
