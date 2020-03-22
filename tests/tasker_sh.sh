#!/usr/bin/env bash
# vim: filetype=sh

_group_name() {
   source "${DOTFILES}/tasker/sh/wifi.sh"
   group_name "$@"
}

wifi_from_info() {
   local -r network="$1"
   local -r expected="$2"

   local -r txt="$(echo -e "[home]\ncasa\ncasita\nmaison\n\n[work]\ntrabalho\nboulot")"
   local -r info="$(echo -e ">>>>> CONNECTION <<<<<\n\n${network}\n\nMac:123\nIP:456")"

   _group_name "$info" "$txt" \
      | test::equals "$expected"
}

test::set_suite "bash - tasker sh"
test::run "wifi from info - work" wifi_from_info "boulot" "work"
test::run "wifi from info - home" wifi_from_info "casita" "home"
test::run "wifi from info - home" wifi_from_info "casa" "home"
test::run "wifi from info - home" wifi_from_info "maison" "home"
test::run "wifi from info - home" wifi_from_info "foooo" "unknown"
