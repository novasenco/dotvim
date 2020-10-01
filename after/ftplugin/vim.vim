" Author: Nova Senco
" Last Change: 01 October 2020

setl fdm=marker fmr={{{,}}} fen tw=100 et sts=2 ts=2 sw=0

let b:match_words = join([
\ '\<fu\%[nction]\>:\<retu\%[rn]\>:\<endf\%[unction]\>',
\ '\<\(wh\%[ile]\|for\)\>:\<brea\%[k]\>:\<con\%[tinue]\>:\<end\(w\%[hile]\|fo\%[r]\)\>',
\ '\<if\>:\<el\%[seif]\>:\<en\%[dif]\>',
\ '\<try\>:\<cat\%[ch]\>:\<fina\%[lly]\>:\<endt\%[ry]\>',
\ '\<aug\%[roup]\ze\s\+\%(end\|END\>\)\@!\S:\<aug\%[roup]\s\+\%(end\|END\)\>\ze',
\ '\<call\s\+plug#begin\ze([^)]*):\<call\s\+plug#end\ze(\s*)',
\], ',')

