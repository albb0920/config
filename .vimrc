" == albb0920's .vimrc ==
" Use Vim settings, rather than Vi settings (much better!).
set nocompatible
"
" Vundle wants filetype to be enabled after it's loaded
filetype off

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hidden		" allow hidden buffer 
let mapleader=","
set ai			"Enable auto indent

" tabs
set softtabstop=4	" two space indent by default
set shiftwidth=4
set tabstop=4
set smarttab

" folding
set foldlevel=15

" case-insensive search
set ignorecase
set smartcase

" show invisible chars
" set listchars=tab:→\ 
" set list

" highlight trailing space
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
match ExtraWhitespace /\s\+\%#\@<!$/

" file browser use tree mode
let g:netrw_liststyle=3

" filetype specifics
autocmd FileType ruby,eruby,yaml,coffee setl ai sw=2 sts=2 expandtab
autocmd FileType php setl shiftwidth=4 tabstop=4 cinoptions=m1

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=vih
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " jump to last known cursor position 
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" color scheme
set background=dark

"TODO: figure not whats going on with my colors
if has('mac')
	highlight PmenuSel ctermfg=darkblue ctermbg=gray
	highlight Pmenu ctermbg=238 gui=bold
else
	highlight Pmenu ctermbg=green
end


" mkdir is runed under sh since tcsh and bash has different redirect syntax 
" backup file, in case of system power off etc.
silent !/bin/sh -c "mkdir ~/.vim/backup > /dev/null 2>&1" 
set backupdir=~/.vim/backup
set backup

" undo cross sessions
silent !/bin/sh -c "mkdir ~/.vim/undo > /dev/null 2>&1"
set undodir=~/.vim/undo
set undofile


" If editing this file, autoreload changed
au! BufWritePost .vimrc source %

" folding for yaml/haml/coffee
au BufRead,BufNewFile,BufWrite {*.coffee,*.yaml,*.yml,*.haml} set foldmethod=indent foldlevel=10

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Bundle 'vundle'

" latest ruby support
Bundle 'vim-ruby/vim-ruby'

Bundle 'tpope/vim-rails'
Bundle 'scrooloose/nerdtree'
Bundle 'dbext.vim'
Bundle 'surround.vim'

"dependency for Fuzzyfinder
Bundle 'L9'
Bundle 'FuzzyFinder'
autocmd User Rails 
  \ let g:fuf_coveragefile_globPatterns = [RailsRoot().'**/*']

Bundle 'YankRing.vim'
let g:yankring_history_dir = '$HOME/.vim'

Bundle 'Rubytest.vim'
let g:rubytest_in_quickfix = 1

Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'LustyJuggler'
nmap <silent> <Leader>b :LustyJuggler<CR>

"Better syntax higtlight for css and scss
Bundle 'hail2u/vim-css3-syntax'
Bundle 'cakebaker/scss-syntax.vim'

"TODO: I might weed some shortcuts for this
Bundle 'Tabular'

Bundle 'tComment'
Bundle 'EasyMotion'
let g:EasyMotion_leader_key = '<Leader>' " EasyMotion leader key

Bundle 'msanders/snipmate.vim'
Bundle 'repeat.vim'

" most recent commands
Bundle 'mru.vim'

" syntax check
Bundle 'scrooloose/syntastic'
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=0
let g:syntastic_enable_highlighting=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['scss'] }

" coffee script support
Bundle 'kchmck/vim-coffee-script'

" slim
Bundle 'slim-template/vim-slim'

" Convert camelCase and MixCase and snake_case
Bundle 'abolish.vim'

" HTML5
Plugin 'othree/html5.vim'

" -- No more Bundle is allowed after this
call vundle#end()
filetype plugin indent on

" set type specific stuff here to prevent override by plugins
autocmd FileType python setl tabstop=4 nofoldenable foldmethod=indent noexpandtab


" -- Syntax highlight and serarch --
" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on	" this line must be here or syntax plugins won't work
  set hlsearch
endif

" -- Command shortcuts --
" in case I forget to sudo
cnoreabbrev w!! w !sudo tee % >/dev/null

" save and close buffer
cnoreabbrev bx up<bar>bd

" create path & write
function! WriteCreatingDirs()
    execute ':silent !mkdir -p %:h'
    write
endfunction
command! W call WriteCreatingDirs()

" Retab only indents (from vim wikia)
command! -nargs=1 -range RetabIndents <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

function! SoftTabWithTabStopEightToTabStopFour()
	"TODO: restore values
	set tabstop=8
	set expandtab
	retab
	set noexpandtab
	set tabstop=4
	retab
endfunction
command! FixTabSpace call SoftTabWithTabStopEightToTabStopFour()


" toggle spell check
nmap <leader>s :setlocal spell<CR>

" -- Editing shorthands --

" -- Custom hotkey --
set pastetoggle=<F1>
imap <F2> <C-O>:FufCoverageFile<CR>
map  <F2> :FufCoverageFile<CR>
imap <F3> <C-O>:NERDTreeToggle<CR>
map  <F3> :NERDTreeToggle<CR>
imap <F5> <C-O>:GundoToggle<CR>
map  <F5> :GundoToggle<CR>
imap <F6> <C-O>:YRShow<CR>
