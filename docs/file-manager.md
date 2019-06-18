## File manager

`dot shell fm` offers a quick way to browse and jump between folders directly from the terminal.

![Demo](https://user-images.githubusercontent.com/3226564/59693889-05491480-91be-11e9-89dc-b5827cc15a20.gif)

### Commands

```
enter: open file or browse directory
ctrl-c or ctrl-space: abort and cd to current folder
ctrl-e: edit file in `$EDITOR`
ctrl-v: view file with `$PAGER`
ctrl-o: browse directory with another file manager
```

### Installation

```
git clone https://github.com/denisidoro/dotfiles.git ~/.dotfiles
```

Then set a function in your .bashrc-like such as:
```
fd () {
  local readonly f="$(dot shell fm "$@")"
  if [ -d "$f" ]; then
    cd "$f"
  fi
}
```

### Requirements

- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat) for syntax highlighting

### AWS S3 support

To browse S3 content, simply call the function passing a bucket that starts with `s3://`