" Author: Nova Senco
" Last Change: 01 October 2020

" if previous character is in &isk, then omni complete normally;
" else, omni complete and then <c-p> to simply show matches
inoremap <buffer> <expr> <c-x><c-o> getline('.')[col('.')-2] =~# '\k' ? '<c-x><c-o>' : '<c-x><c-o><c-p>'

