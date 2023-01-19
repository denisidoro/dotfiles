#!/usr/bin/env bash

without_dot_slash() {
   sed 's|\./||g'
}

_execs() {
   cd "${DOTFILES}/scripts" || exit
   find . -type f -executable -print \
      | grep -v node_modules \
      | grep -v './core' \
      | without_dot_slash
}

_scripts() {
   cd "${DOTFILES}/scripts" || exit
   find . -maxdepth 2 -type f \
      | grep -v '/core/' \
      | grep -v '.clj$' \
      | grep -v '.json$' \
      | grep -v '.edn$' \
      | grep -v 'rust/call$' \
      | grep -v 'rust/run$' \
      | without_dot_slash
}

_bins() {
   echo -e "$(_scripts)\n$(_execs)" \
      | grep -v '.DS_Store' \
      | grep -v '^termux/' \
      | sort -u
}

assert_help() {
   local -r bin="$1"
   local -r words="$(echo "$bin" | tr -d '.' | tr '/' ' ' | xargs)"
   local -r ctx="$(echo "$words" | awk '{print $1}')"
   local -r cmd="$(echo "$words" | awk '{print $2}')"

   dot "$ctx" "$cmd" --help | cat | grep -Eq 'Usage|USAGE|usage' 
}

_with_eval_help() {
   grep 'eval_help' -Rl . \
      | grep -v core \
      | sort -u \
      | without_dot_slash
}

print_health() {
   dot "$@" --help | grep -q Usage
}

test::set_suite "bash | help"

_run() {
   for bin in $(_bins); do
      case $bin in
         *zsh) has zsh && test_fn=test::run_with_retry || test_fn=test::skip ;;
         *password) test_fn=test::skip ;;
         *) test_fn=test::run ;;
      esac
      $test_fn "${bin} has a help command" assert_help "$bin"
   done

   cd "$DOTFILES/scripts" || exit
   for f in $(); do
      context="$(echo "$f" | cut -d'/' -f2)"
      command="$(echo "$f" | cut -d'/' -f3)"
      test::run "$f - eval_help works" print_health "$context" "$command"
   done
}

test::lazy_run _run