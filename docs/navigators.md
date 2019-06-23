# Navigators

This repository offers a series of navigators to browse and jump between paths in data structures.

Here is a demo of a JSON navigator:

![JSON navigator](https://user-images.githubusercontent.com/3226564/59977238-41f18300-95a5-11e9-8537-ae48f8ee712b.gif)

Note: please refer to the [main README](https://github.com/denisidoro/dotfiles/blob/master/README.md) for install instructions.

### Default commands

```
enter: browse path
ctrl-c or ctrl-space: abort
ctrl-v: view content with $PAGER
ctrl-j: jump to path
ctrl-h: go up one path
```

### Dependencies

[fzf](https://github.com/junegunn/fzf) is required for all commands to work.

### Creating custom navigators

Only a few lines of bash glue are necessary to implement new navigators.

Please use [this implementation](https://github.com/denisidoro/dotfiles/blob/master/scripts/js/nav) as reference.


---

## Filesystem navigator

```sh
dot fs nav
```

![Filesystem navigator](https://user-images.githubusercontent.com/3226564/59693889-05491480-91be-11e9-89dc-b5827cc15a20.gif)

### Extra commands

```
ctrl-e: edit file in $EDITOR
ctrl-o: browse directory in a fully-fledged terminal file manager
```

### Using it as an enhanced `cd`

Use it via the `fd` alias in order to `cd` to the last visited folder.


---

## AWS S3 navigator

```sh
dot aws s3 <bucket>
```


---

## JSON navigator

```sh
cat my.json | dot js nav
```

### Similar tool

[Floki](https://github.com/denisidoro/floki), a JSON/EDN browser for the terminal.


---

## Other navigators

For non-implemented navigators, your best bet is to convert the data to JSON first. Some examples:

```sh
# edn
cat my.edn | nu clj data -o json | dot js nav

# xml
cat my.xml | xml2json | dot js nav

# yaml
cat my.yaml | yaml2json | dot js nav
```
