#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

_prompt() {
   log::warning "$1"
   read -p "Press enter to continue"
}

if fs::is_file "/var/www/html/yourls-api.php"; then
   recipe::abort_installed yourls
fi

if ! platform::is_ami2; then
   log::error "Recipe only available to Amazon Linux AMI 2"
   exit 45
fi

log::warning "Setting up yourls..."

dot pkg add unzip curl

VERSION="${VERSION:-1.7.3}"

zip_url="https://github.com/YOURLS/YOURLS/archive/${VERSION}.zip"

log::warning "Downloading zip file..."
cd $HOME
curl -o yourls.zip -O -J -L "$zip_url"
unzip yourls.zip -d /var/www/html
mv "/var/www/html/YOURLS-${VERSION}/*" /var/www/html/
rm -rf /var/www/html/yourls
cd /var/www/html/
ls
cp user/config-sample.php user/config.php
log::warning "Setting db..."
dot lamp mysql create yourls
vim user/config.php
