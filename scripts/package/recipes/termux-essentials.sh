#!/usr/bin/env bash
# vim: filetype=sh

has_busybox_only() {
   mktemp --help 2>&1 \
      | grep -q BusyBox
}

termux-essentials::is_installed() {
   platform::command_exists grep
}

termux-essentials::install() {
   if ! platform::is_android; then
      return 0
   fi

   # in order to skip $PREFIX/bin, for example
   if ! fs::is_dir /bin; then
      pkg install proot
      termux-chroot
   fi

   # probably first time running it so let's add more stuff as well
   if has_busybox_only; then
      pkg install unstable-repo || true
      apt install coreutils || true
      pkg install util-linux || true
      pkg install termux-packages || true
      pkg install ncurses-utils || true
      pkg install grep sed || true
      termux-setup-storage || true
   fi

   if ! platform::command_exists sudo; then
      dot pkg add termux-sudo
   fi

}
