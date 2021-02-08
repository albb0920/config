" == albb0920's .vimrc ==
" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" use built in plugin "matchit"
runtime macros/matchit.vim

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
set textwidth=120

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
"set listchars=tab:→\ 
"set list

" file browser use tree mode
let g:netrw_liststyle=3

" filetype specifics
autocmd FileType ruby,eruby,yaml,coffee,pug setl ai sw=2 sts=2 expandtab
autocmd FileType php setl shiftwidth=4 tabstop=4 cinoptions=m1

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

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
Plugin 'VundleVim/Vundle.vim'

" latest ruby support
Plugin 'vim-ruby/vim-ruby'
Plugin 'ruby-matchit'

Plugin 'tpope/vim-rails'
let g:rails_projections = {
	\ "app/javascript/*": {
	\   "command": "javascript",
	\   "affinity": "collection"
	\ },
	\ "test/factories/*.rb": {
	\   "command":   "factory",
	\   "affinity":  "collection",
	\   "alternate": "app/models/%i.rb",
	\   "related":   "db/schema.rb#%s",
	\   "test":      "test/models/%i_test.rb",
	\   "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
	\   "keywords":  "factory sequence"
	\ },
	\ "spec/factories/*.rb": {
	\   "command":   "factory",
	\   "affinity":  "collection",
	\   "alternate": "app/models/%i.rb",
	\   "related":   "db/schema.rb#%s",
	\   "test":      "spec/models/%i_test.rb",
	\   "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
	\   "keywords":  "factory sequence"
	\ }
\}

Plugin 'scrooloose/nerdtree'
Plugin 'dbext.vim'
Plugin 'surround.vim'

"dependency for Fuzzyfinder
Plugin 'L9'
Plugin 'FuzzyFinder'
"autocmd User Rails 
"  \ let g:fuf_coveragefile_globPatterns = [RailsRoot().'**/*']

" workaround for vim 8 paste error
let @@ = ""

Plugin 'YankRing.vim'
let g:yankring_history_dir = '$HOME/.vim'

Plugin 'Rubytest.vim'
let g:rubytest_in_quickfix = 1

Plugin 'tpope/vim-fugitive'

if has('python3')
	let g:gundo_prefer_python3 = 1
end
Plugin 'sjl/gundo.vim'

Plugin 'sjbach/lusty'
nmap <silent> <Leader>b :LustyJuggler<CR>

"Better syntax higtlight for css and scss
Plugin 'hail2u/vim-css3-syntax'
Plugin 'cakebaker/scss-syntax.vim'

"TODO: I might weed some shortcuts for this
Plugin 'Tabular'

Plugin 'tComment'
Plugin 'EasyMotion'
let g:EasyMotion_leader_key = '<Leader>' " EasyMotion leader key

" SnipMate and dependencies
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
let g:snipMate = { 'snippet_version' : 1 }

Plugin 'honza/vim-snippets'
Plugin 'repeat.vim'

" most recent commands
Plugin 'mru.vim'

" syntax check
Plugin 'scrooloose/syntastic'
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=0
let g:syntastic_enable_highlighting=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['scss', 'java', 'cpp'] }
let g:syntastic_python_checkers = ['pycodestyle'] "['python', 'pyflakes', 'pycodestyle']
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_rubocop_args = '--force-exclusion'
let g:syntastic_ruby_rubocop_exe = 'rbenv exec bundle exec rubocop'
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" until jshint supports await
" let g:syntastic_javascript_checkers = ['eslint']

" yaml ruby specific
let g:syntastic_yaml_jsyaml_quiet_messages = {'regex': 'unknown tag !<!binary>'}

" erb
let g:syntastic_eruby_ruby_quiet_messages = {'regex': 'possibly useless use of a variable in void context'}

" coffee script support
Plugin 'kchmck/vim-coffee-script'

" slim
Plugin 'slim-template/vim-slim'

" slm
Plugin 'slm-lang/vim-slm'

" Vue
Plugin 'posva/vim-vue'

" Convert camelCase and MixCase and snake_case
Plugin 'abolish.vim'

" HTML5
Plugin 'othree/html5.vim'

" Open file with line number
Plugin 'wsdjeg/vim-fetch'

