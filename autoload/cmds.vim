" Author: Nova Senco
" Last Change: 12 October 2020

" search through a list of buffer numbers/names with *grep*
function! cmds#FilelistGrep(search, lst)
    call setqflist([])
    for l:n in a:lst
        sil! exe printf('sil grepadd! "%s" %s', escape(a:search, '"'),
        \ fnameescape(fnamemodify(bufname(l:n), ':p')))
    endfor
    bot cwindow
    redraw!
endfunction

" :argdo without mucking syntax or changing buffers
function! cmds#ArgDo(args) abort
    let l:bufnr = bufnr('')
    execute 'argdo silent set eventignore-=Syntax | '.a:args
    execute 'silent buffer '.l:bufnr
endfunction

" :bufdo without mucking syntax or changing buffers
function! cmds#BufDo(args) abort
    let l:bufnr = bufnr('')
    execute 'bufdo silent set eventignore-=Syntax | '.a:args
    execute 'silent buffer '.l:bufnr
endfunction

" :windo without changing windows
function! cmds#WinDo(args) abort
    let l:winnr = winnr()
    execute 'windo silent set eventignore-=Syntax | '.a:args
    execute 'silent '.l:winnr.'wincmd w'
endfunction

if exists('*cmds#SourceListedVimfiles')
    " if using cmds#SourceListedVimfiles this will fail and the function will still be defined;
    " this delfunc is done so sourcing this file will succeed and reload this function
    sil! delfunc cmds#SourceListedVimfiles
endif
if !exists('*cmds#SourceListedVimfiles')
    " source all loaded plugins in $VIMDIR/plugin/
    function! cmds#SourceListedVimfiles()
        let svims = []
        let vimdir = '^'.escape(fnamemodify($VIMRC, ':p:h'), '~[]*^$.')
        for bufnr in range(1, bufnr('$'))
            let bufname = fnamemodify(bufname(bufnr),':p')
            if bufname !~# '.vim$' || isdirectory(bufname)
            \ || bufname =~# '\<_\?vimrc$' || bufname !~# vimdir
                continue
            endif
            exe 'so '.bufname
            call add(svims, fnamemodify(bufname, ':p:~'))
        endfor
        return svims
    endfunction
endif

" reload a vim file and attempt unlet the guard
function! cmds#SourceVimGuard()
    let l:guardName = ''
    let l:guardMatch = get(g:, 'guardMatch',
    \ '^\s*\%(else\)\?if\s\+exists\s*(\s*[''"]\%(g:\)\?\(\w\+\)[''"]\s*)\s*$')
    for l:line in getbufline(bufnr('%'), 1, get(g:, 'reload_max_lines', 10))
        if empty(l:guardName)
            if l:line !~# '\m'.l:guardMatch
                continue
            endif
            let l:guardName = substitute( l:line, l:guardMatch, '\1', '')
        elseif l:line =~# '\m^\s*finish\s*$'
            if ! empty(l:guardName)
                execute 'sil! unlet g:'.l:guardName
            endif
            execute 'source' fnameescape(expand('%:p'))
            return
        endif
    endfor
endfunction

" search through a list of buffer numbers/names with *vimgrep* (slow)
function! cmds#FilelistVimgrep(search)
    call setqflist([])
    for l:n in a:lst
        sil! exe printf('sil vimgrepadd! "%s" %s', escape(a:search, '"'),
        \ fnameescape(fnamemodify(bufname(l:n), ':p')))
    endfor
    bot cwindow
    redraw!
endfunction

function! cmds#Rename(fname) abort
    let l:cname = bufname()
    execute 'file '.a:fname
    silent call rename(l:cname, bufname())
endfunction

function! cmds#Put(cmd, line, pos, new, mods)
    redir => out
    exec 'sil ' . a:cmd
    redir end
    if a:new
        exe a:mods.(a:mods?' ':'')'new +setl\ bt=nofile'
    endif
    if a:line < line('.')
        let a:pos[1] += len(split(out, "\n")) + 2
    endif
    sil exe (a:new?'':a:line) . 'put =out'
    call setpos('.', a:new ? [0,1,1,0] : a:pos)
endfunction

