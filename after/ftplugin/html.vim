" Author: Nova Senco
" Last Change: 01 October 2020

if &ft is 'markdown'
    " wtf https://github.com/vim/vim/issues/6354
    finish
endif

inoremap <silent> <buffer> <c-x>c <lt>/<c-x><c-o><c-y>
inoremap <silent> <buffer> <c-x>o <cr><cr><lt>/<c-x><c-o><c-y><c-f><up><c-f><c-t>

