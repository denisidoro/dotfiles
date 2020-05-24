#!/usr/bin/env bash

_gen_go_source() {
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

_transpile_go_error_propagation() {
   local -r source="${TEST_DIR}/code.go"
   _gen_go_source "$source"
   dot code transpile "$source"
   local -r result="$(cat "$source")"
   echo "$result" | test::includes "foo, err := myFn()" \
      && echo "$result" | test::includes "halfBakedPie, err := startBaking(apple)" \
      && echo "$result" | test::includes "if err != nil {"
}

_transpile_go_map() {
   local -r source="${TEST_DIR}/code.go"
   _gen_go_source "$source"
   dot code transpile "$source"
   local -r result="$(cat "$source")"
   echo "$result" | test::includes "pies := make([]Pie, len(apples))" \
      && echo "$result" | test::includes "pies[i] = halfBakedPie.finish()"
}

_gen_bash_source() {
   local -r source="$1"
   cat << EOB > "$source"
myfn(arg1, arg2, arg3) {
   body
}
EOB
}

_transpile_bash_args() {
   local -r source="${TEST_DIR}/code.bash"
   _gen_bash_source "$source"
   dot code transpile "$source"
   local -r result="$(cat "$source")"
   echo "$result" | test::includes "myfn() {" \
      && echo "$result" | test::includes "local -r arg1" \
      && echo "$result" | test::includes "local -r arg2" \
      && echo "$result" | test::includes "local -r arg3"
}

test::set_suite "rust - go"
test::run "transpile - error propagation" _transpile_go_error_propagation
test::skip "transpile - map" _transpile_go_map

test::set_suite "rust - bash"
test::run "transpile - args" _transpile_bash_args
