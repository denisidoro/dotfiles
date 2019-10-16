#!/usr/bin/env bash

DEMO_ID=0
DEMO_MESSAGES="message 1\nmessage 2\nmessage 3"
demo() {
   DEMO_ID=$((DEMO_ID+1))
   printf '# '
   dot rice type "$(echo "$DEMO_MESSAGES" | sed "${DEMO_ID}q;d")"
}
zle -N demo
bindkey '^u' demo