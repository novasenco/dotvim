" Author: Nova Senco
" Last Change: 16 October 2020

function! autocmd#HandleSwap(filename)
    let pid = string(swapinfo(v:swapname).pid)
    let ppid = '(pid: '.pid.')'
    let fname = '"'.fnameescape(expand('%')).'"'
    echohl WarningMsg
    redraw
    if getftime(v:swapname) < getftime(a:filename)
        " delete swap file if older than file itself; then edit
        let v:swapchoice = 'e'
        unsil echom 'Old swap deleted:' fname ppid
        call delete(v:swapname)
    else
        let haspgrep = executable('pgrep')
        if haspgrep && index(systemlist('pgrep -x vim'), pid) >= 0
            " file open in another vim; edit
            let v:swapchoice = 'e'
            unsil echom 'Already editing' fname ppid
        else
            let v:swapchoice = 'o'
            " open read-only:
            "   if haspgrep, almost definitely a crash
            "   else, either crash or file open but can't discover (with pgrep)
            let out = haspgrep ? 'Crash' : 'Swapfile'
            let note = '-> use :DiffOrig and :recover if needed'
            unsil echom  out 'detected' ppid 'for' fname note
        endif
    endif
    echohl NONE
endfunction

function! autocmd#UpdateDate(...) " optionals: (prefix, timefmt, timeregex)
    let prefix = a:0 ? a:1 : 'Last Change:'
    let timefmt = a:0 > 1 ? a:2 : '%d %B %Y'
    let timeregex = a:0 > 2 ? a:3 : '\d\{2} \u\l\+ \d\{4}'
    let time = strftime(timefmt)
    let curpos = getcurpos()
    if search(printf('%s\s*\%%(%s\)\?', prefix, timeregex))
      if !search(printf('%s\s*%s', prefix, escape(time, '\~^$[]*+')), 'nc', line('.'))
        exe printf('keepj keepp s/%s\zs\s*\%%(%s\)\?/ %s/e', prefix, timeregex, time)
      endif
    endif
    call setpos('.', curpos)
endfunction

