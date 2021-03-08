# edit multiline commands using $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^X" edit-command-line

# set editor default keymap to emacs
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

# prevent delete key from inserting ~
bindkey "^[[3~" delete-char