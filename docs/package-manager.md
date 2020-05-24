# Package manager

This repository offers a package manager abstraction to rule them all.

The script uses your system's package manager under the hood when applicable and is able to cook custom recipes. 

For example, [ag](https://github.com/ggreer/the_silver_searcher) requires you to:
- run `brew install the_silver_searcher` if you're on a Mac or 
- run `sudo apt install silversearcher-ag` if you're on a Ubuntu machine or 
- clone and build it locally in case there's no supported package manager. 

`dot pkg add ag` will take care of all this for you.

Note: please refer to the [main README](https://github.com/denisidoro/dotfiles/blob/master/README.md) for install instructions.

### Main usage

```sh
dot pkg add <packages>...

# eg
dot pkg add python fzf
```

### More info

```sh
dot pkg
```

```sh
dot pkg <cmd> --help
```