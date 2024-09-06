" Fish doesn't play all that well with others
set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" ============================================================================
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

" navigate panes easier
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap ; :

set splitbelow
set splitright


" run rustfmt for .rs files when buffer is saved
let g:rustfmt_autosave = 1

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


" This is an example on how rust-analyzer can be configure using rust-tools

" Prerequisites:
" - neovim >= 0.5
" - rust-analyzer: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary

" Steps:
" - :PlugInstall
" - Restart

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error



