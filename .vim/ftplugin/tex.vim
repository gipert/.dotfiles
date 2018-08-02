" LaTex settings
filetype indent on
set tabstop=2
set shiftwidth=2
"set expandtab
set grepprg=grep\ -nH\ $*
set spell
NoMatchParen

" vimtex
let g:tex_no_error                    = 1
let g:vimtex_complete_enabled         = 1
let g:vimtex_compiler_method          = 'latexmk'
let g:vimtex_fold_enabled             = 0
let g:vimtex_fold_manual              = 1
"let g:vimtex_view_method              = 'zathura'
let g:vimtex_motion_enabled           = 0
let g:vimtex_imaps_enabled            = 0
let g:vimtex_matchparen_enabled       = 0
let g:vimtex_quickfix_open_on_warning = 0

let g:vimtex_fold_sections = ['subsection', 'subsubsection']

let g:vimtex_compiler_latexmk = {
\                 'backend'    : 'jobs',
\                 'background' : 1,
\                 'build_dir'  : 'log',
\                 'callback'   : 1,
\                 'continuous' : 1,
\                 'executable' : 'latexmk',
\                 'options'    : [
\                        '-pdf',
\                        '-verbose',
\                        '-file-line-error',
\                        '-interaction=nonstopmode',
\                        ],
\                }
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
\                    're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
\                    're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
\                    're!\\hyperref\[[^]]*',
\                    're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
\                    're!\\(include(only)?|input){[^}]*',
\                    're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
\                    're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
\                    're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
\                    're!\\usepackage(\s*\[[^]]*\])?\s*\{[^}]*',
\                    're!\\documentclass(\s*\[[^]]*\])?\s*\{[^}]*',
\                    're!\\[A-Za-z]*',
\                    ]

let g:tex_fold_additional_envs = ['tikzpicture', 'titlepage']

" YCM
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_seed_identifiers_with_syntax = 0
