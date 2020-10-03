" Auhor: Nova Senco
" Last Change: 03 October 2020

" Random: {{{1

function! maps#Pastebin(type)
  if a:type is# 'char'
    let l:regsave = getreg('"')
    normal! `[v`]y
    let l:text = split(getreg('"', "\n"))
    call setreg('"', l:regsave)
  elseif a:type is# 'line'
    let l:text = getline(line("'["), "']")
  elseif a:type is# 'v' || a:type is# "\<c-v>"
    let l:regsave = getreg('"')
    normal! gvy
    let l:text = split(@", "\n")
    call setreg('"', l:regsave)
  elseif a:type is# 'V'
    let l:text = getline(line("'<"), "'>")
  else
    let l:text = getline(line("'["), "']")
  endif
  let l:tmp = tempname()
  call writefile(l:text, l:tmp)
  " ix.io
  call setreg('+', systemlist('sh -c ''curl -NsF "text=<'.l:tmp.'" vpaste.net?ft='.&ft.'\&bg=dark''')[0])
  echon "\rDone: @+ = ".@+
endfunction

function! maps#Netrw_gx()
  call search('https\?:', 'cW', line('.'))
  let cfile = expand('<cfile>')
  silent execute "!xdg-open '".substitute(cfile, "'", "'\\\\''", 'g')."'"
  redraw!
endfunction

function! maps#StarSearch(forward, bounds, mode)
  if a:mode is# 'v'
    let asav = getreg('a')
    norm! gv"ay
    let cword = getreg('a')
    call setreg('a', asav)
  else
    let cword = expand('<cword>')
  endif
  if cword =~ '^\s*$'
    return
  endif
  if a:bounds
    let word = '\C\<'.cword.'\>'
  else
    let word = '\C'.cword
  endif
  let @/ = word
  unsilent echon string((a:forward ? '/' : '?').@/)
  call histadd('/', word)
  call search(word, 'sc'.(a:forward ? 'e' : 'b'))
  call search(word, 's'.(a:forward ? '' : 'b'))
endfunction

function! maps#v_expr_print()
  let m = mode()
  let l = abs(line('v') - line('.')) + 1
  unsil echon m ': '
  echohl Number
  unsil echon l
  echohl NONE
  if m is "\<c-v>"
    echon 'x'
    echohl Number
    echon abs(virtcol('v') - virtcol('.')) + 1
    echohl NONE
  endif
  let wc = wordcount()
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_chars
  echohl NONE
  echon ' chars'
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_bytes
  echohl NONE
  echon ' bytes'
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_words
  echohl NONE
  echon ' words'
  return ''
endfunction

" Quick: {{{1

function! maps#MoveLine(down, count, visual)
  if a:visual
    let rng = "'<,'>"
    let bound = a:down ? "'>" : "'<"
  else
    let rng = ''
    let bound = ''
  endif
  let down = a:down ? '+' : '-'
  let cnt  = a:down ? v:count1 : v:count1 + 1
  exec printf("sil keepj %sm%s%s%d", rng, bound, down, cnt)
  call setpos('.', getpos("'["))
  let num = line("']") - line("'[") + 1
  unsil echo 'moved' num 'line'.(num-1?'s':'') (a:down?'down':'up') cnt
  sil! call repeat#set(":\<c-u>sil! undoj|call maps#MoveLine(".a:down.",".a:count.",".a:visual.")\<cr>")
  " if a:visual
  "     norm! gvo
  " endif
endfunction

function! maps#next_file(forwards)
  let file = &ft is 'netrw' ? b:netrw_curdir : expand('%:p')
  if empty(file)
    let file = '.'
  endif
  let files = filter(glob('%:p:h/*', 0, 1) + glob('%:p:h/.*', 0, 1), { _,f -> !isdirectory(f) && getftype(f) isnot 'link' })
  let lenfiles = len(files)
  if !len(files)
    echohl ErrorMsg
    echo 'No files in directory'
    echohl NONE
    return
  endif
  let ind = (index(files, file) + (a:forwards ? 1 : -1) + lenfiles) % lenfiles
  exe 'edit' fnameescape(files[ind])
endfunction

function! maps#next_change(forwards)
  if a:forwards
    norm! ]c
  else
    norm! [c
  endif
  let changeid = hlID('DiffChange')
  let diffhlid = diff_hlID('.', 1)
  if diffhlid != changeid
    " (a) no diff hl here, (b) DiffText hl id here (already right,
    " (c) DiffAdd here
    return
  endif
  let textid = hlID('DiffText')
  for col in range(1, col('$'))
    if diffhlid == textid
      let curpos = getcurpos()
      let curpos[2] = col
      let curpos[4] = col
      call setpos('.', curpos)
      break
    endif
    let col += 1
    let diffhlid = diff_hlID('.', col)
  endfor
endfunction

" Window Control: {{{1

" swap copied (or previous) window with current window
function! maps#WindowMove()
  let othr_wid = get(t:, '_w_wid_', win_getid(winnr('#')))
  let othr_bnr = winbufnr(win_id2win(othr_wid))
  let cur_wid = win_getid()
  let cur_bnr = bufnr()
  call win_gotoid(othr_wid)
  execute 'buffer'.cur_bnr
  call win_gotoid(cur_wid)
  execute 'buffer'.othr_bnr
endfunction

" open split of copied (or previous) window using
function! maps#WindowSplit(mods)
  let othr_wid = get(t:, '_w_wid', win_getid(winnr('#')))
  exe a:mods 'sb' winbufnr(win_id2win(othr_wid))
endfunction

" Plug Maps: {{{1

" run before Plug{Install,Clean,Update,Upgrade}
function! maps#PrePlugCmd()
  if expand('%:p') is# fnamemodify($MYVIMRC, ':p')
    silent update
  endif
  source $MYVIMRC
endfunction

" intelligently insert @+ on next line as a Plug statement and sort plugs;
" a:force indicates if @+ should be added even if it doesn't look like a valid
" plugin URL
function! maps#PlugAdd(force)
  let l:plug = @+
  if l:plug !~# '\v^%(\w|-)+\/%(\w|\.|-)+'
    let l:plug = substitute(substitute(@+, '\_s\+', '', ''),
    \ '^https\?:\/\/\%(github\|gitlab\)\.com\/', '', '')
  endif
  if l:plug !~# '\v^%(\w|-)+\/%(\w|\.|-)+' && !a:force
    echohl ErrorMsg
    echon 'Error in plugAdd: "'.l:plug.'" does not look like a valid plugin'
    echohl None
    return
  endif
  let l:s = 'Plug '''.l:plug.'''' " string
  let l:pl = '\m^\s*"\?\s*Plug' " plug line
  let l:ln = line('.') " line number
  let l:lines = [
  \   getline(max([1, l:ln - 1])),
  \   getline(l:ln),
  \   getline(min([line('$'), l:ln + 1]))
  \] " previous, current, and next lines
  let l:pb = 0 " paste before current line?
  if l:lines[1] =~# l:pl
    let l:wl = 1
    let l:pb = 1
  elseif l:lines[0] =~# l:pl
    let l:wl = 0
    let l:pb = 1
  elseif l:lines[2] =~# l:pl
    let l:wl = 2
  else
    let l:wl = 1
  endif
  let l:s = substitute(l:lines[l:wl], '\(^\s*\).*', '\1', '').l:s
  if l:pb
    put! =l:s
  else
    put =l:s
  endif
  call maps#PlugSort()
  echon "\r".'added "'.l:plug.'"'
endfunction

" sort plugs based on plugin name (including commented plugins)
function! maps#PlugSort()
  let l:nr = line('.')
  let l:vcol = virtcol('.')
  let l:start = search('\v\C^%(^\s*"?\s*Plug)@!.*\n\zs', 'bcWn')
  let l:end = search('\v\C.\ze\n%(^\s*"?\s*Plug)@!', 'cW')
  exec l:start.','.l:end.'sort /^\s*"\?\s*Plug\s\+''[^\/]\+\// i'
  exec 'normal! '.l:nr.'G'.l:vcol.'|'
  echon 'plugins sorted'
endfunction

" Insert: {{{1

function! maps#I_cr()
  let l:col = col('.')
  let l:pre = pumvisible() ? "\<c-y>" : ''
  if l:col !=# col('$')
    return l:pre."\<cr>"
  endif
  let l:mps = map(split(&matchpairs, ','), "split(v:val, ':')")
  let l:i = -1
  let l:bn = bufnr('.')
  for l:mp in split(get(g:, 'crIgnores', ''), ',')
    let l:i = index(l:mps, split(l:mp, ':'))
    if l:i + 1
      call remove(l:mps, l:i)
    endif
  endfor
  for l:mp in split(getbufvar(l:bn, 'crIgnores', ''), ',')
    let l:i = index(l:mps, split(l:mp, ':'))
    if l:i + 1
      call remove(l:mps, l:i)
    endif
  endfor
  let l:mps +=
  \   map(split(get(g:, 'crMatchpairs', ''), ','), "split(v:val, ':')") +
  \   map(split(getbufvar(l:bn, 'crMatchpairs', ''), ','), "split(v:val, ':')")
  let l:i = index(map(copy(l:mps), 'v:val[0]'), getline('.')[l:col - 2])
  if l:i + 1
    " make sure that you have !^F in |cinkeys|;
    " the <c-f> is to not break folding with my autocmd's that save/restore
    " |'fdm'| (set to 'manual' in insert mode to preserve folding)
    let l:extra = ''
    if ! &cindent
      setl cin
      let l:extra = "\<c-r>=execute('setl nocin')\<cr>"
    endif
    return l:pre."\<cr>\<cr>".l:mps[l:i][1]."\<up>\<c-f>".l:extra
  else
    return l:pre."\<cr>"
  endif
endfunction

function! maps#I_chain()
  if pumvisible()
    return "\<c-n>"
  endif
  if getline('.')[:max([0, col('.')-2])] =~ '[A-z.]$'
    let xtra = ''
  else
    let xtra = "\<c-p>"
  endif
  return "\<c-x>\<c-x>\<c-x>\<c-o>\<c-r>=pumvisible()?'':\"\\\<lt>c-x>\\\<lt>c-x>\\\<lt>c-x>\\\<lt>c-i>\"\<cr>\<c-r>=pumvisible()?'':\"\\\<lt>c-x>\\\<lt>c-x>\\\<lt>c-n>\"\<cr>".xtra
endfunction

