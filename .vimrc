" Needed so that vim still understands escape sequences
" nnoremap <esc>^[ <esc>^[

syntax enable
filetype plugin on

nnoremap K <NOP>
noremap <Space> <Nop>
let mapleader=" "
nnoremap <Leader>r :so ~/.vimrc <CR>

command! Tags !ctags -R .

packadd termdebug
let g:termdebug_popup = 0
let g:termdebug_wide = 123

" WSL yank support
" Option 1 (only yank) ------------
"let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
"if executable(s:clip)
"    augroup WSLYank
"	autocmd!
"        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
"    augroup END
"endif
" ------------

" Option 2 (yank and paste) ------------
" Requires win32yank.exe:
"	curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
"	sudo apt install zip
"	unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
"	chmod +x /tmp/win32yank.exe
"	sudo mv /tmp/win32yank.exe /usr/local/bin/

autocmd TextYankPost * call system('win32yank.exe -i --crlf', @")

function! Paste(mode)
    let @" = system('win32yank.exe -o --lf')
	return a:mode
endfunction
map <expr> p Paste('p')
map <expr> P Paste('P')
" ------------

highlight LineNr ctermfg=yellow

set clipboard=unnamedplus
set tags=./tags,tags;/
set tagstack
set notermguicolors t_Co=8
set mouse=a
set path+=**
set nu
set relativenumber
set shiftwidth=4
set smarttab
set smartindent
set nocompatible
set nohlsearch
set hidden
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set wildmenu
set splitright splitbelow 
set vb t_vb=
set statusline=%{strftime('%c',getftime(expand('%')))}
set ttyfast
set guicursor=i:ver25-iCursor
set ttimeout
set timeoutlen=333
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

" ctags
nnoremap t[ g<c-]>
vnoremap t[ g<c-]>
nnoremap t] :pop!<CR>
vnoremap t] :pop!<CR>

"Delete all comments
map DAC# :g/^\s*#/d <CR>
map DAC// :g/^\s*#/d <CR>

"Easy switching panes
nnoremap <silent><Leader>h <C-w>h
nnoremap <silent><Leader>j <C-w>j
nnoremap <silent><Leader>k <C-w>k
nnoremap <silent><Leader>l <C-w>l

"Pane resizing
nnoremap <silent><Leader>K :exe "resize " . (winheight(0) * 9/7)<CR>
nnoremap <silent><Leader>J :exe "resize " . (winheight(0) * 7/9)<CR>
nnoremap <silent><Leader>L :exe "vertical resize " . (winwidth(0) * 9/7)<CR>
nnoremap <silent><Leader>H :exe "vertical resize " . (winwidth(0) * 7/9)<CR>

"Latex snippets (snippet file with its literal text required at the path read)
nnoremap ,lx\\ :-1read ~/.vim/snippets/latex/.Article<CR>11j6la
nnoremap ,lxbf :-1read ~/.vim/snippets/latex/.textbf<CR>7la
nnoremap ,lxit :-1read ~/.vim/snippets/latex/.textit<CR>7la
nnoremap ,lxtt :-1read ~/.vim/snippets/latex/.texttt<CR>7la
nnoremap ,lxs :-1read ~/.vim/snippets/latex/.section<CR>8la
nnoremap ,lx2s :-1read ~/.vim/snippets/latex/.subsection<CR>11la
nnoremap ,lx3s :-1read ~/.vim/snippets/latex/.subsubsection<CR>14la

"netrw
let g:netrw_banner=0
let g:netrw_browse_split=0
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

highlight Comment ctermfg=14
highlight jsonQuote ctermfg=red


highlight redOnes ctermfg=red
call matchadd("redOnes", '\<False\>')
call matchadd("redOnes", '\<None\>')
call matchadd("redOnes", '\<NULL\>')
