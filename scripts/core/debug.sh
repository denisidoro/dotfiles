#!/usr/bin/env bash

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo -e "\e[32m[INF] $@\e[0m" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo -e "\e[93m[WRN] $@\e[0m" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo -e "\e[35m[ERR] $@\e[0m" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo -e "\e[91m[FTL] $@\e[0m" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }
