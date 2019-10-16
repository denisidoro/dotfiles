#!/usr/bin/env bash
# vim: filetype=sh

heptio-authenticator-aws::depends_on() {
   coll::new aws-iam-authenticator
}

heptio-authenticator-aws::install() {
   sudo ln -s "$(which aws-iam-authenticator)" /usr/bin/heptio-authenticator-aws
}
