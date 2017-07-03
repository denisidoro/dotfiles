Dotfiles
===================

Personal dotfiles with [zsh][zsh], [tmux][tmux], [neovim][neovim], [spacemacs][spacemacs], [fzf][fzf], [fasd][fasd] and more.

![term_demo](https://cloud.githubusercontent.com/assets/3226564/22981134/b3a3dca4-f382-11e6-9388-b576fbf6dc49.gif)

### Installation

```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/scripts/environment/init
bash ~/.dotfiles/scripts/environment/dotfiles
```

If the setup went OK you should now have the `dot` command in your `$PATH`.

In order to update the dotfiles:
```sh
dot env dotfiles
```

[zsh]: http://zsh.sourceforge.net
[tmux]: https://github.com/tmux/tmux
[neovim]: https://neovim.io
[spacemacs]: http://spacemacs.org/
[fasd]: https://github.com/clvv/fasd
[fzf]: https://github.com/junegunn/fzf
