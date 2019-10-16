#!/usr/bin/env bash
# vim: filetype=sh

_prompt() {
   log::warning "$1"
   read -p "Press enter to continue"
}

sendy::is_installed() {
   fs::is_dir "/var/www/html/autoresponders.php"
}

sendy::depends_on() {
   coll::new unzip curl
}

sendy::install() {
   if ! platform::is_ami2; then
      log::error "Recipe only available to Amazon Linux AMI 2"
      exit 45
   fi

   log::warning "Setting up sendy..."

   sendy_zip_url="https://sendy.co/download/?license=${SENDY_KEY}"

   log::warning "Downloading sendy.zip"
   cd $HOME
   curl -o sendy.zip -O -J -L "$sendy_zip_url"
   unzip sendy.zip -d /var/www/html
   mv /var/www/html/sendy/* /var/www/html/
   rm -rf /var/www/html/sendy
   ls /var/www/html/
   chmod -R 777 /var/www/html/uploads
   log::warning "Setting db..."
   dot lamp mysql create sendy
   vim /var/www/html/includes/config.php
   cp "${DOTFILES}/scripts/package/resources/sendy/htaccess" "/var/www/html/.htaccess"
   log::warning "Setting cron..."
   (crontab -l 2>/dev/null; echo "*/1 * * * * php /var/www/html/autoresponders.php > /dev/null 2>&1") | crontab -
   (crontab -l 2>/dev/null; echo "*/5 * * * * php /var/www/html/scheduled.php > /dev/null 2>&1") | crontab -
   (crontab -l 2>/dev/null; echo "*/1 * * * * php /var/www/html/import-csv.php > /dev/null 2>&1") | crontab -
}

