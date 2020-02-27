augroup filetypedetect
  " Git commit message
  autocmd Filetype gitcommit                         setlocal spell tw=72 colorcolumn=73
  " No autocomplete in text
  autocmd Filetype text let g:deoplete#enable_at_startup = 0
  autocmd Filetype markdown let g:deoplete#enable_at_startup = 0
  " clang format
  autocmd FileType c,cpp ClangFormatAutoEnable
augroup END
