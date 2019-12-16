export DOTFILES="${DOTFILES:-/sdcard/dotfiles}"

## Wallpaper helpers
##
## Usage after sourcing:
##    apod_url "%data"
##
## Variables:
##    %data   HTTP data

apod_url() {
    printf 'https://apod.nasa.gov/'
    echo "$*" \
      | grep -i '<img' \
      | head -n1 \
      | grep -Eo '".*?"' \
      | tr -d '"'
}