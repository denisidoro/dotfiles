get_setup_platform() {
  case "$(uname -s)" in
    Darwin)
      echo osx
    ;;
    *)
      if command_exists apt
      then
        echo apt
      fi
    ;;
  esac
}

setup_apt() {

  # Add commons 
  sudo apt-get install software-properties-common

  # Add third-party repositories
  for repository in $(from_dependencies "apt-repositories")
  do
    sudo add-apt-repository $repository -y
  done
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Install essential commands
  for package in $(from_dependencies "brew-apt" "apt")
  do 
  sudo apt-get install -y $package
done

}

setup_mac() {

  # Install brew
  if ! command_exists brew ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Install essential commands
  for package in $(from_dependencies "brew-apt" "brew")
  do
    brew install $package
  done

}

setup() {

  # Initial setup
  sudo mkdir -p $HOME/tmp
  platform=$(get_platform)
  dependencies=$(read_dependencies)
  if [[ -z "$platform" ]]; then
    echo "Unable to find compatible install commands for your platform. Aborting..."
    exit
  else
    echo "Detected platform: $platform"
  fi

  # Invoke platform-specific setup
  case $platform in
    osx) setup_mac;;
  apt) setup_apt;;
  esac

  # Install fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install

  # Install vim-plug
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  http://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Install tpm
  git clone https://github.com/tmux-plugins/tpm --depth=1 $HOME/.tmux/plugins/tpm

  # Install tmuxinator
  gem install tmuxinator

  # Install docopts dependencies
  if ! command_exists pip 
    then
    curl https://bootstrap.pypa.io/get-pip.py | sudo python
  fi
  sudo pip install docopts

  # Setup dotfiles
  cd $HOME/.dotfiles
  bash install

  # Cleanup
  rm -rf $HOME/tmp
  cd $HOME

}
