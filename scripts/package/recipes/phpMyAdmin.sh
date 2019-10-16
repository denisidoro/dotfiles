#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

phpMyAdmin::is_installed() {
  fs::is_dir "/var/www/html/phpMyAdmin"
}

phpMyAdmin::depends_on() {
  coll::new wget
}

phpMyAdmin::install() {
  log::warning "Setting up phpMyAdmin..."
  cd /var/www/html
  log::warning "Downloading zip..."
  wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
  log::warning "Extracting zip..."
  mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
  log::warning "Cleaning up..."
  rm phpMyAdmin-latest-all-languages.tar.gz
}
