
" after/plugin/fold.vim

let s:rnu = exists('+relativenumber')

function! FoldText()
    let l:lpadding = &fdc
    redir l:signs
    execute 'silent sign place buffer='.bufnr('%')
    redir end
    let l:lpadding += l:signs[0:2] ==# 'id=' ? 2 : 0

    if s:rnu && &relativenumber
        let l:nums = [&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]
        if &number
            call add(l:nums, strlen(line('$')) + 1)
        endif
        let l:lpadding += max(l:nums)
    elseif &number
        let l:lpadding += max([&numberwidth, strlen(line('$')) + 1])
    endif

    let l:sline = getline(v:foldstart)

    " " doc string
    " if l:sline =~# '^\s*\/\*\*\s*$'
    " 	let l:snline = getline(v:foldstart+1)
    " 	if l:snline =~# '^\s*\s*\*\s*'
    " 		let l:sline .= substitute(l:snline, '^\s*\*\s*', ' ', '')
    " 	endif
    " endif

    " expand tabs
    let l:start = substitute(l:sline, '^\s\{-}\zs\t', repeat(' ', &tabstop), 'g')

    let l:info = ' (' . (v:foldend - v:foldstart + 1) . ')'
    let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))

    let l:width = winwidth(0) - l:lpadding - l:infolen
    let l:text = strpart(l:start , 0, l:width)
    return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
endfunction

set foldtext=FoldText()
