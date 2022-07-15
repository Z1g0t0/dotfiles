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

set mouse=a
set clipboard=unnamedplus
set tags=./tags;
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
set timeoutlen=666
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set fillchars+=vert:│

" --- COLORS ---

hi VertSplit cterm=NONE ctermfg=4

" Manually set the status line color.
hi StatusLine ctermbg=black ctermfg=green
hi StatusLineNC ctermbg=green ctermfg=14 "Dark Green
"hi StatusLineTerm ctermbg=black ctermfg=green guibg=magenta guifg=red
"hi StatusLineTermNC ctermbg=black ctermfg=green guibg=magenta guifg=red

hi Visual ctermbg=2 ctermfg=4
hi LineNr ctermfg=yellow
hi Folded ctermfg=yellow ctermbg=black
hi FoldColumn ctermfg=yellow ctermbg=black
hi Comment ctermfg=14	"Dark Green
hi jsonQuote ctermfg=red
hi Include ctermfg=3	"Purple
hi Error term=reverse cterm=bold ctermfg=black ctermbg=5 "Red
hi Special cterm=bold ctermfg=5  "Red
hi MatchParen ctermfg=3

" Git
set diffopt=vertical
hi DiffAdd cterm=bold ctermfg=green ctermbg=14 "Dark Green
hi DiffChange cterm=bold ctermfg=black ctermbg=3 "Puple
hi DiffText cterm=bold ctermfg=green ctermbg=3 "Purple
hi DiffDelete cterm=bold ctermfg=black ctermbg=5 "Red

" Red
highlight redOnes ctermfg=red
call matchadd("redOnes", '\<\cFalse\>')
call matchadd("redOnes", '\<\cNULL\>')
call matchadd("redones", '\Error\')

" Green
highlight greenOnes ctermfg=green
call matchadd("greenOnes", '\<\cTrue\>')

" Grey
highlight greyOnes ctermfg=grey
call matchadd("greyOnes", '\<\cNone\>')
" --- || ---

" --- MISC ---

" Thin cursor at insert mode

" - Option 1 -
"if exists('$TMUX')
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
"else
"    let &t_SI = "\e[5 q"
"    let &t_EI = "\e[2 q"
"endif

" - Option 2 -
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Auto center navigation
nnoremap <expr> \ "'" . nr2char(getchar()) . 'zz'
nnoremap <C-o> <C-o>zz
nnoremap n nzz
nnoremap N Nzz

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
" --- || ---

" --- MAPPINGS --- 
"
nnoremap <silent><Leader>H :call TmuxResize('h', 1)<CR>
nnoremap <silent><Leader>J :call TmuxResize('j', 1)<CR>
nnoremap <silent><Leader>K :call TmuxResize('k', 1)<CR>
nnoremap <silent><Leader>L :call TmuxResize('l', 1)<CR>

"Delete all comments
map DAC# :g/^\s*#/d <CR> map DAC// :g/^\s*#/d <CR> 

" - SNIPPETS -
" Latex 
nnoremap ,lx\\ :-1read ~/.vim/snippets/latex/.Article<CR>11j6la
nnoremap ,lxbf :-1read ~/.vim/snippets/latex/.textbf<CR>7la
nnoremap ,lxit :-1read ~/.vim/snippets/latex/.textit<CR>7la
nnoremap ,lxtt :-1read ~/.vim/snippets/latex/.texttt<CR>7la
nnoremap ,lxs :-1read ~/.vim/snippets/latex/.section<CR>8la
nnoremap ,lx2s :-1read ~/.vim/snippets/latex/.subsection<CR>11la
nnoremap ,lx3s :-1read ~/.vim/snippets/latex/.subsubsection<CR>14la

" Python
nnoremap ,pdb :-1read ~/.vim/snippets/python/.pdb<CR>0i<Tab>
" - || -
" --- || ---



"netrw
let g:netrw_banner=0
let g:netrw_browse_split=0
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

call plug#begin()

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'idanarye/vim-merginal'

call plug#end()

