export NUCLI_HOME="$NU_HOME/nucli"
export PATH="$NUCLI_HOME:$PATH"

# cd to nu home
alias cdn="cd $NU_HOME"

# cd to android project
alias cda="cd $NU_HOME/android/nubank-android"

# cd to service and open default panes
nb() {
  local dir
  b=$HOME/Code/nu  
  dir=$(ls $b | fzf-tmux --query="$1" --multi --select-1 --exit-0 --reverse --height 25%) &&
  tmuxinator start nuclj "$b/$dir"
}

# cd to service
nbcd() {
  local dir
  b=$HOME/Code/nu  
  dir=$(ls $b | fzf-tmux --query="$1" --multi --select-1 --exit-0 --reverse --height 25%) &&
  cd "$b/$dir"
}

alias as="open -a \"Android Studio\""