export NUCLI_HOME="$NU_HOME/nucli"
export PATH="$NUCLI_HOME:$PATH"

# cd to nu home
alias cdn="cd $NU_HOME"

# cd to android project
alias cda="cd $NU_HOME/android-app"

# cd to service and open default panes
nb() {
  local dir
  dir=$(ls $NU_HOME | fzf-tmux --query="$1" --multi --select-1 --exit-0 --reverse --height 25%) &&
  tmuxinator start nuclj "$dir"
}

# cd to service
nbcd() {
  local dir 
  dir=$(ls $NU_HOME  | fzf-tmux --query="$1" --multi --select-1 --exit-0 --reverse --height 25%) &&
  cd "$NU_HOME/$dir"
}

alias as="open -a \"Android Studio\""

nurl() {
	nu service curl "$@" | jq
}

fnu() {
  local target
  target=$(
    find $NU_HOME/nucli/nucli.d -maxdepth 2 -type f -executable | grep -v '\.sh$' | sed -r "s/.*\/(.*)\.d\/(.*)$/\x1b[34;1m\1\t\x1b[m\2/g" \
  | fzf) || return
  nu $(echo "$target" | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g")
}