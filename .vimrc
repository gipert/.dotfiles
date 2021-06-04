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
    Plug 'SirVer/ultisnips', { 'tag': '*' }
  endif

  " disable on other hosts and for .C files (ROOT macros).
  " -- not sure if this is the best way to do it --
  if (has('macunix') || hostname() ==# 'lxpertoldi' || hostname() ==# 'hackintosh' || hostname() ==# 'thinkpad')
        \ && expand('%:e') !=# 'C' && &filetype !=# 'julia'

    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
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
  Plug 'sersorrel/vim-lilypond', { 'branch': 'main' }
  Plug 'singularityware/singularity.lang', {'rtp': 'vim/'}

call plug#end()

" auto-install missing plugins at startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" this is to make sure that vim-sensible is loaded at this point
runtime! plugin/sensible.vim

" set shell
if executable('zsh')
  set shell=zsh
else
  set shell=bash
endif

if has('mouse') " mouse support?
  set mouse=a
endif

let g:tex_flavor='latex'       " for .tex filetype detection, needed for vimtex to work!
set nowrap                     " auto-wrap is evil
set incsearch                  " highlights what you are searching for as you type
set ignorecase                 " ignores case in search patterns
set smartcase                  " don't ignore case when the search pattern has uppercase
set infercase                  " during keyword completion, fix case of new word (when ignore case is on)
set number                     " line numbers
set tabstop=4                  " tab width is 4 spaces
set shiftwidth=4               " indent also with 4 spaces
set expandtab                  " expand tabs to spaces
set wildmode=longest:full,full " the default tab-completion behaviour is simply annoying
set list                       " cool chars to highlight trailing spaces, end-of-lines and tabs
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<

" remove <F1> help and Ex mode keybind, I always hit it by mistake
nnoremap <F1> <Nop>
nnoremap Q <Nop>

" set 72 max line width when composing in mutt
augroup my_mutt
  autocmd BufRead /tmp/mutt-* set tw=72
augroup END

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

" italic comments and colorscheme settings
if $TERM !=? '' || has('gui_running')
  highlight Comment cterm=italic
else
  colorscheme solarized
endif

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
let g:ale_linters = { 'cpp': [] } " let YCM do its job

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
  autocmd FileType c,cpp,cs,java,asy setlocal commentstring=//\ %s
  autocmd FileType asm,julia,singularity setlocal commentstring=#\ %s
  autocmd FileType lilypond setlocal commentstring=%\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
augroup END

augroup filetypedetect
  au BufNewFile,BufRead *.asy setf asy
augroup END

" Julia-Vim
let g:latex_to_unicode_auto = 1

" configuration file for c++ is ~/.vim/ftplugin/cpp.vim
" configuration file for tex in ~/.vim/ftplugin/tex.vim

" vim: tabstop=2 shiftwidth=2 expandtab
