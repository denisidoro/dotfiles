# master
alias gcom="git checkout master"
alias gmm="git merge master"

# update
alias gu="git pull && git submodule init && git submodule update && git submodule status"
alias gum="git checkout master && git pull && git checkout - && git merge master && git checkout -v -a"

# git status with tig
alias tst="tig status"

# git push upstream
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'

# git push with linting fix
alias gpfl="lein do cljfmt fix, kibit --replace; gaa; gcam 'Fix lint'; gpu"

# git commit with push
gcamp() { git commit -am "$1"; gpu; }

# preview PR
gprp() { dot git pr preview; }

# git interactive checkout
gcoo() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all --sort=committerdate | grep -v HEAD  |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") | sort -u | grep . | tac |
    fzf-tmux --query="$1" --multi --select-1 --exit-0 --reverse --height 25% -- --no-hscroll --ansi +m -d "\t" -n 2 -1 -q "$*") || return
  git checkout $(echo "$target" | awk '{print $2}')
}
