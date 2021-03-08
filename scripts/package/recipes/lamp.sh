#!/usr/bin/env bash
set -euo pipefail

_prompt() {
   log::warn "$1"
   read -p "Press enter to continue"
}

recipe::httpd() {
   log::warn "Updating packages..."
   sudo yum update -y
   log::warn "Installing php and mariadb..."
   sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
   sudo amazon-linux-extras install
   cat /etc/system-release
   sudo yum install -y httpd mariadb-server mod_ssl
   sudo yum install -y php72-xml || sudo yum install -y php7.2-xml || sudo yum install -y php-xml || sudo yum install -y php7.0-xml || sudo yum install -y php70-xml
   log::warn "Restarting httpd..."
   sudo systemctl start httpd
   sudo systemctl enable httpd
   sudo systemctl is-enabled httpd
   ls /var/www/html
   log::warn "Changing groups..."
   sudo usermod -a -G apache ec2-user
   php --version
   _prompt "Please log out, ssh in and run this command again"
}

recipe::httpd2() {
   log::warn "Setting memory limit..."
   sudo sed -iE 's/^memory_limit =.*/memory_limit = 512M/' /etc/php.ini
   groups
   log::warn "Changing groups..."
   sudo chown -R ec2-user:apache /var/www
   sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
   log::warn "Making /var/www executable..."
   find /var/www -type f -exec sudo chmod 0664 {} \;
   echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
   _prompt "Check if phpinfo.php works"
   rm /var/www/html/phpinfo.php
   log::warn "Starting mariadb..."
   sudo systemctl start mariadb
   sudo systemctl enable mariadb
   sudo systemctl is-enabled mariadb
   log::warn "Setting up mariadb..."
   sudo mysql_secure_installation
   ls /var/www/html
   log::warn "Allowing overrides..."
   sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf
   sudo sed -i 's/AllowOverride none/AllowOverride All/g' /etc/httpd/conf/httpd.conf
   log::warn "Restarting LAMP..."
   sudo systemctl restart httpd
   sudo systemctl restart php-fpm
}

package::is_installed() {
   fs::is_dir "/var/www/html/phpMyAdmin"
}

package::install() {
   if ! platform::is_ami2; then
      log::err "Recipe only available to Amazon Linux AMI 2"
      exit 45
   fi

   if ! fs::is_dir "/var/www/html"; then
      recipe::httpd
   else
      recipe::httpd2
      dot pkg add phpMyAdmin
   fi
}