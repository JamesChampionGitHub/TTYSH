inoremap jj <esc>
vnoremap <C-c> "+y
map <C-p> "+p
vnoremap <C-c> "*y :let @+=@*<CR>
set clipboard=unnamedplus

filetype plugin on
syntax on
colorscheme	vim
set formatoptions=1
set lbr
setlocal spell spelllang=en_gb
setlocal spell!
set tabstop=4

autocmd BufWritePre * %s/\s\+$//e
