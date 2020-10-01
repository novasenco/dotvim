" Author: Nova Senco
" Last Change: 01 October 2020

" let s:default_pdf_viewer = 'sh -c "'.$HOME.'/scripts/newzathura %s"'
let s:default_pdf_viewer = 'zathura --fork %s'

let s:recompile = 0

function! md2pdf#set_write(bang, on)
    let l:bn = bufnr(winnr())
    let l:flag = 'md2pdf_convert'
    if a:bang ==# '!'
        call setbufvar(l:bn, l:flag, ! getbufvar(l:bn, l:flag, 0))
    else
        call setbufvar(l:bn, l:flag, a:on)
    endif
    if getbufvar(l:bn, l:flag, 0)
        echohl String
        echon "\rmd2pdf ENABLED"
    else
        echohl WarningMsg
        echon "\rmd2pdf DISABLED"
    endif
    echohl NONE
endfunction

function! md2pdf#convert()
    if ! getbufvar(bufnr(winnr()), 'md2pdf_convert')
        return
    endif
    if exists('s:convert_job')
        let s:recompile = 1
        return
    endif
    let l:path = expand('%:p:h')
    let l:in = fnameescape(l:path.'/'.expand('%:t'))
    let l:out = fnameescape(l:path.'/'.expand('%:t:r').'.pdf')

    " \     'pandoc -f gfm -t html -o '.l:out.' --template=GitHub.html5 '.l:in.' </dev/null >/dev/null'
    let s:convert_job = job_start(
    \   ['sh', '-c',
    \       'pandoc -o '.l:out.(expand('%:t') =~# 'README.md$' ? ' -f gfm -t html --template=GitHub.html5 ' : ' --template=eisvogel.latex ').l:in.' </dev/null'
    \   ],
    \   {'exit_cb': 'md2pdf#convert_post'}
    \)
endfunction

function! md2pdf#convert_post(job, exit)
    if a:exit !=# 0
        echohl ErrorMsg
        echon "\rpandoc failed to convert this file"
    else
        echohl String
        echon "\rpandoc successfully converted"
    endif
    unlet s:convert_job
    if s:recompile
        echon ' ... recompiling '.s:recompile.' more time'.(s:recompile ==# 1 ? '' : 's')
        let s:recompile = 0
        call md2pdf#convert()
    else
        echon repeat(' ', 34)
    endif
    echohl NONE
endfunction

function! md2pdf#open_pdf()
    let l:out_pdf = expand('%:p:h').'/'.expand('%:p:t:r').'.pdf'
    if ! filereadable(l:out_pdf)
        echohl ErrorMsg
        echon "\rFile not readable: ".l:out_pdf
        echohl NONE
        return
    endif
    let l:cmd = substitute(get(g:, 'pdf_viewer', s:default_pdf_viewer), '%s', escape(fnameescape(l:out_pdf), '\'), 'g')
    echohl String
    echom '!'.l:cmd
    echohl NONE
    call system(l:cmd)
endfunction

function! md2pdf#temp_write()
    let l:bn = bufnr(winnr())
    let l:flag = 'md2pdf_convert'
    let l:b_md2pdf_convert = getbufvar(l:bn, l:flag, 0)
    call setbufvar(l:bn, l:flag, 1)
    call md2pdf#convert()
    call setbufvar(l:bn, l:flag, l:b_md2pdf_convert)
endfunction

