inoremap jj <esc>
vnoremap <C-c> "+y
map <C-p> "+p
vnoremap <C-c> "*y :let @+=@*<CR>

filetype plugin on
syntax on
set formatoptions=1
set lbr
setlocal spell spelllang=en_gb
setlocal spell!
set tabstop=4

autocmd BufWritePre * %s/\s\+$//e