Plugin 'Recover.vim'

" Yara syntax
Plugin 'yaunj/vim-yara'

" indent with tab, align with space
" Plugin 'Smart-Tabs'

" Audo indent style detection (buggy with scss, disable for now)
Plugin 'tpope/vim-sleuth'

" ES6 syntax
Plugin 'isRuslan/vim-es6'

" indent motion
Plugin 'jeetsukumaran/vim-indentwise'

" Provides :Mkdir for new file under new directory
Plugin 'eunuch.vim'

Plugin 'djoshea/vim-autoread'

Plugin 'digitaltoad/vim-pug'

" -- No more Plugin is allowed after this
call vundle#end()
filetype plugin indent on

" set type specific stuff here to prevent override by plugins
autocmd FileType python setl tabstop=4 nofoldenable foldmethod=indent expandtab
autocmd FileType slim setl indentexpr= autoindent
autocmd FileType scss,css setl iskeyword+=\- noexpandtab sw=4 ts=4

autocmd BufNewFile,BufRead *.slim setlocal filetype=slim

" -- Syntax highlight and serarch --
" Switch syntax highlighting on, when the terminal has colors

" color scheme
set background=dark

if &t_Co > 2 || has("gui_running")
	syntax on	" this line must be here or syntax plugins won't work
	set hlsearch
endif

"TODO: figure not whats going on with my colors
if has('mac')
	highlight PmenuSel ctermfg=darkblue ctermbg=gray
	highlight Pmenu ctermbg=238 gui=bold
else
	highlight Pmenu ctermbg=green
end

" Over long highlight
let &colorcolumn=join(range(121,999),",")
highlight ColorColumn ctermbg=234

highlight LengthCaution ctermbg=233
call matchadd('LengthCaution', '\%100v.*')

" Tabs
highlight Tabs ctermbg=233
call matchadd('Tabs', '\t')

" highlight trailing space
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
call matchadd('ExtraWhitespace', '\s\+\%#\@<!$', 11)

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
nmap <leader>s :setlocal spell! spell?<CR>

" configure vim-rails

let g:rails_gem_projections = {
	\ "factory_girl_rails": {
	\   "spec/factories/*.rb": {
	\     "command": "factory",
	\     "affinity": "collection",
	\     "alternate": "app/models/%i.rb",
	\     "related": "db/schema.rb#%s",
	\     "test": "spec/models/%i_spec.rb",
	\     "template": "FactoryGirl.define do\n  factory :%i do\n  end\nend",
	\     "keywords": "factory sequence"
	\   },
	\   "test/factories/*.rb": {
	\     "command": "factory",
	\     "affinity": "collection",
	\     "alternate": "app/models/%i.rb",
	\     "related": "db/schema.rb#%s",
	\     "test": "test/models/%i_test.rb",
	\     "template": "FactoryGirl.define do\n  factory :%i do\n  end\nend",
	\     "keywords": "factory sequence"
	\   }
	\ }
\}

" -- Editing shorthands --

" -- Custom hotkey --
map Y y$
set pastetoggle=<F1>
imap <F2> <C-O>:FufCoverageFile<CR>
map  <F2> :FufCoverageFile<CR>
imap <F3> <C-O>:NERDTreeToggle<CR>
map  <F3> :NERDTreeToggle<CR>
imap <F5> <C-O>:GundoToggle<CR>
map  <F5> :GundoToggle<CR>
imap <F6> <C-O>:YRShow<CR>

map  <F10> "+y

" Host specific
autocmd BufRead,BufNewFile */code/sonar_server*/* let g:syntastic_python_checkers = ['python']
autocmd BufRead,BufNewFile */code/tip-hackmd/*.js call UseStandardx()
autocmd BufRead,BufNewFile */code/hackmd-mit/*.js call UseStandardx()

function! UseStandardx()
	setl et sw=2 ts=2
	let g:syntastic_javascript_checkers = ['standard']
	let g:syntastic_javascript_standard_exec = systemlist("yarn bin standardx")[0]
	let g:syntastic_javascript_standard_args = ['--fix']
	let g:syntastic_javascript_standard_generic = 1
	function! SyntasticCheckHook(errors)
		silent! checktime
	endfunction
endfunction
