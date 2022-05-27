" Needed so that vim still understands escape sequences
" nnoremap <esc>^[ <esc>^[

syntax enable
filetype plugin on

nnoremap K <NOP>
noremap <Space> <Nop>
let mapleader=" "
nnoremap <Space> <C-w>
nnoremap <Leader>r :so ~/.vimrc <CR>

command! Tags !ctags -R .

packadd termdebug
let g:termdebug_popup = 0
let g:termdebug_wide = 123

" ------------ WSL yank support ------------
" --- Option 1 (yank only) 
"
"let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
"if executable(s:clip)
"    augroup WSLYank
"	autocmd!
"        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
"    augroup END
"endif
"
" --- || ---
"
" --- Option 2 (yank and paste) 
" - Requires win32yank.exe:
"	$ curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
"	$ sudo apt install zip
"	$ unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
"	$ chmod +x /tmp/win32yank.exe
"	$ sudo mv /tmp/win32yank.exe /usr/local/bin/

autocmd TextYankPost * call system('win32yank.exe -i --crlf', @")

function! Paste(mode)
    let @" = system('win32yank.exe -o --lf')
	return a:mode
endfunction
map <expr> p Paste('p')
map <expr> P Paste('P')

" --- || ---
"
" ------------ || ------------

let &statusline='%#Normal# '

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
"set ttyfast
set guicursor=i:ver25-iCursor
set ttimeout
set timeoutlen=333
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set fillchars+=vert:│

" Colors

hi VertSplit cterm=NONE ctermfg=4

" Manually set the status line color.
hi StatusLine ctermbg=black ctermfg=green 
hi StatusLineNC ctermbg=black ctermfg=red 
"hi StatusLineTerm ctermbg=black ctermfg=green guibg=magenta guifg=red
"hi StatusLineTermNC ctermbg=black ctermfg=green guibg=magenta guifg=red

highlight LineNr ctermfg=yellow
highlight Comment ctermfg=14
highlight jsonQuote ctermfg=red
" Red
highlight redOnes ctermfg=red
call matchadd("redOnes", '\<False\>')
call matchadd("redOnes", '\<NULL\>')
" Green
highlight greenOnes ctermfg=green
call matchadd("greenOnes", '\<True\>')
" Grey
highlight greyOnes ctermfg=grey
call matchadd("greyOnes", '\<None\>')

"Thin cursor at insert mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

" Auto center navigation
nnoremap <expr> \ "'" . nr2char(getchar()) . 'zz'
nnoremap <C-o> <C-o>zz

" ctags
nnoremap t[ g<c-]>
vnoremap t[ g<c-]>
nnoremap t] :pop!<CR>
vnoremap t] :pop!<CR>

"Easy switching panes
nnoremap <silent><Leader>h <C-w>h
nnoremap <silent><Leader>j <C-w>j
nnoremap <silent><Leader>k <C-w>k
nnoremap <silent><Leader>l <C-w>l

"Pane resizing
" Tmux-like window resizing
function! IsEdgeWindowSelected(direction)
    let l:curwindow = winnr()
    exec "wincmd ".a:direction
    let l:result = l:curwindow == winnr()

    if (!l:result)
        " Go back to the previous window
        exec l:curwindow."wincmd w"
    endif

    return l:result
endfunction

function! GetAction(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:actions = ['vertical resize -', 'resize +', 'resize -', 'vertical resize +']
    return get(l:actions, index(l:keys, a:direction))
endfunction

function! GetOpposite(direction)
    let l:keys = ['h', 'j', 'k', 'l']
    let l:opposites = ['l', 'k', 'j', 'h']
    return get(l:opposites, index(l:keys, a:direction))
endfunction

function! TmuxResize(direction, amount)
    " v >
    if (a:direction == 'j' || a:direction == 'l')
        if IsEdgeWindowSelected(a:direction)
            let l:opposite = GetOpposite(a:direction)
            let l:curwindow = winnr()
            exec 'wincmd '.l:opposite
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    " < ^
    elseif (a:direction == 'h' || a:direction == 'k')
        let l:opposite = GetOpposite(a:direction)
        if IsEdgeWindowSelected(l:opposite)
            let l:curwindow = winnr()
            exec 'wincmd '.a:direction
            let l:action = GetAction(a:direction)
            exec l:action.a:amount
            exec l:curwindow.'wincmd w'
            return
        endif
    endif

    let l:action = GetAction(a:direction)
    exec l:action.a:amount
endfunction

" Map to buttons
nnoremap <silent><Leader>H :call TmuxResize('h', 1)<CR>
nnoremap <silent><Leader>J :call TmuxResize('j', 1)<CR>
nnoremap <silent><Leader>K :call TmuxResize('k', 1)<CR>
nnoremap <silent><Leader>L :call TmuxResize('l', 1)<CR>

"Delete all comments
map DAC# :g/^\s*#/d <CR> map DAC// :g/^\s*#/d <CR> 

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
let g:netrw_browse_split=0
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'

call plug#end()

