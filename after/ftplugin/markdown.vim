" Author: Nova Senco
" Last Change: 01 October 2020

setlocal expandtab softtabstop=4 tabstop=4
setlocal fo-=c

" md2pdf
command! -buffer -bar -bang -nargs=0 PdfOpenOnWrite call md2pdf#set_write(<q-bang>, 1)
command! -buffer -bar -nargs=0 NoPdfOpenOnWrite call md2pdf#set_write('', 0)
command! -buffer -nargs=0 OpenPdf call md2pdf#open_pdf()
command! -buffer -bar -nargs=0 TmpPdfWrite call md2pdf#temp_write()

" K jumps to header -> like (foo)[#myheaderiii] for ### My Header III
nnoremap <buffer> <silent> K :call <sid>markdownGotoHeader()<cr>
function! s:markdownGotoHeader()
    let pos = getpos('.')
    call search('(', 'bcW', line('.'))
    if !search('#', 'cW', line('.'))
        echohl ErrorMsg
        echo 'No link found on rest of line'
        echohl NONE
        call setpos('.', pos)
        return
    endif
    let asav = @a
    normal! "ayib
    let targ = @a
    let @a = asav
    let targ = substitute(targ, '^#\+', '', '')
    let targ = substitute(targ, '^\s\+\|\s\+$', '', 'g')
    if empty(targ)
        echohl ErrorMsg
        echo 'target is empty'
        echohl NONE
        call setpos('.', pos)
        return
    endif
    let targ = split(targ)[0]
    let targ = '\[[:punct:][:space:]]\*'.join(map(split(targ, '-'), { _,str -> join(map(split(str, '\zs'), { _,chr -> chr == '\' ? '\\' : chr }), '\[[:punct:]]\*') }), '\[[:punct:][:space:]]\+').'\[[:punct:][:space:]]\*'
    let pat = '\V\c\^\%(\s\*'.targ.'\n\[-=]\|#\+\s\*'.targ.'\)'
    let lnr = search(pat, 'cnw')
    if lnr == 0
        echohl ErrorMsg
        echo 'target /'.targ.'/ not found'
        echohl NONE
        call setpos('.', pos)
        return
    endif
    call setpos("''", pos)
    call setpos('.', [0, lnr, 1, 1])
endfunction

