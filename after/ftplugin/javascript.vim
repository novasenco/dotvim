" Author: Nova Senco
" Last Change: 01 October 2020

nnoremap <buffer> <silent> <leader>IL
\ :s&$&\=' // eslint-disable-line '.split(v:statusmsg, ':')[0]&<bar>nohlsearch<cr>

syntax keyword jsCommentNote    contained NOTE
syntax region  jsComment        start=+//+ end=/$/ contains=jsCommentNote,@Spell extend keepend
syntax region  jsComment        start=+/\*+  end=+\*/+ contains=jsCommentNote,@Spell fold extend keepend
syntax region  jsEnvComment     start=/\%^#!/ end=/$/ display
hi def link jsCommentNote Todo

