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
call plug#begin()
" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'
Plug 'terryma/vim-multiple-cursors'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'

" GUI enhancements
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'sainnhe/gruvbox-material'
Plug 'sheerun/vim-polyglot'
Plug 'andymass/vim-matchup'

" Fuzzy finder
"Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'udalov/kotlin-vim'

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'

Plug 'scrooloose/nerdtree'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

filetype plugin indent on

set autoread
set backspace=indent,eol,start
" search
set hlsearch
noremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>
set ignorecase
set incsearch
" enable mouse
set mouse=a
" tabs/spaces
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
" set smarttab
set smartcase
set ttyfast
set ttimeout
set wrap
set linebreak
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
" turn hybrid line numbers on
set number
set relativenumber
" auto wrap
set tw=80
set colorcolumn=80

" copy/paste to system clipboard
set clipboard=unnamedplus

" change cursor in insert mode
au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"

syntax on
syntax enable
set t_Co=256
set encoding=utf-8
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

" open fzf in nerdtree easier
nnoremap <silent> <C-p> :FZF<CR>
" run rustfmt for .rs files when buffer is saved
let g:rustfmt_autosave = 1

" Persistent undos
set undodir=~/.vim/undodir

" :w saves and creates parent directories if needed
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" :W saves and creates parent directories if needed
function WriteCreatingDirs()
    execute ':silent !mkdir -p %:h'
    write
endfunction
command W call WriteCreatingDirs()


" Conqueror of Completion

" smart navigation
nmap <silent> <leader>l <Plug>(coc-diagnostic-info)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
