#!/usr/bin/env bash

open() {
   dot system open "$@"
}

pbcopy() {
   dot system clip copy
}

pbpaste() {
   dot system clip paste
}
