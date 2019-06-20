#!/usr/bin/env bash
# vim: filetype=sh
set -euo pipefail

source "${DOTFILES}/scripts/package/aux/recipes.sh"

_prompt() {
   log::warning "$1"
   read -p "Press enter to continue"
}

recipe::httpd() {
   log::warning "Updating packages..."
   sudo yum update -y
   log::warning "Installing php and mariadb..."
   sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
   sudo amazon-linux-extras install 
   cat /etc/system-release
   sudo yum install -y httpd mariadb-server mod_ssl
   sudo yum install -y php72-xml || sudo yum install -y php7.2-xml || sudo yum install -y php-xml || sudo yum install -y php7.0-xml || sudo yum install -y php70-xml
   log::warning "Restarting httpd..."
   sudo systemctl start httpd
   sudo systemctl enable httpd
   sudo systemctl is-enabled httpd
   ls /var/www/html
   log::warning "Changing groups..."
   sudo usermod -a -G apache ec2-user
   php --version
   _prompt "Please log out, ssh in and run this command again"
}

recipe::httpd2() {
   groups
   log::warning "Changing groups..."
   sudo chown -R ec2-user:apache /var/www
   sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
   log::warning "Making /var/www executable..."
   find /var/www -type f -exec sudo chmod 0664 {} \;
   echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
   _prompt "Check if phpinfo.php works"
   rm /var/www/html/phpinfo.php
   log::warning "Starting mariadb..."
   sudo systemctl start mariadb
   log::warning "Setting up mariadb..."
   sudo mysql_secure_installation
   ls /var/www/html
   log::warning "Starting manual edits..."
   sudo vim /etc/httpd/conf/httpd.conf
   log::warning "Restarting LAMP..."
   sudo systemctl restart httpd
   sudo systemctl restart php-fpm
}

recipe::phpmyadmin() {
   log::warning "Setting up phpMyAdmin..."
   cd /var/www/html
   log::warning "Downloading zip..."
   wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
   log::warning "Extracting zip..."
   mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
   log::warning "Cleaning up..."
   rm phpMyAdmin-latest-all-languages.tar.gz
}

if fs::is_dir "/var/www/html/phpMyAdmin"; then
   recipe::abort_installed LAMP
fi

if ! platform::is_ami2; then
   log::error "Recipe only available to Amazon Linux AMI 2"
   exit 45
fi

if ! platform::command_exists php; then
   recipe::httpd
else
   recipe::httpd2
   recipe::phpmyadmin 
fi
