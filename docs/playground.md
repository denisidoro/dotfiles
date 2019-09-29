# Using dictionaries in bash

Sometimes you need to script in bash. And it'll probably be a pain in the neck.

Anyway, chances are that, if you have ever written some scripts, you have already come up with something like this:
```sh
my_fn() 
    local -r foo="$(complex_calc1)"
    local -r bar="$(complex_calc2)"

    echo "${foo};${bar}"
}

foo_plus_bar="$(my_fn)"
foo="$(echo "$foo_plus_bar" | cut -d';' -f1)"
bar="$(echo "$foo_plus_bar" | cut -d';' -f2)"

other_fn "$foo" "$bar"
```

Bash doesn't allow returning two values so we need to return a string which represents multidimensional data, using `;` as delimiter.

### Can we do better?

I think so!

With a set of scripts such as [this one](https://github.com/denisidoro/navi/blob/7be9353a41d5ae1e56ef60d4761863e73cef3d89/src/dict.sh), we can write:
```sh
my_fn() 
    local -r foo="$(complex_calc1)"
    local -r bar="$(complex_calc2)"

    dict::new foo "$foo" bar $bar"
}

dict="$(my_fn)"
foo="$(echo "$dict" | dict::get foo)"
bar="$(echo "$dict" | dict::get bar)"

other_fn "$foo" "$bar"
```

We're using textual data to represent a dictionary/map in this case.

The script isn't smaller, but that's not our main objective. We're trying to achieve legibility.

If you only read `cut -d';' -f1` you have no idea what's going on unless you debug the code. If you read `dict::get foo` at least you can expect it to return something foo-like.

Also, it composes very nice:
```sh
inc() {
    local -r x="$1"
    echo $((x+1))
}

# returns 42
dict::new foo "lorem" bar 41 \
    | dict::assoc baz "ipsum"
    | dict::dissoc foo \
    | dict::update bar inc \
    | dict::get bar
```

You can check more examples [here](https://github.com/denisidoro/navi/blob/dict/test/dict_test.sh).

### Why not JSON? Or YAML?

If you're sure that the platform which will run the script has something like [jq](https://stedolan.github.io/jq/) then JSON is a good candidate!

But if you want the script to be extremely portable, then a custom solution is required. Besides, the core of the library has ~30 lines of code, anyway.