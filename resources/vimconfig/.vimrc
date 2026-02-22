inoremap jj <esc>
vnoremap <C-S-C> "+y
map <C-S-P> "+p
vnoremap <C-C> "*y :let @+=@*<CR>

filetype plugin on
syntax on
set formatoptions=1
set lbr
setlocal spell spelllang=en_gb
setlocal spell!
set tabstop=4

autocmd BufWritePre * %s/\s\+$//e
