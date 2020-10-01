" Author: Nova Senco
" Last Change: 01 October 2020

function! s:fixtitle()
    let title = getwinvar('', 'quickfix_title', '')[1:]
    let title = substitute(title, '^:rg\zs --vimgrep --no-heading', '', '')
    let title = substitute(title, '^\s*\([''"]\)\(.*\)\1\s*$', '\2', '')
    call setwinvar('', 'quickfix_title', title)
endfunction

call s:fixtitle()
setl statusline=%{getwinvar('','quickfix_title','')}%=%y
augroup QfVimconfig
    autocmd!
    autocmd QuickFixCmdPost * call s:fixtitle()
augroup end

setlocal colorcolumn=
setlocal nobuflisted
setlocal conceallevel=2 concealcursor=nvic
syntax match QfConceal /^|\+\s*/ conceal

