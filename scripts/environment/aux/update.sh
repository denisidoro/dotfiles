# ==============================
# Constants
# ==============================

DOTBOT_DIR="modules/dotbot"
DOTBOT_BIN="bin/dotbot"

LOCAL_BIN="${DOTFILES}/local/bin"
LOCAL_ZSHRC="${DOTFILES}/local/zshrc"
LOCAL_GITCONFIG="${DOTFILES}/local/gitconfig"


# ==============================
# Helpers
# ==============================

has_tag() {
   str::contains "$@"
}

get_git_info() {
  cd "$DOTFILES" 
  git log -n 1 --pretty=format:'%ad - %h' --date=format:'%Y-%m-%d %Hh%M' \
     || echo "unknown version"
}


# ==============================
# Filesystem
# ==============================

setup_folders_and_files() {

   echo
   log::note "Setting up folder and file hierarchy..."
   mkdir -p "$LOCAL_BIN" || true
   touch "$LOCAL_ZSHRC" || true
   touch "$LOCAL_GITCONFIG" || true

}


# ==============================
# Fixes
# ==============================

fix_locales() {
  if locale > /dev/null | grep -q annot; then
    locale-gen en_US en_US.UTF-8
  fi 
}


# ==============================
# Prompts
# ==============================

setup_git_credentials() {
 
   if ! grep -q "email" "$LOCAL_GITCONFIG" 2> /dev/null; then
      echo
      log::note "Your git credentials aren't setup"
      local readonly fullname="$(feedback::text "What is your name?")"
      local readonly email="$(feedback::text "What is your email?")"
      echo -e "[user]\n   name = $fullname\n   email = $email" > "$LOCAL_GITCONFIG"
   fi

}

setup_docopts() {
 
   if [[ -n "${DOT_DOCOPTS:-}" ]]; then
      return 0
   else
      echo
      local readonly backend="$(echo "bash python go" | tr ' ' '\n' | feedback::select_option "What backend do you want for docopts?")"
   fi

   if [[ -z "${backend:-}" ]]; then
      log::error "Invalid option"
      exit 3
   fi

   echo "export DOT_DOCOPTS=$backend" >> "$LOCAL_ZSHRC"

   case $backend in
      go) dot pkg add docopts-go;;
      python) dot pkg add python;;
      bash) dot pkg add docoptsh;;
   esac

}

replace_file() {
 
   local readonly FILE_PATH="$1"
   if fs::is_file "$FILE_PATH" && ! test -L "$FILE_PATH"; then
     log::warning "${FILE_PATH} already exists and it's not a symlink"
     if feedback::confirmation "Do you want to remove it?"; then
       rm "$FILE_PATH"
     fi
   fi

}

setup_nvim_fallback() {
   
   if ! platform::command_exists nvim; then
     echo
     log::warning "neovim isn't installed"
     if feedback::confirmation "Do you want to setup a fallback?"; then
        if ! platform::command_exists vim; then
           sudo ln -s "$(which vi)" "/usr/bin/vim" || true
        fi
        sudo ln -s "$(which vim)" /usr/bin/nvim
     fi
   fi

}

setup_sudo_fallback() {
   
   if ! platform::command_exists sudo; then
     echo
     log::warning "the sudo command doesn't exist in this system"
     if feedback::confirmation "Do you want to setup a fallback?"; then
        mkdir -p /usr/local/bin || true
        mkdir -p /tmp/dotfiles || true
        echo -e '#!/usr/bin/env bash\n\n"$@"' > /tmp/dotfiles/sudo
        chmod +x /tmp/dotfiles/sudo
        mv /tmp/dotfiles/sudo /usr/local/bin/sudo
     fi
   fi

}

install_brew() {
   dot pkg add brew
}

install_batch() {
   dot pkg batch prompt "$1"
}


# ==============================
# Plugins
# ==============================

install_nvim_plugins() {

   if platform::command_exists nvim && echo && feedback::confirmation "Do you want to install neovim plugins?"; then
     log::note "Installing neovim plugins..."
     nvim +silent +PlugInstall +qall >/dev/null
   fi

}

install_tmux_plugins() {

   if platform::command_exists tmux && echo && feedback::confirmation "Do you want to install tmux plugins?"; then
     log::note "Installing tpm plugins..."
     export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
     bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/install_plugins" >/dev/null
     bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/update_plugins" all >/dev/null
   fi

}

install_zplug_plugins() {

   if platform::command_exists zplug && echo && feedback::confirmation "Do you want to install tmux plugins?"; then
     log::note "Installing ZPlug plugins..."
     zplug install 2>/dev/null
   fi

}


# ==============================
# Symlinks and custom configs
# ==============================

update_dotfiles() {

   local readonly CONFIG="${DOTFILES}/symlinks/${1}"
   shift

   echo
   "${DOTFILES}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES}" -c "${CONFIG}" "${@}"
   echo

}

update_dotfiles_common() {
   echo
   update_dotfiles "conf.yaml"
}

update_dotfiles_osx() {
   log::note "Configuring for OSX..."
   update_dotfiles "conf.osx.yaml"
}

update_dotfiles_linux() {
   log::note "Configuring for Linux..."
   update_dotfiles "conf.linux.yaml"
}

update_dotfiles_wsl() {
   log::note "Configuring for WSL..."
   log::note "No custom config for WSL"
}

update_dotfiles_arm() {
   log::note "Configuring for ARM..."
   log::note "No custom config for ARM"
}

update_dotfiles_x86() {
   log::note "Configuring for x86..."
   log::note "No custom config for x86"
}

update_dotfiles_android() {
   log::note "Configuring for Android..."
   log::note "Installing essential dependencies..."
   pkg install tmux neovim curl git openssh termux-packages ncurses-utils python
}

update_dotfiles_fallback() {
   echo
   log::note "Fallbacking to essential symlinks..."
   ln -s "${DOTFILES}/shell/bashrc" "${HOME}/.bashrc" || true
   ln -s "${DOTFILES}/shell/zshrc" "${HOME}/.zshrc" || true
}


# ==============================
# git
# ==============================

self_update() {
  git fetch
  if [[ $(project_status) = "behind" ]]; then
     cd "$DOTFILES"
     log::note "Attempting to update itself..."
     git pull && exit 0 || log::error "Failed" 
  fi
}

update_submodules() {

   echo
   log::note "Attempting to update submodules..."
   cd "$DOTFILES"
   git pull 
   git submodule init 
   git submodule update
   git submodule status
   git submodule update --init --recursive "${DOTBOT_DIR}" 

}

project_status() {
  local readonly UPSTREAM=${1:-'@{u}'}
  local readonly LOCAL=$(git rev-parse @)
  local readonly REMOTE=$(git rev-parse "$UPSTREAM")
  local readonly BASE=$(git merge-base @ "$UPSTREAM")

  if [[ "$LOCAL" = "$REMOTE" ]]; then
    echo "synced"
  elif [[ "$LOCAL" = "$BASE" ]]; then
    echo "behind"
  elif [[ "$REMOTE" = "$BASE" ]]; then
    echo "ahead"
  else
    echo "diverged"
  fi
}
