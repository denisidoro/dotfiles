<h3 align="center">
  <span><img width="18" src="https://image.flaticon.com/icons/svg/226/226769.svg" alt="OSX - Icon made by Freepik from Flaticon" /></span>
  <span><img width="18" src="https://image.flaticon.com/icons/svg/226/226772.svg" alt="Linux - Icon made by Freepik from Flaticon" /></span>
  <span><img width="18" src="https://image.flaticon.com/icons/svg/174/174836.svg" alt="Android - Icon made by Freepik from Flaticon" /></span>
  denisidoro/dotfiles
  <a alt="CI status" href="https://github.com/denisidoro/navi/actions"><img src="https://github.com/denisidoro/dotfiles/workflows/Tests/badge.svg" /></a>
  <a alt="GitHub release" href="https://github.com/denisidoro/dotfiles/releases"><img src="https://img.shields.io/github/v/release/denisidoro/dotfiles?include_prereleases" /></a>
</h3>

<p align="center">
  <img src="https://user-images.githubusercontent.com/3226564/70171435-78334280-16ad-11ea-8e2d-3388b2fb5085.gif" alt="Demo">
  <br>
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
git clone https://github.com/denisidoro/dotfiles $HOME/.dotfiles
$HOME/.dotfiles/bin/dot self install
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
~/.dotfiles/local/zshrc

# git
~/.dotfiles/local/gitconfig
```

## 🌟 Inspiration
 * https://github.com/Tuurlijk/dotfiles: Zsh startup snappiness
 * https://github.com/rgomezcasas/dotfiles: fine-tuning
