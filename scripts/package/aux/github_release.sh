#!/usr/bin/env bash

release::best_match() {
  IFS=$'\n'
  # shellcheck disable=SC2207,SC2206
  local -r releases=($1)

  local -r arch="$(uname -m | lowercase)"
  local -r os="$(uname -s | lowercase)"
  local -r os2="$(uname -o 2>/dev/null | lowercase)"

  IFS=$'\n'

  local score
  local filename
  local i=0
  local max=0
  local id=0

  for release in "${releases[@]}"; do
    filename="$(echo "$release" | cut -d';' -f1)"
    score=$(release::calc_score "$filename")
    if [[ $score -ge $max ]]; then
      max=$score
      id=$i
    fi
    ((i+=1))
  done

  echo "${releases[$id]}" | cut -d';' -f2
}

lowercase() {
  local -r input="$(cat)"
  echo "${input,,}"
}

release::get_all() {
  local -r repo="$1"
  local -r proj="$2"

  dot pkg add curl jq &>/dev/null

  curl "https://api.github.com/repos/${repo}/${proj}/releases/latest" \
    | jq '.assets | map(.name + ";" + .browser_download_url) | .[]' -r
}

release::calc_score() {
  local -r file="$(echo "$1" | lowercase)"
  local score=0

  [[ "$file" = *"$arch"* ]] && ((score+=10))
  [[ "$file" = *"$os"* ]] && ((score+=10))
  [[ "$file" = *"$os2"* ]] && ((score+=9))

  [[ "$arch" = "x86_64" ]] && [[ "$file" = *amd* ]] && ((score+=2))
  [[ "$arch" = "x86_64" ]] && [[ "$file" = *arm* ]] && ((score-=1))
  [[ "$arch" = "x86_64" ]] && [[ "$file" = *x64* ]] && ((score+=5))
  [[ "$os" = "darwin" ]] && [[ "$file" = *apple* ]] && ((score+=5))
  [[ "$os" = "darwin" ]] && [[ "$file" = *mac* ]] && ((score+=4))
  [[ "$arch" = *arm* ]] && [[ "$file" = *arm* ]] && ((score+=3))
  [[ "$arch" = *aarch* ]] && [[ "$file" = *aarch* ]] && ((score+=3))
  [[ "$arch" = *arm* ]] && [[ "$file" = *aarch* ]] && ((score+=2))
  [[ "$arch" = *aarch* ]] && [[ "$file" = *arm* ]] && ((score+=2))
  [[ "$os2" = "gnu/linux" ]] && [[ "$file" = *android* ]] && ((score-=3))

  echo "$score"
}