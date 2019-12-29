<h3 align="center">
  <img width="18" src="https://image.flaticon.com/icons/svg/226/226769.svg" alt="OSX - Icon made by Freepik from Flaticon" />

  <img width="18" src="https://image.flaticon.com/icons/svg/226/226772.svg" alt="Linux - Icon made by Freepik from Flaticon" />

  <img width="18" src="https://image.flaticon.com/icons/svg/174/174836.svg" alt="Android - Icon made by Freepik from Flaticon" />
  denisidoro/dotfiles
</h3>
<p align="center">
  <img src="https://user-images.githubusercontent.com/3226564/54047455-d5997200-41b5-11e9-8db7-e9c3ae62328d.png" alt="denisidoro/dotfiles">
  <sub>Awesome personal dotfiles</sub>
</p>
<p align="center">
  <a href="#-installation">How to</a>&nbsp;&nbsp;&nbsp;
  <a href="shell">Shell</a>&nbsp;&nbsp;&nbsp;
  <a href="scripts">Bash scripts</a>&nbsp;&nbsp;&nbsp;
  <a href="git/config">Git</a>
</p>

## 🚀 Installation
```bash
# with homebrew or linuxbrew
brew install denisidoro/tools/dotfiles

# with git
git clone https://github.com/denisidoro/dotfiles $HOME/dotfiles
$HOME/dotfiles/bin/dot self install
```

## ⌨️ Usage
```bash
dot <cmd> <args>... # dot rice pipes, for example
```

## 🚴‍♂️ Shell startup performance
```bash
λ dot shell zsh test-performance
0.08 real         0.03 user         0.03 sys
```

## 🎯 Overriding configs

Edit the following files accordingly:
```sh
# shell
~/dotfiles/local/zshrc

# git
~/dotfiles/local/gitconfig
```

## 🌟 Inspiration
 * https://github.com/Tuurlijk/dotfiles: Zsh startup snappiness
 * https://github.com/rgomezcasas/dotfiles: fine-tuning
