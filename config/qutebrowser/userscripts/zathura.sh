#!/usr/bin/env bash

print_help() {
	cat <<'HELP'
NAME
    zathura

DESCRIPTION
    Userscript for qutebrowser to download and open selected url in zathura.

USAGE
    Open url in zathura:
        :spawn -u zathura.sh
        :hint links userscript zathura.sh
HELP
}

msg() {
	printf 'message-info "%s"\n' "$*" >"$QUTE_FIFO"
}

msg_error() {
	printf 'message-error "E: %s"\n' "$*" >"$QUTE_FIFO"
}

URL="$QUTE_URL"

if [ -z "$QUTE_FIFO" ]; then
	print_help
	exit 1
fi

file=$(mktemp)
if [ ! -z "$file" ] && ! curl -q "$URL" >"$file"; then
	msg_error "failed to download file $URL"
	exit 1
fi

msg "opening in zathura $file"
zathura "$file"&!
exit 0
