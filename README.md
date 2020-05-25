<h3 align="center">
  <span><img width="18" src="https://image.flaticon.com/icons/svg/226/226769.svg" alt="OSX - Icon made by Freepik from Flaticon" /></span>
  <span><img width="18" src="https://image.flaticon.com/icons/svg/226/226772.svg" alt="Linux - Icon made by Freepik from Flaticon" /></span>
  <span><img width="18" src="https://image.flaticon.com/icons/svg/174/174836.svg" alt="Android - Icon made by Freepik from Flaticon" /></span>
  denisidoro/dotfiles
  <a alt="CI status" href="https://github.com/denisidoro/dotfiles/actions"><img src="https://github.com/denisidoro/dotfiles/workflows/Tests/badge.svg" /></a>
  <a alt="GitHub release" href="https://github.com/denisidoro/dotfiles/releases"><img src="https://img.shields.io/github/v/release/denisidoro/dotfiles?include_prereleases" /></a>
</h3>

<p align="center">
  <img src="https://user-images.githubusercontent.com/3226564/70171435-78334280-16ad-11ea-8e2d-3388b2fb5085.gif" alt="Demo">
  <br>
  <sub>Awesome personal dotfiles</sub>
</p>
<p align="center">
  <a href="#-installation">Installation</a>&nbsp;&nbsp;&nbsp;
  <a href="shell">Shell</a>&nbsp;&nbsp;&nbsp;
  <a href="scripts">Scripts</a>&nbsp;&nbsp;&nbsp;
  <a href="git/config">Git</a>&nbsp;&nbsp;&nbsp;
  <a href="docs">Docs</a>
</p>

## Installation
```bash
# with homebrew or linuxbrew
brew install denisidoro/tools/dotfiles

# with git
git clone https://github.com/denisidoro/dotfiles $HOME/dotfiles
$HOME/dotfiles/bin/dot self install
```

## Calling scripts
```bash
dot <ctx> <cmd> [<args>...] # example: dot rice pipes
```

## Documentation

Some scripts are documented in [/docs](docs). For all other scripts, run:
```bash
dot <ctx> <cmd> --help # example: dot rice pipes --help
```

## Shell startup performance

```bash
λ dot shell zsh test-performance
0.08 real         0.03 user         0.03 sys
```

## Overriding configs

Edit the following files accordingly:
```bash
# shell
~/.dotfiles/local/zshrc

# git
~/.dotfiles/local/gitconfig
```

## Inspiration
 * [Tuurlijk/dotfiles](https://github.com/Tuurlijk/dotfiles): zsh startup snappiness
 * [rgomezcasas/dotfiles](https://github.com/rgomezcasas/dotfiles): README, some scripts and fine-tuning
 * [wfxr/forgit](https://github.com/wfxr/forgit): some git scripts
