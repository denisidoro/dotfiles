#/usr/bin/env bash

source "${DOTFILES}/scripts/core/main.sh"

win::user() {
   echo "${USER^}" \
      | cut -d'.' -f1
}

win::nircmd() {
   "$NIRCMD_PATH" "$@"
}

WIN_USER=${WIN_USER:-$(win::user)}
DEFAULT_DRIVE_PATH="/mnt/c"
PORTABLE_PATH="${PORTABLE_PATH:-"${DEFAULT_DRIVE_PATH}/Portable"}"
NIRCMD_PATH="${NIRCMD_PATH:-"${PORTABLE_PATH}/NirCmd/nircmdc.exe"}"
WIN_HOME="${WIN_HOME:-"${DEFAULT_DRIVE_PATH}/Users/${WIN_USER}"}"
STARTMENU_PATH="${STARTMENU_PATH:-"${WIN_HOME}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Applications"}"
