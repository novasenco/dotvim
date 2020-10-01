" Author: Nova Senco
" Last Change: 01 October 2020

" In Line: entire line sans white-space
xnoremap <silent> il :<c-u>normal! g_v^<cr>
onoremap <silent> il :<c-u>normal! g_v^<cr>

" Around Line: entire line sans trailing newline
xnoremap <silent> al m`$o0
onoremap <silent> al :<c-u>normal! m`$v0<cr>

" In Document: from first line to last
xnoremap <silent> id :<c-u>normal! G$Vgg0<cr>
onoremap <silent> id :<c-u>normal! GVgg<cr>

" Around Fold: from first line in current fold to last
xnoremap az :<c-u>call textobjs#az(1)<cr>
onoremap az :<c-u>call textobjs#az(0)<cr>

" Go Other: align this corner to other corner
xnoremap <silent> go :<c-u>call textobjs#visualGoOther(0)<cr>

" Get Other: align other corner to this corner
xnoremap <silent> gO :<c-u>call textobjs#visualGoOther(1)<cr>

" Go Line: move this corner to other corner's line
xnoremap <silent> gl :<c-u>call textobjs#visualGoLine(0)<cr>

" Get Line: move other line to this corner's line
xnoremap <silent> gL :<c-u>call textobjs#visualGoLine(1)<cr>

" In Number: next number after cursor on current line
xnoremap <silent> in :<c-u>call textobjs#inNumber()<cr>
onoremap <silent> in :<c-u>call textobjs#inNumber()<cr>

" Around Number: next number on line and possible surrounding white-space
xnoremap <silent> an :<c-u>call textobjs#aroundNumber()<cr>
onoremap <silent> an :<c-u>call textobjs#aroundNumber()<cr>

" In Indentation: indentation level sans any surrounding empty lines
xnoremap <silent> ii :<c-u>call textobjs#inIndentation()<cr>
onoremap <silent> ii :<c-u>call textobjs#inIndentation()<cr>

" Around Indentation: indentation level and any surrounding empty lines
xnoremap <silent> ai :<c-u>call textobjs#aroundIndentation()<cr>
onoremap <silent> ai :<c-u>call textobjs#aroundIndentation()<cr>

