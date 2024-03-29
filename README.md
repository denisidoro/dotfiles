<h3 align="center">
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
  <a href="#full-installation">Installation</a>&nbsp;&nbsp;&nbsp;
  <a href="shell">Shell</a>&nbsp;&nbsp;&nbsp;
  <a href="scripts">Scripts</a>&nbsp;&nbsp;&nbsp;
  <a href="git/config">Git</a>&nbsp;&nbsp;&nbsp;
  <a href="docs">Docs</a>
</p>

## Full installation 

```bash
# with homebrew or linuxbrew
brew install denisidoro/tools/dotfiles
dot self install

# with curl
bash <(curl -s https://raw.githubusercontent.com/denisidoro/dotfiles/master/scripts/self/install)

# with wget
bash <(wget -qO- https://raw.githubusercontent.com/denisidoro/dotfiles/master/scripts/self/install)

# with git
export DOTFILES="${HOME}/dotfiles"
git clone https://github.com/denisidoro/dotfiles "$DOTFILES"
"${DOTFILES}/bin/dot" self install
```

## Using in shell scripts

```bash
dot::clone() {
  git clone https://github.com/denisidoro/dotfiles "$DOTFILES"
}

dot::clone_if_necessary() {
  [ -n "${DOTFILES:-}" ] && [ -x "${DOTFILES}/bin/dot" ] && return
  export DOTFILES="${HOME}/dotfiles"
  $(dot::clone >/dev/null || true)
}

dot::source() {
  dot::clone_if_necessary
  source "${DOTFILES}/scripts/core/main.sh"
}

dot::source
```

## Calling scripts

There's a single entry point for most scripts, which is the `dot` command:
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
$ dot shell zsh benchmark
Benchmark #1: /usr/bin/time /bin/zsh -i -c exit
  Time (mean ± σ):      35.6 ms ±   3.0 ms    [User: 14.0 ms, System: 16.0 ms]
  Range (min … max):    32.7 ms …  48.8 ms    67 runs
```

## Template

In order to setup your own dotfiles, I recommend using [dotly](https://github.com/CodelyTV/dotly) or [Sloth](https://github.com/gtrabanco/.Sloth), which are frameworks inpired by this repository.
