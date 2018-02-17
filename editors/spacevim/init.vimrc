" Let Vim and NeoVim shares the same plugin directory.
" Comment it out if you don't like
let g:spacevim_plug_home = '~/.vim/plugged'

" The default leader key is space key.
" Uncomment the line below and modify "<\Space>" if you prefer another
" let g:spacevim_leader = "<\Space>"

" The default local leader key is comma.
" Uncomment the line below and modify ',' if you prefer another
" let g:spacevim_localleader = ','

" Enable the existing layers in space-vim
let g:spacevim_layers = [
      \ 'fzf', 'unite', 'better-defaults',
      \ 'which-key',
      \ 'file-manager' ]

" If you want to have more control over the layer, try using Layer command.
" if g:spacevim_gui
"   Layer 'airline'
" endif

" Manage your own plugins, refer to vim-plug's instruction for more detials.
function! UserInit()

  " Add plugin via Plug command.
  Plug 'junegunn/seoul256.vim'
  Plug 'airblade/vim-rooter'
  Plug 'danilo-augusto/vim-afterglow'

endfunction

" Override the default settings as well as adding extras
function! UserConfig()

  " If you have installed the powerline fonts and want to enable airline layer
  " let g:airline_powerline_fonts=1

  " Use gui colors in terminal if available
  if has('termguicolors')

    colorscheme afterglow
    set termguicolors

    if g:spacevim_tmux
      " If use vim inside tmux, see https://github.com/vim/vim/issues/993
      " set Vim-specific sequences for RGB colors
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
  endif

endfunction
