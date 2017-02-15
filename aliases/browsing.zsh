# ===============
# listing
# ===============

alias ls='ls --color=auto'
alias lst="tree -L 2"


# ===============
# folders
# ===============

mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# Go up X directories (default 1)
up() {
  if [[ "$#" -ne 1 ]]; then
    cd ..
  elif ! [[ $1 =~ '^[0-9]+$' ]]; then
    echo "Error: up should be called with the number of directories to go up. The default is 1."
  else
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    cd $d
  fi
}


# ===============
# properties
# ===============

# Determine size of a file or total size of a directory
fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

# jumping
alias a='fasd -a'           # any
alias s='fasd -si'          # show / search / select
alias d='fasd -d'           # directory
alias f='fasd -f'           # file
alias sd='fasd -sid'        # interactive directory selection
alias sf='fasd -sif'        # interactive file selection
alias j='fasd_cd -d'        # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i'    # cd with interactive selection
alias v="fasd -f -e nvim"   # edit file with vim
