" Fish doesn't play all that well with others
set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" ============================================================================
" Load vundle
set nocompatible
filetype off
set rtp+=~/dev/others/base16/builder/templates/vim/
call plug#begin('~/.vim/plugged')

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'sainnhe/gruvbox-material'
Plug 'sheerun/vim-polyglot'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
"Plug 'fatih/vim-go'
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'udalov/kotlin-vim'

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'

Plug 'scrooloose/nerdtree'
call plug#end()
filetype plugin indent on


"let g:airline_powerline_fonts = 1
"let g:airline_theme='gruvbox-material'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#whitespace#enabled = 1
"let g:airline#extensions#hunks#non_zero_only = 1

set number
set autoread
set backspace=indent,eol,start
set hlsearch
set ignorecase
set incsearch
set mouse=a
set shiftwidth=2
set softtabstop=2
set smartcase
set smarttab
set ttyfast
set undofile
" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

" copy/paste to system clipboard
set clipboard=unnamed

syntax on
syntax enable
set t_Co=256
set encoding=utf-8
" set guifont=Hack
set termguicolors
set background=dark
colorscheme gruvbox-material

" auto close NERDTRee if its the only thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd vimenter * NERDTreeCWD

" navigate panes easier
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright
