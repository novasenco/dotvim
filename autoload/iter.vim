" Author: Nova Senco
" Last Change: 01 October 2020

let s:count = 0

function! iter#next()
    let c = s:count
    let s:count += 1
    return c
endfunction

function! iter#prev()
    let c = s:count
    let s:count -= 1
    return c
endfunction

function! iter#reset()
    let c = 0
    let s:count = 0
    echon 'Iterator set to '.s:count
    return c
endfunction

function! iter#set(...)
    let c = s:count
    if a:0
        let l:n = a:1
    else
        let l:n = 0
    endif
    if l:n =~ '\d'
        let s:count = printf('%d', l:n)
    endif
    echon 'Iterator set to '.s:count
    return c
endfunction

function! iter#opfuncNext(type)
    silent execute 'normal! `[v`]"_c'.iter#next()
endfunction

function! iter#opfuncPrev(type)
    silent execute 'normal! `[v`]"_c'.iter#prev()
endfunction

