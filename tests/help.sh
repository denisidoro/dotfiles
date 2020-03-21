#!/usr/bin/env bash
# vim: filetype=sh

without_dot_slash() {
   sed 's|\./||g'
}

_execs() {
   cd "${DOTFILES}/scripts"
   find . -type f -executable -print \
      | grep -v node_modules \
      | grep -v './core' \
      | without_dot_slash
}

_scripts() {
   cd "${DOTFILES}/scripts"
   find . -maxdepth 2 -type f \
      | grep -v '/core/' \
      | grep -v '.clj$' \
      | grep -v '.json$' \
      | grep -v '.edn$' \
      | without_dot_slash
}

_bins() {
   echo -e "$(_scripts)\n$(_execs)" \
      | sort -u
}

assert_help() {
   local -r bin="$1"
   local -r words="$(echo "$bin" | tr -d '.' | tr '/' ' ' | xargs)"
   local -r ctx="$(echo "$words" | awk '{print $1}')"
   local -r cmd="$(echo "$words" | awk '{print $2}')"

   dot "$ctx" "$cmd" --help | grep -q Usage
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

test::set_suite "bash - help"

for bin in $(_bins); do
   case $bin in
      "clojure/data") platform::command_exists clojure && test_fn=test::run || test_fn=test::skip ;;
      "shell/zsh") platform::command_exists zsh && test_fn=test::run || test_fn=test::skip ;;
      *) test_fn=test::run ;;
   esac
   $test_fn "${bin} has a help command" assert_help "$bin"
done

cd "$DOTFILES/scripts"
for f in $(); do
   context="$(echo "$f" | cut -d'/' -f2)"
   command="$(echo "$f" | cut -d'/' -f3)"
   test::run "$f - eval_help works" print_health "$context" "$command"
done
