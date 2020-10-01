" Author: Dylan McClure
" Last Change: 01 October 2020

" see $VIMDIR/plugin/color.vim


" terminal colors
" ~~~~~~~~~~~~~~~

let s:ansicolors = {
\   'gruvbox': [
\       '#1d2021', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#d5c4a1',
\       '#665c54', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#fbf1c7'
\   ],
\   'gruvbox8': [
\       '#282828', '#CC241D', '#98971A', '#D79921', '#458588', '#B16286', '#689D6A', '#FBF1C7',
\       '#3c3836', '#FB4934', '#B8BB26', '#FABD2F', '#83A598', '#D3869B', '#8EC07C', '#928374'
\    ],
\   'gruvbox8_dark': [
\       '#1d2021', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#d5c4a1',
\       '#665c54', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#fbf1c7'
\   ],
\   'gruvbox8_soft': [
\       '#1d2021', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#d5c4a1',
\       '#665c54', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#fbf1c7'
\   ],
\   'paramount': [
\       '#000000', '#E32791', '#5FD7A7', '#ffff87', '#b6d6fd', '#a790d5', '#4FB8CC', '#f1f1f1',
\       '#262626', '#E32791', '#5FD7A7', '#ffff87', '#b6d6fd', '#a790d5', '#4FB8CC', '#ffffff'
\   ],
\   'igemnace': [
\       '#393939', '#f2777a', '#99cc99', '#ffcc66', '#6699cc', '#cc99cc', '#66cccc', '#d3d0c8',
\       '#393939', '#f2777a', '#99cc99', '#ffcc66', '#6699cc', '#cc99cc', '#66cccc', '#d3d0c8',
\   ],
\   'onedark': [
\       '#282c34', '#e06c75', '#98c379', '#e5c07b', '#61afef', '#c678dd', '#56b6c2', '#abb2bf',
\       '#3e4452', '#be5046', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2', '#5c6370'
\   ],
\   'novum': [
\       '#626262', '#ff5f5f', '#00af87', '#d7af5f', '#5fafd7', '#d787d7', '#00afaf', '#c6c6c6',
\       '#3a3a3a', '#ff875f', '#00875f', '#af8700', '#0087af', '#875f87', '#008787', '#9e9e9e'
\   ]
\}

" set ansicolors for :terminal window if g:colors found in key for s:ansicolors
function! color#setTermColors()
    if has_key(s:ansicolors, g:colors_name)
        call term_setansicolors(bufnr('%'), s:ansicolors[g:colors_name])
    endif
endfunction

