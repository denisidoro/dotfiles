# ==============================
# Helpers
# ==============================

has_tag() {
   str::contains "$@"
}


# ==============================
# Filesystem
# ==============================

export LOCAL_BIN="${DOTFILES}/local/bin"
export LOCAL_TMP="${DOTFILES}/local/tmp"
export LOCAL_ZSHRC="${DOTFILES}/local/zshrc"
export LOCAL_BASHRC="${DOTFILES}/local/bashrc"
export LOCAL_GITCONFIG="${DOTFILES}/local/gitconfig"

export TMP_DIR="$(fs::tmp)"
export BIN_DIR="$(fs::bin)"
export MAIN_BIN_DIR="${DOTFILES}/bin"

setup_folders_and_files() {
   echoerr
   log::note "Setting up folder and file hierarchy..."
   mkdir -p "$LOCAL_BIN" || true
   mkdir -p "$LOCAL_TMP" || true
   mkdir -p "$BIN_DIR" || true
   mkdir -p "$TMP_DIR" || true
   mkdir -p "$LOCAL_BIN" || true
   mkdir -p "$MAIN_BIN_DIR" || true
   touch "$LOCAL_ZSHRC" || true
   touch "$LOCAL_GITCONFIG" || true
}


# ==============================
# Locale
# ==============================

fix_locales() {
   if platform::command_exists locale-gen; then
      echoerr
      log::note "Fixing locales..."
      locale-gen en_US en_US.UTF-8
   fi
}


# ==============================
# Prompts
# ==============================

feedback::maybe() {
   local -r fn="$1"
   local -r value="$2"
   if [ -n "$value" ]; then
      echo "$value"
   else
      shift 2
      "$fn" "$@"
   fi
}

feedback::maybe_text() {
   feedback::maybe feedback::text "$@"
}

feedback::maybe_select_option() {
   feedback::maybe feedback::select_option "$@"
}

feedback::maybe_confirmation() {
   local -r value="$1"
   if [ -n "$value" ]; then
      if $value; then
         return 0
      else
         return 1
      fi
   else
      shift
      feedback::confirmation "$@"
   fi
}


# ==============================
# Git
# ==============================

get_git_info() {
   cd "$DOTFILES"

   git log -n 1 --pretty=format:'%ad - %h' --date=format:'%Y-%m-%d %Hh%M' \
      || echo "unknown version"
}

setup_git_credentials() {

   if ! grep -q "email" "$LOCAL_GITCONFIG" 2> /dev/null; then
      echoerr
      log::note "Your git credentials aren't setup"
      local -r fullname="$(feedback::maybe_text "${DOT_INSTALL_NAME:-}" "What is your name?")"
      local -r email="$(feedback::maybe_text "${DOT_INSTALL_EMAIL:-}" "What is your email?")"
      echoerr -e "[user]\n   name = $fullname\n   email = $email" > "$LOCAL_GITCONFIG"
   fi

}

setup_docopts() {

   if [[ -n "${DOT_DOCOPTS:-}" ]]; then
      return 0
   fi

   echoerr
   local -r backend="$(echo "bash python go" | tr ' ' '\n' | feedback::maybe_select_option "${DOT_INSTALL_DOCOPTS:-}" "What backend do you want for docopts?")"

      if [[ -z "${backend:-}" ]]; then
         log::error "Invalid option"
         exit 3
      fi

      echoerr "export DOT_DOCOPTS=$backend" >> "$LOCAL_ZSHRC"

      case $backend in
         go) dot pkg add docopts-go ;;
         python) dot pkg add python ;;
         bash) dot pkg add docoptsh ;;
      esac

   }


   # ==============================
   # bash
   # ==============================

   ps1_code() {
      echo
      printf '   export PS1="'
      echo "$1\""
   }

   set_random_ps1() {
      if grep -q "PS1" "$LOCAL_BASHRC"; then
         return 0
      fi
      local -r ps1="$(dot shell bash ps1)"
      local -r code="$(ps1_code "$ps1")"
      echo "$code" >> "$LOCAL_BASHRC"
   }


   # ==============================
   # Plugins
   # ==============================

   install_nvim_plugins() {

      if platform::command_exists nvim && echo && feedback::maybe_confirmation "${DOT_INSTALL_NVIM_PLUGINS:-}" "Do you want to install neovim plugins?"; then
         log::note "Installing neovim plugins..."
         nvim +silent +PlugInstall +qall >/dev/null
      fi

   }

   install_tmux_plugins() {

      if platform::command_exists tmux && echo && feedback::maybe_confirmation "${DOT_INSTALL_TMUX_PLUGINS:-}" "Do you want to install tmux plugins?"; then
         log::note "Installing tpm plugins..."
         export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"
         bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/install_plugins" >/dev/null
         bash "${TMUX_PLUGIN_MANAGER_PATH}tpm/bin/update_plugins" all >/dev/null
      fi

   }

   install_zplug_plugins() {

      if platform::command_exists zplug && echo && feedback::maybe_confirmation "${DOT_INSTALL_ZPLUG_PLUGINS:-}" "Do you want to install zplug plugins?"; then
         log::note "Installing ZPlug plugins..."
         zplug install 2>/dev/null
      fi

   }


   # ==============================
   # Symlinks and custom configs
   # ==============================

   update_dotfiles() {
      DOTLINK="${1:-unix}" dot self link set --create-dirs --verbose
   }

   update_dotfiles_common() {
      echoerr
      update_dotfiles
   }

   update_dotfiles_osx() {
      log::note "Configuring for OSX..."
      update_dotfiles "osx"
   }

   update_dotfiles_linux() {
      log::note "Configuring for Linux..."
      update_dotfiles "linux"
   }

   update_dotfiles_wsl() {
      log::note "Configuring for WSL..."
      update_dotfiles "linux"
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
      dot pkg add termux-essentials
   }


   # ==============================
   # git
   # ==============================

   update_submodules() {
      echoerr
      log::note "Attempting to update submodules..."
      cd "$DOTFILES"
      git pull
      git submodule init
      git submodule update
      git submodule status
      for f in $(ls "${DOTFILES}/modules"); do
         git submodule update --init --recursive "$f"
      done
   }
