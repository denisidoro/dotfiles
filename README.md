Dotfiles
===================

Awesome personal dotfiles.

![Demo](https://user-images.githubusercontent.com/3226564/54047455-d5997200-41b5-11e9-8db7-e9c3ae62328d.png)

### Calling scripts

```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
echo 'alias dot=$HOME/.dotfiles/bin/dot' >> $HOME/.bashrc
exec $SHELL
dot <args>... # eg: dot rice pipes
```

### Installing the full experience 

```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
~/.dotfiles/bin/dot self install
dot <args>... # eg: dot rice pipes
```

### Updating

```sh
dot self update
```

### Overriding configs

Edit the following files accordingly:

```sh
# shell
~/.dotfiles/local/zshrc

# git
~/.dotfiles/local/gitconfig
```
