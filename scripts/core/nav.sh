#!/usr/bin/env bash

source "${DOTFILES}/scripts/core/str.sh"
source "${DOTFILES}/scripts/core/log.sh"

# ===============
# input
# ===============

input::parse_cwd() {
   if [[ $action = "browse" ]] && [[ $# -gt 0 ]] && [[ $CWD = "/" ]]; then
      CWD="$1"
   fi
}

input::parse() {
   readonly first_arg="${1:-}"
   variable=""
   for arg in "$@"; do
      if [[ $arg = --* ]]; then
         variable="$(echo "$arg" | sed 's/\-\-//')"
      elif [[ -n $variable ]]; then
         eval "$variable"='"$arg"'
         variable=""
      else
         args+=("$arg")
      fi
   done
   action="${action:-browse}"
   CWD="${cwd:-$(path::start "$action" "$first_arg" | path::hacks)}"
   path="${path:-}"
   input::parse_cwd "$@"
}


# ===============
# string
# ===============

str::starts_with_slash() {
   local -r txt="${1:-}"
   local -r first_char="${txt:0:1}"
   [[ $first_char = "/" ]]
}

str::ends_with_slash() {
   case "${1:-}" in
      */) return 0 ;;
      *) return 1 ;;
   esac
}

str::remove_double_slashes() {
   sed 's|//|/|g'
}

str::remove_trailing_slash() {
   sed 's:/*$::'
}

str::add_leading_slash() {
   local -r path="$(cat)"
   if str::starts_with_slash "$path"; then
      echo "$path"
   else
      echo "/${path}"
   fi
}

str::add_trailing_slash() {
   local -r path="$(cat)"
   if str::ends_with_slash "$path"; then
      echo "$path"
   else
      echo "${path}/"
   fi
}

# ===============
# path
# ===============

path::is_root() {
   [[ "$1" = "/" ]]
}

path::start() {
   local -r action="$1"
   local -r arg="${2:-}"

   if [[ $action = "browse" ]] && [[ -n "$arg" ]]; then
      echo "$arg"
   else
      echo "/"
   fi
}

path::parse_dots() {
   local -r path="$(cat)"

   dirs=()
   for p in $(echo "$path" | tr '/' '\n'); do
      case $p in
         .) ;;
         ..) unset 'dirs[${#dirs[@]}-1]' ;;
         *) dirs+=("$p") ;;
      esac
   done

   local -r base="$(echo "/${dirs[*]:-}" | tr ' ' '/')"
   if [[ "$path" = *.. ]] || path::is_navigable "$path"; then
      echo "${base}/"
   else
      echo "$base"
   fi
}

path::fallback_to_root() {
   local -r path="$(cat)"
   if [[ -n $path ]]; then
      echo "$path"
   else
      echo "/"
   fi
}

path::intermediate_hacks() {
   str::remove_trailing_slash "$@"
}

path::hacks() {
   path::intermediate_hacks \
      | path::fallback_to_root \
      | str::add_leading_slash \
      | str::remove_double_slashes \
      | path::fallback_to_root \
      || echo "" \
      | path::fallback_to_root
}

path::resolve() {
   local -r folder="${1:-}"
   echo "${CWD}/${folder}" \
      | str::remove_double_slashes \
      | path::parse_dots 2> /dev/null \
      | path::hacks
}

path::is_navigable() {
   return 0
}

path::all() {
   echo "TODO: path::all"
}


# ===============
# nav
# ===============

nav::ls() {
   echo "TODO: nav::ls"
}

nav::ls_with_dot_dot() {
   if ! path::is_root "$CWD"; then
      echo '..'
   fi
   nav::ls
}

nav::cd() {
   CWD="$1"
}

nav::open() {
   local -r path="$1"

   if path::is_navigable "$path"; then
      nav::cd "$path"
      action::browse
   else
      action::browse
   fi
}


# ===============
# action
# ===============

action::before_exit() {
   exit 0
}

action::browse() {
   local -r selection="$(nav::ls_with_dot_dot | fzf::call)"

   if [[ -z "$selection" ]]; then
      action::before_exit "$selection"
      exit 0
   fi

   local -r path="$(path::resolve "$selection")"
   nav::open "$path"
}

action::handle_abort() {
   log::err "Invalid action: ${action:-unknown}"
   exit 1
}

action::handle_extra() {
   action::handle_abort "$@"
}

action::view() {
   echo "TODO: action::view"
}

action::handle() {
   case $action in
      preview) action::view "$(path::resolve "$path")" ;;
      browse) action::browse ;;
      jump) action::jump ;;
      view) action::view "$(path::resolve "$path")" < /dev/tty > /dev/tty ;;
      *) action::handle_extra "$@" ;;
   esac
}

action::jump() {
   local -r path="$(path::all | fzf::call --preview-window 'down:33%')"
   local args=()
   IFS=' ' read -r -a args <<< $(fzf::default_args)
   "$0" --action browse "${args[@]:-}" --cwd "$path"
}


# ===============
# fzf
# ===============

fzf::default_args() {
   printf ''
}

fzf::extra_bindings() {
   printf ''
}

fzf::bindings() {
   local -r args="$(fzf::default_args)"
   echo "ctrl-h:execute(echo ..)+abort"
   echo "ctrl-j:execute($0 --action jump $args)+abort"
   echo "ctrl-v:execute($0 --action view --cwd $CWD --path {} $args)"
   fzf::extra_bindings
   printf "ctrl-space:abort"
}

fzf::call() {
   fzf-tmux \
      --ansi \
      --cycle \
      --reverse \
      --no-sort \
      --inline-info \
      --height '90%' \
      --no-border \
      --header "$CWD" \
      --preview "$0 --action preview --cwd $CWD --path {} $(fzf::default_args)" \
      --preview-window 'right:66%' \
      --nth 1 \
      --bind "$(fzf::bindings | tr '\n' ',')" \
      "$@"
}
