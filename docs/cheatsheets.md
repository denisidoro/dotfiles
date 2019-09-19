# Cheatsheets

This repository offers a powerful cheatsheet tool. 

Think of it as an enhanced history searcher. Except it works even if you haven't run the command yet. And it allows you to give descriptions to the commands. And it suggests you argument values.

![Demo](https://user-images.githubusercontent.com/3226564/65281359-d158f480-db08-11e9-8e69-e380d76c343b.gif)

Note: please refer to the [main README](https://github.com/denisidoro/dotfiles/blob/master/README.md) for install instructions.

### Main usage

```sh
dot shell cheats
```

### Motivation

The main objectives are:
- to increase discoverability, by showing all possible actions you can take;
- to prevent you from running auxiliar commands, copying the result into the clipboard and then pasting into the original command;
- to improve terminal usage as a whole.

Sure, you can find autocompleters out there for all your favorite commands.

However, they are very specific and each one may offer a different learning curve.

This helper, on the other hand, intends to be a general purpose platform for speccing any command with a couple of lines.

### .cheat syntax

- lines starting with `%` should contain tags which will be added to any command in a given file
- lines starting with `#` should be descriptions of commands
- lines starting with `$` should contain commands that generate suggestion values for a given argument

For example, this is a valid `.cheat` file:
```sh
% git, version control

# Change branch
git checkout <branch>

$ branch: git branch --format='%(refname:short)'
```

For advanced usage, please refer to the files in [/cheatsheets](https://github.com/denisidoro/dotfiles/tree/master/cheatsheets)


### More options

Please run:
```
dot shell cheats --help
```