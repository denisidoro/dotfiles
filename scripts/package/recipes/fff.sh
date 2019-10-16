#!/usr/bin/env bash
# vim: filetype=sh

fff::install() {
   recipe::shallow_github_clone dylanaraps fff
   recipe::make fff
}
