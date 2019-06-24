#!/bin/bash
# based on https://github.com/ssledz/bash-fun

f::drop() {
   tail -n +$(($1 + 1))
}

f::take() {
   head -n ${1}
}

f::tail() {
   f::drop 1
}

f::head() {
   f::take 1
}

f::last() {
   tail -n 1
}

f::list() {
   for i in "$@"; do
      echo "$i"
   done
}

f::unlist() {
   cat - | xargs
}

f::append() {
   cat -
   f::list "$@"
}

f::prepend() {
   f::list "$@"
   cat -
}

f::lambda() {

   lam() {
      local arg
      while [[ $# -gt 0 ]]; do
         arg="$1"
         shift
         if [[ $arg = '.' || $arg = '→' ]]; then
            echo "$@"
            return
         else
            echo "read $arg;"
         fi
      done
   }

   eval $(lam "$@")

}

λ() {
   f::lambda "$@"
}

# TODO: make it work besides f::map
λx() {
   local readonly body="${@: -1}"
   local readonly arg_count="$(echo "$body" | grep -Eo '%[0-9]+' | wc -l)"
   local readonly new_body="$(echo "$body" | sed 's/%/$var/g')"
   args=()
   for i in $(seq 1 $arg_count); do
      args+=("var${i}")
   done
   args+=(".")
   args+=("$new_body")
   λ "${args[@]}"
}

f::map() {
   local x
   while read x; do
      echo "$x" | "$@"
   done
}

f::foldl() {
   local f="$@"
   local acc
   read acc
   while read elem; do
      acc="$({ echo $acc; echo $elem; } | $f )"
   done
   echo "$acc"
}

f::reduce() {
   f::foldl "$@"
}

f::foldr() {
   local f="$@"
   local acc
   local zero
   read zero
   f::foldrr() {
      local elem

      if read elem; then
         acc=$(f::foldrr)
         #        [[ -z $acc ]] && echo $elem && return
      else
         echo $zero && return
      fi

      acc="$({ echo $acc; echo $elem; } | $f )"
      echo "$acc"
   }

   f::foldrr
}

f::scanl() {
   local f="$@"
   local acc
   read acc
   echo $acc
   while read elem; do
      acc="$({ echo $acc; echo $elem; } | $f )"
      echo "$acc"
   done
}

f::mul() {
   ( set -f; echo $(($1 * $2)) )
}

f::plus() {
   echo $(($1 + $2))
}

f::sub() {
   echo $(($1 - $2))
}

f::div() {
   echo $(($1 / $2))
}

f::mod() {
   echo $(($1 % $2))
}

f::sum() {
   f::foldl f::lambda a b . 'echo $(($a + $b))'
}

f::product() {
   f::foldl f::lambda a b . 'echo $(f::mul $a $b)'
}

f::factorial() {
   seq 1 $1 | f::product
}

f::splitc() {
   cat - | sed 's/./&\n/g'
}

f::join() {
   local delim=$1
   local pref=$2
   local suff=$3
   echo $pref$(cat - | f::foldl f::lambda a b . 'echo $a$delim$b')$suff
}

f::revers() {
   f::foldl f::lambda a b . 'f::append $b $a'
}

f::revers_str() {
   cat - | f::splitc | f::revers | f::join
}

f::catch() {
   local f="$@"
   local cmd=$(cat -)
   local val=$(2>&1 eval "$cmd"; echo $?)
   local cnt=$(f::list $val | wc -l)
   local status=$(f::list $val | f::last)
   $f < <(f::list "$cmd" $status $(f::list $val | f::take $((cnt - 1)) | f::unlist | f::tup))
}

f::try() {
   local f="$@"
   f::catch f::lambda cmd status val . '[[ $status -eq 0 ]] && f::tupx 1- $val | f::unlist || { '"$f"' < <(f::list $status); }'
}

f::ret() {
   echo $@
}

f::filter_echo() {
   local x
   while read x; do
      ret=$(echo "$x" | "$@")
      $ret && echo $x
   done
}

f::filter() {
   local x
   while read x; do
      echo "$x" | "$@" && echo $x || true
   done
}

f::pass() {
   echo > /dev/null
}

f::dropw() {
   local x
   while read x && $(echo "$x" | "$@"); do
      f::pass
   done
   [[ ! -z $x ]] && { echo $x; cat -; }
}

f::peek() {
   local x
   while read x; do
      ([ $# -eq 0 ] && 1>&2 echo $x || 1>&2 "$@" < <(echo $x))
      echo $x
   done
}

f::stripl() {
   local arg=$1
   cat - | f::map f::lambda l . 'f::ret ${l##'$arg'}'
}

f::stripr() {
   local arg=$1
   cat - | f::map f::lambda l . 'f::ret ${l%%'$arg'}'
}

f::strip() {
   local arg=$1
   cat - | f::stripl "$arg" | f::stripr "$arg"
}

f::buff() {
   local cnt=-1
   for x in $@; do
      [[ $x = '.' ]] || [[ $x = '→' ]] && break
      cnt=$(f::plus $cnt 1)
   done
   local args=''
   local i=$cnt
   while read arg; do
      [[ $i -eq 0 ]] && f::list $args | "$@" && i=$cnt && args=''
      args="$args $arg"
      i=$(f::sub $i 1)
   done
   [[ ! -z $args ]] && f::list $args | "$@"
}

f::tup() {
   if [[ $# -eq 0 ]]; then
      local arg
      read arg
      f::tup $arg
   else
      f::list "$@" | f::map f::lambda x . 'echo ${x/,/u002c}' | f::join , '(' ')'
   fi
}

f::tupx() {
   if [[ $# -eq 1 ]]; then
      local arg
      read arg
      f::tupx "$1" "$arg"
   else
      local n=$1
      shift
      echo "$@" | f::stripl '(' | f::stripr ')' | cut -d',' -f${n} | tr ',' '\n' | f::map f::lambda x . 'echo ${x/u002c/,}'
   fi
}

f::tupl() {
   f::tupx 1 "$@"
}

f::tupr() {
   f::tupx 1- "$@" | f::last
}

f::zip() {
   local f::list=$*
   cat - | while read x; do
      y=$(f::list $f::list | f::take 1)
      f::tup $x $y
      f::list=$(f::list $f::list | f::drop 1)
   done
}

f::partial() {
   exportfun=$1; shift
   fun=$1; shift
   params=$*
   cmd=$"() $exportfun() {
      more_params=\$*;
      $fun $params \$more_params;
   }"
   eval $cmd
}

f::curry() {
   f::partial "$@"
}

f::with_trampoline() {
   local f=$1; shift
   local args=$@
   while [[ $f != 'None' ]]; do
      ret=$($f $args)
      #    echo $ret
      f=$(f::tupl $ret)
      args=$(echo $ret | f::tupx 2- | tr ',' ' ')
   done
   echo $args
}

f::res() {
   local value=$1
   f::tup "None" $value
}

f::call() {
   local f=$1; shift
   local args=$@
   f::tup $f $args
}