Dotfiles
===================

Personal dotfiles with [zsh][zsh], [tmux][tmux], [neovim][neovim], [fzf][fzf], [fasd][fasd] and more.

![term_demo](https://cloud.githubusercontent.com/assets/3226564/22981134/b3a3dca4-f382-11e6-9388-b576fbf6dc49.gif)

### Installation

If you already have all the dependencies:
```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git pull && git submodule init && git submodule update && git submodule status
bash install
```

If you want to download all dependencies then install the dotfiles:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/denisidoro/dotfiles/master/scripts/setup-mac.sh)" # OS X
sh -c "$(curl -fsSL https://raw.githubusercontent.com/denisidoro/dotfiles/master/scripts/setup-ubuntu.sh)" # Debian
```

[zsh]: http://zsh.sourceforge.net
[tmux]: https://github.com/tmux/tmux
[neovim]: https://neovim.io
[fasd]: https://github.com/clvv/fasd
[fzf]: https://github.com/junegunn/fzf