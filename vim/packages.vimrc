" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" colorschemes
Plug 'morhetz/gruvbox'

" browsing
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim', {'on': ['CtrlP', 'CtrlPMixed', 'CtrlPMRU']}

" eye candy
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

