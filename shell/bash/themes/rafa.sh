PROMPT_COMMAND="rafa_theme"

FIRST_CHARACTER="λ"

rafa_theme() {
  current_dir=$(pwd) # TODO: $(dot filesystem short_pwd)

  export PS1="${FIRST_CHARACTER} ${current_dir} "
}
