#!/usr/bin/env bash
# vim: filetype=sh

aws-iam-authenticator::depends_on() {
   coll::new kops kubernetes-cli
}

aws-iam-authenticator::install() {
   go get -u -v github.com/kubernetes-sigs/aws-iam-authenticator/cmd/aws-iam-authenticator
}