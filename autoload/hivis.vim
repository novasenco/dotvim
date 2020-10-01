" Author: Nova Senco
" Last Change: 01 October 2020

function! s:addmatch()
  let pat = substitute(getline('.'), '^\s*\S\+!\?\%(\s\+link\)\?\s\+\(\S\+\).*', '\1', '')
  let lnr = line('.')
  let cnr = strlen(substitute(getline('.'), '^\s*\S\+\%(\s\+link\)\?\s*\zs.*', '', '')) + 1
  let len = strlen(substitute(getline('.'), '^\s*\S\+\%(\s\+link\)\?\s\+\(\S\+\).*', '\1', ''))
  sil! call matchaddpos(pat, [[lnr, cnr, len]])
endfunction

function! hivis#hi()
  if !get(g:, 'no_auto_hivis', get(b:, 'no_auto_hivis'))
    keepj keepp g/^\s*hi\%[ghlight]!\?\s\+\%(clear\)\@!\%(\s\+link\)\?/call <sid>addmatch()
  endif
endfunction

