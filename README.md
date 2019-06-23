Dotfiles
===================

Awesome personal dotfiles.

![Demo](https://user-images.githubusercontent.com/3226564/54047455-d5997200-41b5-11e9-8db7-e9c3ae62328d.png)

### Calling scripts

```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
~/.dotfiles/bin/dot <args>... # eg: ~/.dotfiles/bin/dot rice pipes
```

### Installing the full experience 

```sh
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
~/.dotfiles/bin/dot self install
```

If the setup finished successfully, you should now have the `dot` command in your `$PATH`.

### Updating

```sh
dot self update
```

### Overriding configs

Edit the following files accordingly:

```
shell: ~/.dotfiles/local/zshrc
git: ~/.dotfiles/local/gitconfig
```
