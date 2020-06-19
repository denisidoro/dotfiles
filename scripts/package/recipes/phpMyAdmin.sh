#!/usr/bin/env bash
set -euo pipefail

source "${DOTFILES}/scripts/core/fs.sh"
source "${DOTFILES}/scripts/core/log.sh"

package::is_installed() {
   fs::is_dir "/var/www/html/phpMyAdmin"
}

package::install() {
   dot pkg add wget

   cd /var/www/html
   log::warning "Downloading zip..."
   wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
   log::warning "Extracting zip..."
   mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
   log::warning "Cleaning up..."
   rm phpMyAdmin-latest-all-languages.tar.gz
}
