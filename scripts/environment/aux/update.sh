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

   log::note "Setting up folder and file hierarchy..."
   mkdir -p "$LOCAL_BIN" || true
   touch "$LOCAL_ZSHRC" || true
   touch "$LOCAL_GITCONFIG" || true

}


# ==============================
# Submodules
# ==============================

update_submodules() {

   log::note "Attempting to update submodules..."
   cd "$DOTFILES"
   git pull 
   git submodule init 
   git submodule update
   git submodule status
   git submodule update --init --recursive "${DOTBOT_DIR}" 

}


# ==============================
# Prompts
# ==============================

setup_git_credentials() {
 
   if ! grep -q "email" "$LOCAL_GITCONFIG" 2> /dev/null; then
      log::warning "Your git credentials aren't setup"
      local readonly fullname="$(feedback::text "What is your name?")"
      local readonly email="$(feedback::text "What is your email?")"
      echo -e "[user]\n   name = $fullname\n   email = $email" > "$LOCAL_GITCONFIG"
   fi

}

setup_docopts() {
 
   if ! platform::command_exists python; then
      log::warning "Python isn't installed"
      if ! feedback::confirmation "Do you want to use bash for docopts?"; then
         echo "export DOTFILES_DOCOPTS=bash" >> "$LOCAL_ZSHRC"
      fi
   fi

}

replace_file() {
 
   local readonly FILE_PATH="$1"
   if fs::is_file "$FILE_PATH"; then
     echo "${FILE_PATH} already exists and it's not a symlink"
     if feedback::confirmation "Do you want to remove it?"; then
       rm "$FILE_PATH"
     fi
   fi

}

install_brew() {
   dot pkg add brew
}

install_packages() {
   echo TODO
}


# ==============================
# Plugins
# ==============================

install_nvim_plugins() {

   if platform::command_exists nvim && feedback::confirmation "Do you want to install neovim plugins?"; then
     log::note "Installing neovim plugins..."
     nvim +silent +PlugInstall +qall >/dev/null
   fi

}

install_tmux_plugins() {

   if platform::command_exists tmux && feedback::confirmation "Do you want to install tmux plugins?"; then
     log::note "Installing tpm plugins..."
     export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
     bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/install_plugins" >/dev/null
     bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/update_plugins" all >/dev/null
   fi

}

install_zplug_plugins() {

   if platform::command_exists zplug && feedback::confirmation "Do you want to install tmux plugins?"; then
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
