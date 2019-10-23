#!/usr/bin/env bash
# vim: filetype=sh

_prompt() {
   log::warning "$1"
   read -p "Press enter to continue"
}

yourls::is_installed() {
   fs::is_file "/var/www/html/yourls-api.php"
}

yourls::depends_on() {
   coll::new unzip curl
}

yourls::install() {
   if ! platform::is_ami2; then
      log::error "Recipe only available to Amazon Linux AMI 2"
      exit 45
   fi

   log::warning "Setting up yourls..."

   VERSION="1.7.4"

   zip_url="https://github.com/YOURLS/YOURLS/archive/${VERSION}.zip"

   log::warning "Downloading zip file..."
   cd $HOME
   curl -o yourls.zip -O -J -L "$zip_url"
   unzip yourls.zip -d /var/www/html
   mv /var/www/html/YOURLS-${VERSION}/* /var/www/html/
   rm -rf /var/www/html/YOURLS-${VERSION} || true
   rm -rf /var/www/html/yourls || true
   cd /var/www/html/
   ls
   cp user/config-sample.php user/config.php
   log::warning "Setting db..."
   dot lamp mysql create yourls
   vim user/config.php
}
