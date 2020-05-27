#!/usr/bin/env bash

_get_source() {
   local -r extended="$1"
   local -r language="$2"

   local -r backtick='`'
   local -r triple_backtick="${backtick}"
   local -r pattern="${triple_backtick}${language}"

   _extended_fn() {
      grep -m1 "$triple_backtick" -B999
   }

   _vanilla_fn() {
      grep "$triple_backtick" -A999
   }

   $extended && filter_fn=_extended_fn || filter_fn=_vanilla_fn

   cat "${DOTFILES}/docs/transpile.md" \
      | sed -n "/${pattern}/,/${triple_backtick}/p" \
      | grep -v "$pattern" \
      | $filter_fn \
      | grep -v "$triple_backtick"
}

_get_extended_source() {
   _get_source true "$@"
}

_get_vanilla_source() {
   _get_source false "$@"
}

_gen_extended() {
   local -r language="$1"
   local -r filepath="$2"
   _get_extended_source "$language" > "$filepath"
}

_transpile() {
   local -r extension="$1"
   local -r filepath="${TEST_DIR}/code.${extension}"
   _gen_extended "$extension" "$filepath"
   dot code transpile "$filepath" || true
   local -r actual="$(cat "$filepath")"
   local -r expected="$(_get_vanilla_source "$extension" | xargs)"
   echo "$actual" | xargs | test::equals "$expected"
}

test::set_suite "rust - go"
test::run "transpile" _transpile "go"

test::set_suite "rust - bash"
test::run "transpile" _transpile "bash"