let mapleader =" "

set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"

syntax enable

filetype plugin on

nnoremap <Leader>r :so ~/.vimrc <CR>

command! MakeTags !ctags -R .

call plug#begin('~/.vim/plugged')



call plug#end()

packadd termdebug

set nocompatible
set nu
set relativenumber
set clipboard=unnamedplus
set nohlsearch
set hidden
set shiftwidth=4
set smartindent
set smarttab
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set notermguicolors t_Co=8
set path+=**
set wildmenu
set splitright splitbelow 
set vb t_vb=
set statusline=%{strftime('%c',getftime(expand('%')))}
set mouse=a
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast
set guicursor=i:ver25-iCursor
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.

" Manually set the status line color.
"hi StatusLineTerm ctermbg=24 ctermfg=254 guibg=#7000FF guifg=#FFFFFF
"hi StatusLineTermNC ctermbg=252 ctermfg=238 guibg=#d0d0d0 guifg=#444444

"Thin cursor at insert mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

"Delete all comments
map DAC# :g/^\s*#/d <CR>
map DAC// :g/^\s*#/d <CR>

"Easy switching panes
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"Pane resizing
nnoremap <silent><Leader>K :exe "resize " . (winheight(0) * 9/7)<CR>
nnoremap <silent><Leader>J :exe "resize " . (winheight(0) * 7/9)<CR>
nnoremap <silent><Leader>L :exe "vertical resize " . (winwidth(0) * 9/7)<CR>
nnoremap <silent><Leader>H :exe "vertical resize " . (winwidth(0) * 7/9)<CR>

"Latex snippets
nnoremap ,lx\\ :-1read ~/.vim/snippets/latex/.Article<CR>11j6la
nnoremap ,lxbf :-1read ~/.vim/snippets/latex/.textbf<CR>7la
nnoremap ,lxit :-1read ~/.vim/snippets/latex/.textit<CR>7la
nnoremap ,lxtt :-1read ~/.vim/snippets/latex/.texttt<CR>7la
nnoremap ,lxs :-1read ~/.vim/snippets/latex/.section<CR>8la
nnoremap ,lx2s :-1read ~/.vim/snippets/latex/.subsection<CR>11la
nnoremap ,lx3s :-1read ~/.vim/snippets/latex/.subsubsection<CR>14la

"netrw
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

