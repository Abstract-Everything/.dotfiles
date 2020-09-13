#!/usr/bin/env bash

function check_installed_program
{
	if ! type $1 >/dev/null
	then
		echo "Error: ${1} is not installed, aborting."
		exit
	fi
}
