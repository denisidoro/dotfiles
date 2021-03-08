#!/usr/bin/env bash
set -euo pipefail

package::is_installed() {
   fs::is_dir "/var/www/html/phpMyAdmin"
}

package::install() {
   dot pkg add wget

   cd /var/www/html
   log::warn "Downloading zip..."
   wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
   log::warn "Extracting zip..."
   mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
   log::warn "Cleaning up..."
   rm phpMyAdmin-latest-all-languages.tar.gz
}
