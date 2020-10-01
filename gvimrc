" Author: Nova Senco
" Last Change: 01 October 2020

if has('win32')
    " set guifont=Consolas:h13:cANSI:qDRAFT
    set guifont=DejaVu_Sans_Mono_for_Powerline:h10

    " this breaks :read! (F YOU WINDOWS I FING HATE YOU)
    " set shell=bash
    " set shellcmdflag=-c
else
    " set guifont=DejaVu\ sans\ Mono\ for\ Powerline\ 12
    " set guifont=Hack\ Nerd\ Font\ Mono\ 12
    set guifont=Hack\ 9
endif

let s:guiCruft = 0
set guioptions=icd!
function! s:toggleGuiCruft()
    if s:guiCruft
        set guioptions=icd!
        let s:guiCruft = 0
    else
        set guioptions=imTrL!
        let s:guiCruft = 1
    endif
endfunction
command! -nargs=0 -bar ToggleGuiCruft call <sid>toggleGuiCruft()

set guicursor+=a:block-Cursor-blinkwait0-blinkoff0-blinkon0

silent! vunmap <c-x> " :help v_CTRL-X

" vim: set fdm=marker fmr={{{,}}} fen tw=100 et sts=2 ts=2 sw=0:
