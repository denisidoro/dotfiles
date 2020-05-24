# Transpile

This repository offers a transpile utility that is able to add new features to existing languages.

In order to transpile the extended language to the vanilla one, run `dot code transpile <filepath>`.

Note: please refer to the [main README](https://github.com/denisidoro/dotfiles/blob/master/README.md) for install instructions.

### Go

Calling the script for the following file...
```go
package main
import "fmt"

func myfn() (*somestruct, error) {
    fmt.Println("hello world")
    foo := bar()?
    return baz()
}
```

...should result into:
```go
package main
import "fmt"

func myfn() (*somestruct, error) {
    fmt.Println("hello world")
    foo, err := bar()
    if err != nil {
        return nil, err
    }
    return baz()
}
```

### Bash

Calling the script for the following file...
```bash
myfn(foo, bar) {
    body
}
```

...should result into:
```bash
myfn() {
    local -r foo="$1"
    local -r bar="$2"
    body
}
```