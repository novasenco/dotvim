" Author: Nova Senco
" Last Change: 01 October 2020

xnoremap <silent> <plug>(IterNext) "_c<c-r>iter#next()<cr>
xnoremap <silent> <plug>(IterPrev) "_c<c-r>iter#prev()<cr>

nnoremap <silent> <plug>(IterNext) :set opfunc=iter#opfuncNext<cr>g@
nnoremap <silent> <plug>(IterPrev) :set opfunc=iter#opfuncPrev<cr>g@

inoremap <silent> <expr> <plug>(IterNext) iter#next()
inoremap <silent> <expr> <plug>(IterPrev) iter#prev()

nnoremap <silent> <plug>(IterReset) :<c-u>call iter#reset()<cr>

command! -nargs=? -bar IterSet :call iter#set(<f-args>)

