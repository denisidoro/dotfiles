# ctrl+g - Paste the selected command from history into the command line
_call_navi() {
   local navi_path=$(command -v navi)
   local buff="$BUFFER"
   zle kill-whole-line
   local cmd="$(NAVI_USE_FZF_ALL_INPUTS=true "$navi_path" --print <> /dev/tty)"
   zle -U "${buff}${cmd}"
}
zle     -N   _call_navi
bindkey '^g' _call_navi
