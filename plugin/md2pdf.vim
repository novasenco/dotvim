" Author: Nova Senco
" Last Change: 01 October 2020

augroup md2pd
    autocmd!
    autocmd BufWritePost *.md call md2pdf#convert()
augroup end

