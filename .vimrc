" Set compatibility to Vim only - because compatibility with basic Vi turns
" off most of the IMproved stuff
set nocompatible

" Helps force plug-ins to load correctly when it is turned back on below.

set nocp
filetype on

set noswapfile

set virtualedit=block

" Buffers become hidden when abandoned
set hidden

" Never get angry again:
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>
command! -bang Q q<bang>
command! -bang W w<bang>

" Longer update times leads to noticable delays
set updatetime=300


""" Customize colors
func! s:my_colors_setup() abort
    " this is an example
    hi Pmenu guibg=#d7e5dc gui=NONE
    hi PmenuSel guibg=#b7c7b7 gui=NONE
    hi PmenuSbar guibg=#bcbcbc
    hi PmenuThumb guibg=#585858
endfunc

augroup colorscheme_coc_setup | au!
    au ColorScheme * call s:my_colors_setup()
augroup END


" Encoding

set encoding=utf-8

" My leader is space
let mapleader = (' ')

" Some files need more memory for syntax highlight
set mmp=5000



" set the runtime path to include vim-plug and initialize
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-rhubarb'

" Amazing when writing markdown in vim, just paste image from clipboard - fkin
" conventient
Plug 'ferrine/md-img-paste.vim'
autocmd FileType markdown nmap <buffer><silent> <leader><leader>p :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = 'img'
"let g:mdip_imgname = 'image'

Plug 'airblade/vim-rooter'

Plug 'fisadev/vim-isort'

Plug 'unblevable/quick-scope'

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#00C7DF' gui=underline ctermfg=154 cterm=underline
highlight QuickScopeSecondary guifg='#afff5f' gui=underline ctermfg=80 cterm=underline

"let g:qs_max_chars=150


if executable('rg')
    let g:rg_derive_root='true'
endif

" Visually select more than 1 word and hit * to search for longer texts
Plug 'nelstrom/vim-visual-star-search'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'

" Automatically clear search highlighting after move of cursor.
Plug 'haya14busa/is.vim'


let g:UltiSnipsExpandTrigger = "<nop>"

Plug 'lifepillar/vim-gruvbox8'
Plug 'morhetz/gruvbox'

set t_Co=256
syntax on
set background=dark




let g:fzf_layout = { 'window': {'width': 0.8, 'height':0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'


command! Lfko call LfFloat()

nnoremap <C-p> :Lfko<CR>

function! LfFloat() abort

    let curr_dir= expand("%:p:h")
    let id = Flt_term_win("lf -selection-path /tmp/lf_result " . curr_dir, 0.8,0.8, '')
    execute 'autocmd BufWipeout * ++once call Open_lf_callback("/tmp/lf_result")'
    return winbufnr(id)
endfunction

function! Open_lf_callback(selection_path) abort
    let s:choice_file_path = '/tmp/lf_result'
    if filereadable(a:selection_path)
      for f in readfile(a:selection_path)
        exec "edit " . f
      endfor
    endif
    call delete(a:selection_path)
    redraw!
    " reset the filetype to fix the issue that happens
    " when opening lf on VimEnter (with `vim .`)
    filetype detect
endfunction


function! Flt_term_win(cmd, width, height, border_highlight) abort
    let width = float2nr(&columns * a:width)
    let height = float2nr(&lines * a:height)
    let bufnr = term_start(a:cmd, {'hidden': 1, 'term_finish': 'close'})

    let winid = popup_create(bufnr, {
	    \ 'minwidth': width,
	    \ 'maxwidth': width,
	    \ 'minheight': height,
	    \ 'maxheight': height,
	    \ 'border': [],
	    \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
	    \ 'borderhighlight': [a:border_highlight],
	    \ 'padding': [0,1,0,1],
	    \ 'highlight': a:border_highlight
	    \ })

    " Optionally set the 'Normal' color for the terminal buffer
    call setwinvar(winid, '&wincolor', 'Cool')
    return winid

endfunction

function! GFilesFallback()
  let curr_dir= expand("%:p:h")
  let output = system('git -C ' . curr_dir . ' rev-parse --show-toplevel')
  let prefix = get(g:, 'fzf_command_prefix', '')
  if v:shell_error == 0
    exec "normal :" . prefix . "GFiles\<CR>"
  else
    exec "normal :" . prefix . "Files \%:p:h\<CR>"
  endif
  return 0
endfunction

nnoremap <C-f> :call GFilesFallback()<CR>

" Allow passing optional flags into rg
" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)

Plug 'mhinz/vim-grepper'

let g:grepper={}
let g:grepper.tool=["rg"]

" Project wide find and replace (can do regexes if goes to the replaced stuff)
nnoremap <Leader>R
	\ :let @s='\<'.expand('<cword>').'\>'<CR>
	\ :Grepper -cword -noprimpt<CR>
	\ :cfdo %s/<C-r>s// \| update
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

nnoremap <C-g> :Rg<CR>
nnoremap <C-e> :Buffers<CR>
nnoremap <leader>e :Buffers<CR>
nnoremap <leader>h :History<CR>

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
  \ }

Plug 'scrooloose/nerdcommenter'
vmap <leader>c <plug>NERDCommenterToggle
nmap <leader>c <plug>NERDCommenterToggle

Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

Plug 'sstallion/vim-cursorline'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Coc is confused? run ":CocRes'

set statusline^=%{coc#status()}

" Add airline to Tmux
" For now, we alerady snapshotted the vim tmuxline.vim config for .tmux.conf...
" Btw. you can snapshot it by :TmuxlineSnaphot [file] (for me file=.tmuxline)
"Plug 'edkolev/tmuxline.vim'

"Plug 'tmhedberg/SimpylFold'
Plug 'kalekundert/vim-coiled-snake'
Plug 'Konfekt/FastFold'

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '' . repeat(" ",fillcharcount) . '(' . foldedlinecount . ')' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" Checking syntax on every change
"
" use coc-linter instead
" Plug 'vim-syntastic/syntastic'


Plug 'tpope/vim-surround'

" Airline plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"
let g:airline_theme='distinguished'
let g:airline_powerline_fonts = 0

"Plug 'itchyny/lightline.vim'
"
"
"let g:lightline = {
"      \ 'colorscheme': 'seoul256',
"      \ 'active': {
"      \   'left': [ [ 'mode', 'paste' ],
"      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"      \ },
"      \ 'component_function': {
"      \   'gitbranch': 'FugitiveHead'
"      \ },
"      \ }

" set alternate color for modified active/inactive tabs

Plug 'vimwiki/vimwiki'

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'},
		      \	 {'path': '~/my_site/',
                      \ 'syntax': 'markdown', 'ext': '.md'},
		      \	 {'path': '~/tools/extendwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:markdown_folding = 1

"!pip install --user smdv
Plug 'suan/vim-instant-markdown', {'rtp': 'after'}
let g:instant_markdown_autostart = 0
map <leader>md :InstantMarkdownPreview<CR>

"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

" !pip install python-language-server
"if executable('pyls')
"    " pip install python-language-server
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'pyls',
"        \ 'cmd': {server_info->['pyls']},
"        \ 'whitelist': ['python'],
"        \ })
"endif


"let g:LanguageClient_loggingFile = '~/tmp/lc.log'
"let g:LanguageClient_loggingLevel = 'DEBUG'

"let g:lsp_preview_autoclose = 1
"let g:lsp_signature_help_enabled = 0
"let g:lsp_signs_error = {'text': '✗'}
"let g:lsp_signs_enabled = 1         " enable signs
"let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
"let g:asyncomplete_auto_popup = 1

"function! s:on_lsp_buffer_enabled() abort
"setlocal omnifunc=lsp#complete
"setlocal signcolumn=yes
"if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"endfunction


"augroup lsp_install
"    au!
"        " call s:on_lsp_buffer_enabled only for languages that has the
"" server registered.
"     autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
"     augroup END


source ~/dotfiles/coc_config.vim

set completeopt-=preview

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"let g:asyncomplete_auto_popup = 1
"let g:asyncomplete_smart_completion = 1
"let g:asyncomplete_remove_duplicates = 1

" Syntastic custom config
let g:syntastic_check_on_wq = 0

"nnoremap <leader>r :LspReferences<CR>
"nnoremap <leader>d :LspDefinition<CR>

set completeopt-=preview
" This remap is not so much motivated by lsp, but
" by wierd behaviour of <C-space>, which is <Nul> in vimspeak :D
" it somehow inserts last couple of inserted chars and exits to normal mode
inoremap <Nul> <C-n>

" Indent python
Plug 'vim-scripts/indentpython.vim'

" Easy-motion
Plug 'easymotion/vim-easymotion'

"Plug 'ptzz/lf.vim'
"let g:lf_map_keys = 0
"nmap <C-p> :Lf<CR>


Plug 'tpope/vim-fugitive'
    " :G to bring the window, '-' to stage/unstage, '=' to view diff, 'cc' to commit
    " out of window: press '=' - brings up inline diff, select hunk via visual and press '-'
    " merge conflicts: ':G', pres dv on the file that I want to resolve, to close C-w + C-O (or S-o)
    " gitignore: ':G' go to a file and type any number 7gI, or 4gI and it will " autoadd it to gitignore

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>

let g:cocPlugInstall = 'yarn install --frozen-lockfile'
Plug 'neoclide/coc-json', {'do': cocPlugInstall }
Plug 'neoclide/coc-python', {'do': cocPlugInstall }
Plug 'neoclide/coc-snippets', {'do': cocPlugInstall }

Plug 'mbbill/undotree' ":UndotreeToggle || press ? while in undotree window
nmap <leader>u :UndotreeToggle<CR>


Plug 'honza/vim-snippets'

let g:ultisnips_python_style="google"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

"use system clipboard
set clipboard=unnamed

" New splits
nmap <leader>s :split<CR>
nmap <leader>v :vsplit<CR>

Plug 'christoomey/vim-tmux-navigator'


highlight VertSplit cterm=NONE
set fillchars+=vert:\▏

" Disable default mappings
let g:EasyMotion_do_mapping = 0

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" NERDTreesyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

Plug 'scrooloose/nerdtree'

" NERDTreeTabs
Plug 'jistr/vim-nerdtree-tabs'

" NERDTree ignore *.pyc *.swp
let NERDTreeIgnore=['\.pyc$', '\.swp$', '\~$'] "ignore files in NERDTree


map <Leader>n <plug>NERDTreeTabsToggle<CR>

" ...

" All of your Plugs must be added before the following line
call plug#end()            " required

hi Normal guibg=NONE ctermbg=NONE

" Let my code be pretty
let python_highlight_all=1
syntax on

" Don't use it now as we already have snapshot of this for .tmux.conf
" let g:tmuxline_preset = 'righteous'

set wildmode=longest,list,full
set wildmenu

" Remap esc to my favorite mix
:imap jk <Esc>
:imap kj <Esc>

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"
" Turn off modelines
set modelines=0

set undofile
set undodir=~/.vim/undodir
" !mkdir ~/.vim/undodir

let @p='yiwoprint("kjpA")kjyypf"x;xkVj<................Vjd'

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Automatically wrap text that extends beyond the screen length.
set wrap
" Vim's auto indentation feature does not work properly with text copied from
" outisde of Vim. Press the <F2> key to toggle paste mode on/off.
" Or just select your stuff and use " '='
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>


" Display 6 lines above/below the cursor when scrolling with a mouse.
set scrolloff=6
" Fixes common backspace problems
set backspace=indent,eol,start

" Remap confirmation for searches
cnoremap jk <CR>
cnoremap kj <CR>

" This remap is really bad when controlling visual selection
" vno jk <Esc>
" vno kj <Esc>

" the greatest one
vnoremap <leader>p "_dP

" Do the harlem shake!
set mouse=a

" NERDTree keybindings
let NERDTreeQuitOnOpen=1 " Autoclose NERDTREE on file opening
let NERDTreeMapActivateNode='l' " Toggle child nodes with l
"let NERDTreeMapActivateNode='h' " Toggle child nodes with h
"let NERDTreeMapCloseChildren='h' " Close  child nodes with h

" Speed up scrolling in Vim
set ttyfast

" Nicer visual selection
hi Visual term=bold cterm=bold guibg=green

" Status bar
set laststatus=1

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

highlight LineNr ctermfg=grey


" Display options
set showmode
set showcmd


" Highlight matching pairs of brackets.
set matchpairs+=<:>


" Enable resize of vim when is tmux
if has("mouse_sgr")
    set ttymouse=sgr
else

  if !has('nvim')
    set ttymouse=xterm2
  endif
end

" Display different types of white spaces.
set listchars=tab:›\ ,extends:#,nbsp:.
set listchars=trail:\

" Toggle lineNumbers
nnoremap <leader>l :set relativenumber!<cr>:set number!<cr>


nnoremap <leader>o :normal yiwologger.debug(f"<Esc>pa: {<Esc>pa}")<Esc>
vnoremap <leader>o yologger.debug(f"<Esc>pa: {<Esc>pa}")<Esc>


" Show line numbers
set number

" Full stack dev indentation
au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth

" Add the proper PEP 8 indentation
au BufNewFile,BufRead *.py,*.pyx
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


" Split a new window to the right
set splitright
" Split a new window to the bottom
set splitbelow


" Settings for compatibility with tmux colorscheme vim
set background=dark
set t_Co=256


" Highlight matching search patterns
set hlsearch
" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase


function! ScrollQuarter(move)
    let height=winheight(0)

    if a:move == 'up'
        let key="k"
    else
        let key="j"
    endif

    "execute 'normal! ' . height/7 . key
    execute 'normal! ' . 4 . key
endfunction

nnoremap <silent> <C-u> :call ScrollQuarter('up')<CR>
nnoremap <silent> <C-d> :call ScrollQuarter('down')<CR>


" One of the least invasive pep8 fun
highlight ColorColumn ctermbg=59 guibg=grey
call matchadd('ColorColumn', '\%81v', 100)

" Store info from no more than 101 files at a time, 9999 lines of text,
" 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s101

" Press * to search for the term under the cursor a visual selection and
" then <leader>r to replace all the instances in the curr file.
nnoremap <Leader>r :%s///g<Left><Left>
xnoremap <Leader>r :s///g<Left><Left>

nnoremap <Leader>rc :%s///gc<Left><Left><Left>
xnoremap <Leader>rc :s///gc<Left><Left><Left>

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Leader>f @=(foldlevel('.')?'za':"\<Leader>")<CR>
vnoremap <Leader>f zf

" I don't like background highlighting at all
highlight Folded ctermbg=black

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

""augroup vimrc
""    autocmd BufWritePost *
""    \   if expand('%') != '' && &buftype !~ 'nofile'
""    \|      mkview
""    \|  endif
""    autocmd BufRead *
""    \   if expand('%') != '' && &buftype !~ 'nofile'
""    \|      silent loadview
""    \|  endif
""augroup END

"autocmd VimEnter * silent exec "! echo -ne 'ge[1 q'"
"autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"

" Reset cursor on startup
"augroup ResetCursorShape
"au!
"autocmd VimEnter * :normal :startinsert :stopinsert
"augroup END

augroup VIMRC
  autocmd!

  autocmd BufWinLeave *.vimrc normal! mV
  autocmd BufWinLeave *.zshrc normal! mZ
  autocmd BufWinLeave Makefile normal! mM
augroup END

"" This is for preserving folds, if not working, add incremental number to the
" last argument up to 9, after that clear all files from mkview dir
augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview! 2
  au BufWinEnter ?* silent! loadview 2
augroup END
set viewoptions-=options

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Sort import on save
" autocmd BufWritePre *.py :Isort

" Format by black on save
" autocmd BufWritePre *.py :Format

" set cursorline
" colorscheme gruvbox8
set noshowmode
set shortmess+=F
