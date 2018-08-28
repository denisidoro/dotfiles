#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/main.sh"

rv="a-zA-Z0-9"
rv2="${rv}<>"
r0="[${rv}]+"
r1="(${r0})?\s"
remd="\-\-${r0}\s${r0}"

_transpose() {
  cat | awk '
  {
      for (i=1; i<=NF; i++)  {
          a[NR,i] = $i
      }
  }
  NF>p { p = NF }
  END {
      for(j=1; j<=p; j++) {
          str=a[1,j]
          for(i=2; i<=NR; i++){
              str=str" "a[i,j];S
          }
          print str
      }
  }'
}

_col() {
  cat | column -t
}

_remove_brackets() {
  cat \
    | sed -E 's/<|>|\[|\]//g'
}

_bash_code() {
  cat \
    | awk '{print $1 "=" $2}' \
    | sed -E 's/<|>//g'
}

_all_vars() {
  local readonly doc="$1"
  echo "$doc" \
    | grep -Eo "[$rv2]+" \
    | grep -v "<"
}

_regex() {
  echo "$1" \
    | sed -E "s/\[(.*)\]/(\1)?/g" \
    | sed -E "s/<${r0}>/${r0}/g"
}

_remove_dashed() {
  local readonly doco="$1"
  cat | sed -E "s/${remd}//g" | xargs
}

_without_dashes() {
  awk -v doco="$1" '{ 
    for (i = 1; i <= NF; ++i) { 
      if ($i ~ /^\-/) {
        pos_arg_regex="\\"$i".*<"
        if (doco ~ pos_arg_regex)  {
          opts=opts$i" "$(i+1)"\n"
          $i=""
          $(i+1)=""
        } else {
          opts=opts$i" true\n"
          $i=""
        }
      }
    }
  };
  { print $0; print opts; }' 
}

echosep() {
  echo "--------------------------------------- ${1:-und}"
}

_escape_input() {
  echo "$@"  
}

_expand_dashes() {
  local readonly input="$(cat)"
  if echo "$input" | grep -Eq '\s-[a-zA-Z]'; then
    local readonly match="$(echo "$input" | grep -Eo '\-.*\s')"
    local readonly expanded="$(echo "${match:1:-1}" | sed -E 's/(.)/\-\1 /g')"
    echo "$input" | sed "s/$match/$expanded/"
  else
    echo "$input"
  fi
}

# doc="$(cat)"
doc="$(echo -e "ship move <x> <y>
ship (create|destroy)
ship [style] construct")"

doco="$(echo -e "-f --format <format>
-p --preview")"

echosep 1 

input="$(_escape_input "$@" | _expand_dashes)"

echo "$input"
echosep 1.1


xablau="$(echo "$input" | _without_dashes "$doco")"
input="$(echo "$xablau" | head -n1 | xargs)"
options="$(echo "$xablau" | tail -n +2)"

echo "$xablau"
echosep 1.9

echo "$input"
echosep 2

echo "$options"
echosep 2.1

# sed -E "s/\s?\[${r0}\]\s?/${r1}/g"
# docr="$(echo "$doc" | sed -E "s/<${r0}>/${r0}/g" | sed -E "s/\[(.*)\]/(\1)?/g")"

# echo -e "$docr"
# exit 0

IFS=$'\n'
for p in $doc; do
  r="$(_regex "$p")"
  # echo "$p -> $r <- $@"
  if echo "$input" | grep -Eq "$r"; then
    match="$p"
    break
  fi
done

echosep 3
echo "match=${match:-no...}"

str="$(echo -e "$match\n$input")"

echosep 4
echo "$str"

# code1="$(_all_vars "$doc" | awk '{print $0"=false;"}')"
code1="$(_all_vars "$doc")"

#   | awk '{ if ($2 == "") $2="false"; else if (index($1, "|") != 0) $1=$2; if ($2 == $1) $2="true"; print $1"="$2";" }' \

code2="$(echo "$str" \
  | _col \
  | _transpose)"

code="$options
$code1
$code2"

echosep 5
echo "$code" | awk '{ if ($2 == "") $2="false"; else if (index($1, "|") != 0) $1=$2; if ($2 == $1) $2="true"; print $1"="$2";" }'

exit 0

eval "$code" > /dev/null

echosep 6
echo "ship: ${ship:-undefined};"
echo "move: ${move:-undefined};"
echo "x: ${x:-undefined};"
echo "y: ${y:-undefined};"
echo "create: ${create:-undefined};"
echo "destroy: ${destroy:-undefined};"
echo "style: ${style:-undefined};"
echo "construct: ${construct:-undefined};"

# echo -e "ship\nmove\n<x> 10\nconstruct construct" | awk '{ if ($2 == "") $2="false"; else if ($2 == $1) $2="true"; print $1"="$2";" }'
