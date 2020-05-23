#!/usr/bin/env bash

_gen_source() {
    local -r source="$1"
    cat << EOB > "$source"
package main
import "fmt"

func main() {
    fmt.Println("hello world")
    foo := myFn()?
    apples := getApples()
    pies := apples.map(func(a) Pie {
       halfBakedPie = startBaking(apple)?
       return halfBakedPie.finish() 
    })
}
EOB
}

_transpile_error_propagation() {
    local -r source="${TEST_DIR}/code.go"
    _gen_source "$source"
    dot code transpile "$source"
    local -r result="$(cat "$source")"
    echo "$result" | test::includes "foo, err := myFn()" \
        && echo "$result" | test::includes "halfBakedPie, err := startBaking(apple)" \
        && echo "$result" | test::includes "if err != nil {"
}

_transpile_map() {
    local -r source="${TEST_DIR}/code.go"
    _gen_source "$source"
    dot code transpile "$source"
    local -r result="$(cat "$source")"
    echo "$result" | test::includes "pies := make([]Pie, len(apples))" \
        && echo "$result" | test::includes "pies[i] = halfBakedPie.finish()"
}

test::set_suite "rust - go"
test::run "transpile - error propagation" _transpile_error_propagation
test::skip "transpile - map" _transpile_map
