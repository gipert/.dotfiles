set encoding=utf-8      " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
scriptencoding utf-8

" allow all vim cool things
set nocompatible

" add custom directory to runtimepath
set runtimepath+=~/.vim/templates

" vim-plug settings
call plug#begin('~/.vim/plugged')

  if v:version >= 704
    Plug 'lervag/vimtex'
    Plug 'SirVer/ultisnips'
  endif

  " disable for .C files (ROOT macros).
  " Not sure if this is the best way to do it
  if hostname() ==# 'lxpertoldi.pd.infn.it' && expand('%:e') !=# 'C'
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
  endif

  Plug 'honza/vim-snippets'
  Plug 'matze/vim-tex-fold'
  Plug 'Konfekt/FastFold'
  Plug 'reedes/vim-wheel'
  Plug 'JuliaEditorSupport/julia-vim'
  Plug 'xu-cheng/brew.vim'
  Plug 'tpope/vim-sensible'

  if $TERM !=? '' || has('gui_running')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
  endif

  Plug 'tpope/vim-fugitive'
  Plug 'w0rp/ale'
  Plug 'matze/vim-move'
  Plug 'altercation/vim-colors-solarized'
  Plug 'morhetz/gruvbox'
  Plug 'leafgarland/typescript-vim'
  Plug 'posva/vim-vue'
  Plug 'neomutt/neomutt.vim'
  Plug 'tpope/vim-commentary'
  Plug 'godlygeek/tabular'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'wesQ3/vim-windowswap'

call plug#end()

" this is to make sure that vim-sensible is loaded at this point
runtime! plugin/sensible.vim
" set shell
if executable('zsh')
  set shell=zsh
else
  set shell=bash
endif
" for .tex filetype detection, needed for vimtex to work!
let g:tex_flavor = 'latex'
" mouse support!
set mouse=a
" line numbers
set number
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" remove <F1> help keybind
map <F1> <Nop>
" the tab-completion default behaviour is simply annoying.
set wildmode=longest:full,full

" set 72 max line width when composing in mutt
augroup my_mutt
  autocmd BufRead /tmp/mutt-* set tw=72
augroup END

" cool chars
set list
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<

" command to remove trailing whitespace
command StripWhitespace %s/\s\+$//e

" Color Scheme settings
colorscheme gruvbox
set background=dark
syntax on
" Highlight TODO, FIXME, NOTE, INFO, BUG etc.
if v:version > 701
  augroup my_high
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
  augroup END
endif
" better colors for list chars
highlight NonText ctermfg=238
highlight SpecialKey ctermfg=238

if $TERM !=? '' || has('gui_running')
  " italic comments
  highlight Comment cterm=italic
else
  colorscheme solarized
endif

" in normal mode F2 will save the file
nmap <F2> :w<CR>
" in insert mode F2 will exit insert, save, enters insert again
imap <F2> <ESC>:w<CR>i

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger         = '<F3>'
let g:UltiSnipsJumpForwardTrigger    = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger   = '<c-k>'
let g:UltiSnipsEditSplit             = 'vertical'
let g:UltiSnipsSnippetsDir           = '~/.vim/templates/UltiSnips'
let g:templates_no_autocmd           = 1
let g:templates_no_builtin_templates = 1

" vim-airline settings
set noshowmode
let g:bufferline_echo         = 0
let g:airline_powerline_fonts = 1
"let g:airline_solarized_bg    = 'dark'

" ale settings
" Enable completion where available.
let g:ale_lint_delay = 2000
let g:ale_pattern_options = {'\.C': {'ale_enabled': 1}} " this is for ROOT macros
let g:ale_completion_enabled = 1
let g:ale_linters = { 'python': ['flake8'] }

" gutter options
if v:version >= 750
  hi SignColumn ctermbg = black
  set signcolumn=yes
endif

" YouCompleteMe settings
let g:ycm_global_ycm_extra_conf                     = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf                        = 0
let g:ycm_add_preview_to_completeopt                = 1
let g:ycm_seed_identifiers_with_syntax              = 0
let g:ycm_min_num_of_chars_for_completion           = 2
let g:ycm_autoclose_preview_window_after_completion = 1

" vim-move settings
let g:move_key_modifier = 'C'

" vim-commentary settings
augroup commentary
  autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
  autocmd FileType asm,julia     setlocal commentstring=#\ %s
augroup END

" configuration file for c++ is ~/.vim/ftplugin/cpp.vim
" configuration file for tex in ~/.vim/ftplugin/tex.vim

" vim: tabstop=2 shiftwidth=2 expandtab
