#!/usr/bin/env bash

# ===============
# input
# ===============

input::parse_cwd() {
  if [[ $action = "browse" ]] && [[ $# -gt 0 ]] && [[ $cwd = "/" ]]; then
     cwd="$1"
  fi
}

input::parse() {
  readonly first_arg="${1:-}"
  variable=""
  for arg in $@; do
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
  cwd="${cwd:-/}"
  path="${path:-}" 
  # input::parse_cwd "$@"
}


# ===============
# string
# ===============

str::remove_double_slashes() {
   sed 's|//|/|g'
}

str::remove_trailing_slash() {
   sed 's:/*$::'
}


# ===============
# path
# ===============

path::is_root() {
   [[ "$1" = "/" ]]
}

path::parse_dots() {
   local readonly path="$(cat)"
   
   dirs=()
   for p in $(echo "$path" | tr '/' '\n'); do
     case $p in
      .) ;;
      ..) unset 'dirs[${#dirs[@]}-1]';;
      *) dirs+=("$p");;
     esac
   done

   echo "/${dirs[@]:-}" \
     | tr ' ' '/'
}

path::fallback_to_root() {
   local readonly path="$(cat)"
   if [[ -n $path ]]; then
      echo "$path"
   else
      echo "/"
   fi
}

path::resolve() {
   local readonly folder="${1:-}"
   echo "${cwd}/${folder}" \
      | str::remove_double_slashes \
      | path::parse_dots 2> /dev/null \
      | str::remove_trailing_slash \
      | path::fallback_to_root \
      || echo "" \
      | path::fallback_to_root
}


# ===============
# nav
# ===============

nav::ls_with_dot_dot() {
   if ! path::is_root "$cwd"; then
      echo '..'
   fi
   nav::ls
}

nav::cd() {
   cwd="$1"
}

nav::open() {
   local readonly path="$1"

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

action::browse() {
   local readonly selection="$(nav::ls_with_dot_dot | fzf::call)"
   
   if [[ -z "$selection" ]]; then
      exit 0
   fi

   local readonly path="$(path::resolve "$selection")"
   nav::open "$path"
}

action::handle() {
  case $action in 
     preview) action::view "$path";;
     browse) action::browse;;
     jump) action::jump;;
     view) action::view "$path" < /dev/tty > /dev/tty;;
  esac
}

action::jump() {
  local readonly path="$(path::all | fzf::call --preview-window 'down:33%')"
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
   local readonly args="$(fzf::default_args)"
   echo "ctrl-h:execute(echo ..)+abort"
   echo "ctrl-j:execute($0 --action jump $args)+abort"
   echo "ctrl-v:execute($0 --action view --cwd $cwd --path {} $args)"
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
      --height '100%' \
      --no-border \
      --header "$cwd" \
      --preview "$0 --action preview --cwd $cwd --path {} $(fzf::default_args)" \
      --preview-window 'right:66%' \
      --nth 1 \
      --bind "$(fzf::bindings | tr '\n' ',')" \
      "$@"
}


# ===============
# abstract
# ===============

# path::is_navigable()
# nav::ls() 
# action::view()
# fzf::default_args()
# fzf::extra_bindings()
