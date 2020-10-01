" Author: Nova Senco
" Last Change: 01 October 2020

" SETUP:           {{{1

let $VIMDIR = fnamemodify($MYVIMRC, ':p:h') " cache vim config (use ~/.vim/vimrc NOT ~/.vimrc)

sil! set encoding=utf-8   " set vim encoding    (keep first!  order matters!)
sil! scriptencoding utf-8 " set script encoding (keep second! order matters!)

if !v:vim_did_enter
  syntax enable " enable syntax hl (super slow!); if-guard makes re-:source-ing fast!
endif

filetype plugin indent on " enable filetype plugins and indent magic

if has('clientserver') && empty(v:servername)
  call remote_startserver('VIM') " allow clientserver communication
endif

" set up Meta to work properly for most keys in terminal vim
" NOTE: use "map <m-\|>" or "map <m-bar>" to map <bar> (|)
if !has('nvim') && !has('gui_running')
  " but only in terminal vim
  " PROBLEM: not possible to map Meta with Arrow Keys
  " PROBLEMS: 32 (space), 62 (>), 91 ([), 93 (])
  for ord in range(33,61)+range(63,90)+[92]+range(94,126)
    let char = ord is 34 ? '\"' : ord is 124 ? '\|' : nr2char(ord)
    exec printf("set <m-%s>=\<esc>%s", char, char)
    if exists(':tnoremap') " fix terminal control sequences
      exec printf("tnoremap <silent> <m-%s> <esc>%s", char, char)
    endif
  endfor
  " NOTE: if below don't work, compare with ctrl-v + CTRL-{LEFT,RIGHT} in INSERT mode
  " PROBLEM: <c-up>,<c-down> do not work in any terminal
  " set up <c-left> and <c-right> properly
  exe "set <c-right>=\<esc>[1;5C"
  exe "set <c-left>=\<esc>[1;5D"
endif

" OPTIONS:         {{{1

if !v:vim_did_enter || get(g:, 'reload_vimrc_options')

  set   autoread                   " auto read files changed externally if buffer unmodified
  set   backspace=start,eol,indent " backspace unconditionally works in insert mode
  set   cpoptions+=y               " yanks repeatable with dot operator
  set   expandtab ts=2 sts=2 sw=0  " 2 spaces
  set   formatoptions+=j           " auto remove comment when joining lines
  set   hidden                     " edit another buffer with unsaved changes
  set   ignorecase smartcase       " ignore case for complete/search unless there's an uppercase
  set nojoinspaces                 " don't insert two spaces after punctuation when joining lines
  set   lazyredraw                 " don't redraw for macros, registers, & other non-typed cmds
  set   listchars+=nbsp:~          " night vision backup: non-breaking space is ~
  set   listchars+=tab:>-          " night vision backup: tabs are like >---
  set   listchars=trail:~          " night vision backup: trailing space is ~
  set   mouse=                     " prevent annoying mouse behavior
  set   scrolloff=0                " don't scroll window when cursor near top or bottom
  set   shiftround                 " >> & << shift to round multiple of 'shiftwidth'
  set noshowmode                   " don't show --INSERT-- etc
  set   splitbelow splitright      " hsplit opens below; vsplit opens on right
  set nostartofline                " don't change cursor column when jumping or switching buffers
  set   switchbuf=uselast          " quickfix jump to last used buffer
  set notimeout                    " don't timeout for mappings
  set   ttimeout                   " timeout for key sequences
  set   ttimeoutlen=5              " wait only 5 milliseconds for key sequences
  set   virtualedit=block,insert   " let cursor to move past end-of-line in visual-block & insert
  set   wildcharm=<f20>            " use <tab> in a mapping with <f20>
  set   winminheight=0             " windows may have 0 height
  set   winminwidth=0              " windows may have 0 width

  " better night vision
  sil! set listchars+=trail:· " trailing space is ·
  sil! set listchars+=tab:›·  " tabs are like ›···
  sil! set listchars+=nbsp:○  " non-breaking space is ○

  " backup written files to $VIMDIR/backup/
  call mkdir($VIMDIR.'/backup', 'p')
  set backupdir=$VIMDIR/backup//
  set backup backupext=.bak

  " save swap files to $VIMDIR/swap
  call mkdir($VIMDIR.'/swap', 'p')
  set directory=$VIMDIR/swap//
  set swapfile

  " persistent undo saved in $VIMDIR/undo/
  if has('persistent_undo')
    call mkdir($VIMDIR.'/undo', 'p')
    set undodir=$VIMDIR/undo//
    set undofile
  endif

  set belloff=all  " do not ring bell for any vim event
  set noerrorbells " do not ring bell for any error message
  set visualbell   " do not beep; ring bell, but we disabled all bells >:)
  set t_vb=        " make visual bell produce no control bytes

  set shortmess=aoO     " abbreviate; write overwrites read msg; read overwrites any msg (quiet :cn)
  set shortmess+=sT     " don't show 'search hit BOTTOM/TOP'; truncate long msgs in middle; no intro
  sil! set shortmess+=c " no ins-completion-menu messages
  sil! set shortmess+=F " don't show file info when editing file
  sil! set shortmess+=S " don't show weird '[1/5]' thing during search or n/N

  if has('syntax')
    set synmaxcol=256  " reduce max syntax searching from 3000
    set colorcolumn=+0 " show color column at 'textwidth'
  endif

  if has('cmdline_hist')
    set history=2000 " increase history from 50
  endif

  if has('gui_running') || has('xterm_clipboard')
    set   clipboard-=autoselect " do not auto save visual selection to @*
  endif

  if has('gui_running')
    set guioptions=dg " use dark theme and gray out unused icons in gvim
  endif

  if has('cmdline_info')
    set noshowcmd " don't show count or visual selection info
    set noruler   " don't show annoying ruler if laststatus=0
  endif

  if has('conceal')
    set concealcursor=ni " hide concealed text in normal, insert modes
    set conceallevel=2   " conceal text fully but show cchar if defined
  endif

  if has('viminfo')
    " hide viminfo in $VIMDIR instead of in $HOME
    exe printf('set viminfofile=%s/viminfo', $VIMDIR)
    exe printf('set viminfo+=n%s/viminfo', $VIMDIR)
  endif

  " on windows, use forward slash for path separator
  if (has('win32') || has('win64')) && has('shellslash')
    set shellslash
  endif

  " set default fold method to marker
  if has('folding')
    set foldmethod=marker
  endif

  if has('wildmenu')
    set wildmenu " command-line <tab> => menu
  endif

  if has('statusline')
    set laststatus=2                         " I don't normally show the statusline
    set statusline=%.30f%<%(\ [%M%R%W]%)%=%y " but when I do, I prefer dos equis
  endif

  " ripgrep
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  endif

  if has('diff')
    set diffopt=vertical                  " start diff in vertical split
    set diffopt+=filler                   " filler lines for sync'd window
    set diffopt+=foldcolumn:0             " hide foldcolumn in diffs
    sil! set diffopt+=algorithm:histogram " use histogram algo for diff
  endif

  if has('linebreak')
    set breakindent           " wrapped lines indented to same level
    set showbreak=↪           " with ↪ as continuation string
    set breakindentopt=min:80 " but only >80 virtual columns
  endif

  if has('extra_search')
    set hlsearch  " searches highlighted afterwards
    set incsearch " searches highlighted incrementally as typed
  endif

  set completeopt=menu,menuone " always show menu even for only one match
  if has('textprop')
    set completeopt+=popup " use popup window instead of preview window
  else
    set completeopt+=preview " use preview window if no popup available
  endif

  let reload_vimrc_options = 0

endif

" MAPS:            {{{1

" Random: {{{2

abbrev unkown unknown

" leader config
nmap <space> <nop>
nmap <space><esc> <nop>
let mapleader = ' '
let maplocalleader = '\'

" write
noremap <silent> <m-w> :sil w<cr>
inoremap <silent> <m-w> <esc>:sil w<cr>gi

" write without triggering autocmds
noremap <silent> <m-W> :sil noau up<cr>
inoremap <silent> <m-W> <c-bslash><c-o>:sil noau up<cr>

" quit vim if no unwritten buffers
nnoremap <localleader>q :qa<cr>

" <c-p> opens last command
nnoremap <c-p> :<c-p>

" quickly edit vimrc
nnoremap <silent> <localleader>v :edit $MYVIMRC<cr>

" sourcing
nnoremap <silent> <localleader>V :SourceVimAll<cr>
nnoremap <silent> <localleader>S :SourceCurrent<cr>
nnoremap <silent> <localleader>R :SourceGuarded<cr>


" move lines to end or beg of paragraph (resp)
noremap <silent> m} :<c-b>keepp <c-e>m/\n\n<cr>
noremap <silent> m{ :<c-b>keepp <c-e>m?\n\zs\n<cr>

" same as zO but if fold already open, close first
nnoremap <expr> zO foldclosed('.') is -1 ? 'zczO' : 'zO'

" expand braces at end of line
inoremap <expr> <cr> maps#I_cr()

" weird chaining completion that I never use
inoremap <expr> <silent> <c-b> maps#I_chain()

" <c-l> same but extra functionality (:nohls, :diffup)
nnoremap <silent> <c-l> :nohlsearch<bar>diffupdate<cr><c-l>
nnoremap <silent> <leader><c-l> :syntax sync fromstart<cr>

" netrw sucks
nnoremap gx :call maps#Netrw_gx()<cr>

" toggle (add or remove) ";" at end of line
nnoremap <silent> <expr> <leader>; (getline('.') =~# ';\s*$'?'g_x':'g_a;<esc>').virtcol('.').'<bar>'

" move current line 1/4 of the way down the screen (like zz but 1/4 so z4)
nnoremap <expr> z4 'zz'.(&lines / 4).'<c-e>'

" search for anything inside of a comment
nnoremap <expr> <leader>/c '/\('.split(escape(&commentstring, '/$.*~'), '%s')[0].'\s*\)\@<='
" search for anything not inside of a comment
nnoremap <expr> <leader>/C '/\('.split(escape(&commentstring, '/$.*~'), '%s')[0].'\s*\)\@<!'

" Meta + M/L = :Make / :Lmake
nnoremap <silent> <m-M> :sil Make<cr>
nnoremap <silent> <m-L> :sil Lmake<cr>

" view syntax hl groups under cursor
nmap <leader>p <plug>(SynStack)

" F1 Sucks
noremap <f1> <nop>
noremap <c-f1> <nop>

if exists(':tnoremap') is 2
  if exists('*term_sendkeys')
    " send <c-w> to terminal with <c-w><c-w>
    " note: <c-w>w still cycles
    tnoremap <silent> <c-w><c-w> <c-w>:call term_sendkeys(bufnr('%'), "<bslash><lt>c-w>")<cr>
  endif
  " use <c-w>^ if you want to split previous buffer
  tnoremap <c-w><c-^> <c-w>:b#<cr>
endif
" use <c-w>^ if you want to split previous buffer
nnoremap <c-w><c-^> <c-^>

" paste bin opreator
nnoremap <silent> <leader>B :set opfunc=maps#Pastebin<cr>g@
nmap <silent> <leader>BB V<space>B
xnoremap <silent> <leader>B :<c-u>call maps#Pastebin(visualmode())<cr>

" iter
nmap <leader>i <plug>(IterNext)
nmap <leader>I <plug>(IterPrev)
xmap <leader>i <plug>(IterNext)
xmap <leader>I <plug>(IterPrev)
nmap <localleader>i <plug>(IterReset)
imap <c-r>[ <plug>(IterPrev)
imap <c-r>] <plug>(IterNext)

" Spell: {{{2

" Note: CTRL-S may conflict with "flow control" in some terminals

" quickly fix previous spelling error in insert mode
inoremap <c-s> <esc>[s1z=gi

" spell fixing (repeatable)
nnoremap <silent> <c-s>h [s1z=``:sil! call repeat#set("\<c-s>h")<cr>
nnoremap <silent> <c-s>l ]s1z=``:sil! call repeat#set("\<c-s>l")<cr>

" spell gooding (repeatable)
nnoremap <silent> <c-s>gh [Szg``:sil! call repeat#set("\<c-s>gh")<cr>
nnoremap <silent> <c-s>gl ]Szg``:sil! call repeat#set("\<c-s>gl")<cr>
nnoremap <silent> <c-s>Gh [SzG``:sil! call repeat#set("\<c-s>Gh")<cr>
nnoremap <silent> <c-s>Gl ]SzG``:sil! call repeat#set("\<c-s>Gl")<cr>

" Cli Navigation: {{{2

" Ctrl + Left/Right = Shift + Left/Right
cnoremap <c-left> <s-left>
lnoremap <c-right> <s-right>

" Meta + b/f = Shift + Left/Right
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>

" Meta + hjkl = Arrows
cnoremap <m-h> <left>
cnoremap <m-l> <right>
cnoremap <m-k> <up>
cnoremap <m-j> <down>

" Meta + a/e = <c-b> <c-e>
cnoremap <m-a> <c-b>
cnoremap <m-e> <c-e>

" c_CTRL-Y (eg in /search/) shows cursor if folded
cnoremap <c-y> <c-r>=[''][execute('normal! zv')]<cr>

" Quick: {{{2

" buffers
nnoremap <silent> [b :<c-u>execute v:count.'bprevious'<cr>
nnoremap <silent> [B :bfirst<cr>
nnoremap <silent> ]b :<c-u>execute v:count.'bnext'<cr>
nnoremap <silent> ]B :blast<cr>

" arguments
nnoremap <silent> [a :<c-u>execute v:count.'previous'<cr>
nnoremap <silent> [A :first<cr>
nnoremap <silent> ]a :<c-u>execute v:count.'next'<cr>
nnoremap <silent> ]A :last<cr>

" local list
nnoremap <silent> <leader>ll :lopen<cr>
nnoremap <silent> <leader>lc :lclose<cr>
nnoremap <silent> [w :<c-u>execute v:count.'lprevious'<cr>
nnoremap <silent> [W :lfirst<cr>
nnoremap <silent> ]w :<c-u>execute v:count.'lnext'<cr>
nnoremap <silent> ]W :llast<cr>

" quickfix
nnoremap <silent> <leader>qq :copen<cr>
nnoremap <silent> <leader>qc :cclose<cr>
nnoremap <silent> [q :<c-u>execute v:count.'cprevious'<cr>
nnoremap <silent> [Q :cfirst<cr>
nnoremap <silent> ]q :<c-u>execute v:count.'cnext'<cr>
nnoremap <silent> ]Q :clast<cr>

" moving lines
nnoremap <silent> [e :<c-u>call maps#MoveLine(0, v:count, 0)<cr>
xnoremap <silent> [e :<c-u>call maps#MoveLine(0, v:count, 1)<cr>
nnoremap <silent> ]e :<c-u>call maps#MoveLine(1, v:count, 0)<cr>
xnoremap <silent> ]e :<c-u>call maps#MoveLine(1, v:count, 1)<cr>

" git marker quick jumping
nnoremap <silent> [g :call search('^\%(<<<<<<<\\|=======\\|>>>>>>>\)', 'wb')<cr>
nnoremap <silent> ]g :call search('^\%(<<<<<<<\\|=======\\|>>>>>>>\)', 'w')<cr>

" file jumping
nnoremap <silent> ]f :call maps#next_file(1)<cr>
nnoremap <silent> [f :call maps#next_file(0)<cr>

" improved ]c & [c (go to DiffText if in DiffChange)
nnoremap <silent> ]c :call maps#next_change(1)<cr>
nnoremap <silent> [c :call maps#next_change(0)<cr>

" Window Moving: {{{2

" Window Yank
nnoremap <silent> <c-w>y :let t:_w_wid_ = win_getid()<cr>

" Window Move
nnoremap <silent> <c-w>m :call maps#WindowMove()<cr>

" Window Split hjkl
nnoremap <silent> <c-w><leader>h :call maps#WindowSplit('leftabove vertical')<cr>
nnoremap <silent> <c-w><leader>j :call maps#WindowSplit('rightbelow')<cr>
nnoremap <silent> <c-w><leader>k :call maps#WindowSplit('leftabove')<cr>
nnoremap <silent> <c-w><leader>l :call maps#WindowSplit('rightbelow vertical')<cr>

" Plug: {{{2

" move to plug#begin
nnoremap <silent> <leader>PP :e $MYVIMRC\|1\|call search('call plug'.'#begin')<cr>zXzO4+zt5<c-y>

" plug install
nnoremap <leader>PI :call maps#PrePlugCmd()<bar>PlugInstall --sync<bar>SourceVimrc<cr>

" plug clean
nnoremap <leader>PC :call maps#PrePlugCmd()<bar>PlugClean<cr>

" plug update
nnoremap <leader>PU :call maps#PrePlugCmd()<bar>PlugUpdate<cr>

" plug upgrade
nnoremap <leader>PG :call maps#PrePlugCmd()<bar>PlugUpgrade<cr>

" parse URL in @+ and sort plugins
nnoremap <silent> <leader>PA :call maps#PlugAdd(0)<cr>

" force add @+ whether and sort plugins
nnoremap <silent> <leader>PF :call maps#PlugAdd(1)<cr>

" sort surround plugins based on plugin name
nnoremap <silent> <leader>PS :call maps#PlugSort()<cr>

" Search: {{{2

" better * # g* g#
nnoremap <silent> *  :let v:hlsearch = setreg('/', '\C\<lt>'.expand('<cword>').'\>') + 1<cr>
nnoremap <silent> #  :let v:hlsearch = setreg('/', '\C\<lt>'.expand('<cword>').'\>') + 1<bar>call search('', 'bc')<cr>
nnoremap <silent> g* :let v:hlsearch = setreg('/', '\C'.expand('<cword>')) + 1<cr>
nnoremap <silent> g# :let v:hlsearch = setreg('/', '\C'.expand('<cword>')) + 1<bar>call search('', 'bc')<cr>

" use above */# in visual mode
xmap * <esc>*gv
xmap # <esc>#gv
xmap g* <esc>g*gv
xmap g# <esc>g#gv

" use above */# in operator-pending mode
omap * *n
omap # #N
omap g* g*n
omap g# g#N

" search for visual selection
function! s:visSearch()
  let savs = [@0, @"]
  norm! gvy
  call setreg('/', '\V'.escape(@", '\'))
  let [@0, @"] = savs
endfunction
xnoremap <leader>* :<c-u>let v:hlsearch = <sid>visSearch() + 1<cr>gv
xnoremap <leader># :<c-u>let v:hlsearch = <sid>visSearch() + 1<cr>gvo

" n and N always search for matched pattern forwards and backwards (resp.)
nnoremap <expr> n (v:searchforward ? 'n' : 'N').'zv'
nnoremap <expr> N (v:searchforward ? 'N' : 'n').'zv'

" visual mode already opens folds properly, and the above RHS would break
xnoremap <expr> n v:searchforward ? 'nzv' : 'Nzv'
xnoremap <expr> N v:searchforward ? 'Nzv' : 'nzv'

onoremap <expr> n v:searchforward ? 'n' : 'N'
onoremap <expr> N v:searchforward ? 'N' : 'n'

" }}}

" COMMANDS:        {{{1

" search all args with :grep
command! -nargs=+ -bar ArgGrep call cmds#FilelistGrep(<q-args>, argv())

" search all listed buffers with :grep
command! -nargs=+ -bar  BufGrep call cmds#FilelistGrep(<q-args>,
 \ filter(range(1, bufnr('$')), { _,n -> buflisted(n) }))

" search all args with :vimgrep (don't use on big files)
command! -nargs=+ -bar ArgVimgrep call cmds#FilelistVimgrep(<q-args>, argv())

" search all args with :vimgrep (don't use on big files)
command! -nargs=+ -bar BufVimgrep call cmds#FilelistVimgrep(<q-args>,
 \ filter(range(1, bufnr('$')), { _,n -> buflisted(n) }))

" bottom terminal
command! -nargs=? -bar BTerm execute 'terminal'
 \ <bar>execute printf('%dwincmd _', <q-args> =~ '^\d\+$' ? <q-args> : '15')<bar>setl winfixheight

" still synchronous but quieter make
command! -bar -nargs=? Make if <q-args> !~ '^\s*$'|let g:make_args = <q-args>|endif|
 \ execute 'silent make' get(g:, 'make_args', '')|redraw!|echo ':Make' get(g:, 'make_args', '')

command! -bar -nargs=? Lmake if <q-args> !~ '^\s*$'|let g:lmake_args = <q-args>|endif|
\ execute 'silent lmake' get(g:, 'lmake_args', '')|redraw!|echo ':Lmake' get(g:, 'lmake_args', '')

" rename
command! -complete=file -nargs=1 -bar Rename call cmds#Rename(<q-args>)

" :help :DiffOrig
command! DiffOrig vert new|set buftype=nofile|read ++edit #|0d_|diffthis|wincmd p|diffthis

" remove trailing whitespace
command! -nargs=0 -range=% -bar RmTrailWS let _rsav_=@/|sil! <line1>,<line2>s/\s\+$//
 \ |let @/=_rsav_|unlet _rsav_|normal! ``

command! -bar -nargs=0 PreviewTags execute &previewheight.'new'
 \ |setlocal buftype=nofile|put=getcompletion('', 'tag')|1delete

" paste Bin
command! -range=% -nargs=0 Bin
 \ exe '<line1>,<line2>w !curl -NsF ''text=<-'' vpaste.net\?ft='
 \ . &ft . '|tr -d ''\n''|xsel -bi'

" clear quickfix
command! -nargs=0 Cclear call setqflist([], 'r')

" put a command (eg :Put version)
command! -range -nargs=+ -complete=command Put call cmds#Put(<q-args>, <line1>, getcurpos(), 0, '')
command! -range -nargs=+ -complete=command SPut call cmds#Put(<q-args>, <line1>, getcurpos(), 1, <q-mods>)

command! -bang -bar -nargs=? Q q<bang> <args>
command! -bang -bar -nargs=? QA qa<bang> <args>
command! -bang -bar -nargs=? Qa qa<bang> <args>
command! -bang -bar -nargs=? WQ wq<bang> <args>
command! -bang -bar -nargs=? Wq wq<bang> <args>
command! -bang -bar -nargs=? WQA wqa<bang> <args>
command! -bang -bar -nargs=? WQa wqa<bang> <args>
command! -bang -bar -nargs=? Wqa wqa<bang> <args>

" :{arg,buf,win}do without mucking syntax or changing buffers
command! -nargs=+ ArgDo call cmds#ArgDo(<q-args>)
command! -nargs=+ BufDo call cmds#BufDo(<q-args>)
command! -nargs=+ WinDo call cmds#WinDo(<q-args>)

" :set tgc (and t_8f and t_8b so it actually works)
command! -nargs=0 -bar TGC if has('termguicolors') && !str2nr($VIM_NOTGC
 \|| $TERM =~? 'rxvt\|cygwin\|linux\|screen')
 \  | let [&t_8f,&t_8b] = ["\<esc>[38;2;%lu;%lu;%lum","\<esc>[48;2;%lu;%lu;%lum"]
 \  | set tgc
 \| endif

command! -nargs=0 -bar SourceVimrc Keepview source $MYVIMRC | redraw
 \| sil! call popup_atcursor('vimrc loaded', #{moved:'any',line:'cursor+1',col:'cursor+1'})

command! -nargs=0 -bar SourceVimAll Keepview source $MYVIMRC
 \\| let __sv = map(cmds#SourceListedVimfiles(), { _,f -> fnameescape(fnamemodify(f, ':~:.')) })
 \| redraw | echo 'vimrc loaded'.(empty(__sv)?'':' +('.join(__sv, ', ').')')

command! -nargs=0 -bar SourceCurrent Keepview so % | redraw | echo 'Sourced' expand('%')

command! -nargs=0 -bar SourceGuarded Keepview call cmds#SourceVimGuard() | redraw
 \| echo 'Sourced' expand('%')

command! -nargs=1 -bar Keepview let w:viewsav = winsaveview() | <args> | call winrestview(w:viewsav)

" AUTOCMDS:        {{{1

augroup Vimrc
  autocmd!

  " prevent random jumping when writing. noice *tongue click*
  autocmd BufWritePre * let w:viewsav = winsaveview()
  autocmd BufWritePost * call winrestview(w:viewsav)

  if has('mksession')
    " save and restore view persistently. noice *tongue click*
    autocmd BufWinLeave * call mkview#make()
    autocmd VimLeave * call mkview#make()
    autocmd BufWinEnter * call mkview#load()
  endif

  " save and restore window before and after hivis runs. noice *tongue click*
  autocmd User HivisPre let w:hivis_viewsav = winsaveview()
  autocmd User Hivis    call winrestview(w:hivis_viewsav)

  " *don't* insert comment when using o/O in normal mode
  " *do* insert comment when pressing <cr> in insert mode
  autocmd FileType * setlocal formatoptions+=r
  autocmd FileType * setlocal formatoptions-=o

  " " close preview window on CompleteDone (silent for [Command Line])
  " autocmd CompleteDone * sil! pclose

  " open folds with incsearch only if 3 or more characters(-ish) typed (to preserve folds)
  " (use c_CTRL-O instead)
  if exists('##CmdlineChanged')
    autocmd CmdlineChanged [/?] if foldclosed('.') isnot -1
    autocmd CmdlineChanged [/?]  execute 'normal! zv'
    autocmd CmdlineChanged [/?] endif
  endif

  " prevent folding madness when typing parens or brackets in insert mode
  autocmd InsertEnter * if &fdm != 'manual'|let b:fdm = &foldmethod|setl foldmethod=manual|endif
  autocmd InsertLeave * execute 'setl foldmethod='.get(b:, 'fdm', 'manual')

  autocmd SwapExists * call autocmd#HandleSwap(expand('<afile>:p'))

  " automatically update time stamps for various files without messing up
  " view; don't update at all if time stamp is already up-to-date in order
  " to preserve undo history
  autocmd BufWritePre doc/*.txt call autocmd#UpdateDate()
  autocmd BufWritePre *.vim call autocmd#UpdateDate('^" Last Change:')
  autocmd BufWritePre {?,}vimrc call autocmd#UpdateDate('^" Last Change:')
  autocmd BufWritePre *.{py,snippets} call autocmd#UpdateDate('^# Last Change:')
  autocmd BufWritePre *.c,*.cpp,*.js call autocmd#UpdateDate('^\%(\/\/\| *\) Last Change:')

  autocmd FileType python if expand('%:t') =~ '^test_' && executable('pytest')
  " set makeprg to pytest for test_*.py files
  autocmd FileType python     setl makeprg='pytest'
  autocmd FileType python     autocmd! * <buffer>
  " automatically :lmake when test_*.py is written
  autocmd FileType python     autocmd BufWritePost <buffer> sil! lmake | redraw! | lopen | wincmd p
  autocmd FileType python endif

  if exists('##TerminalWinOpen')
    " move cursor to previous prompt string (no wrap)
    autocmd TerminalWinOpen * nnoremap <buffer> <silent> <c-p>
     \ -:call search('^\%(env\s\)\?[><]', 'bW')<cr>zt+

    " move cursor to next prompt string (no wrap)
    autocmd TerminalWinOpen * nnoremap <buffer> <silent> <c-n>
     \ $:call search('^\%(env\s\)\?[><]', 'W')<cr>zt+

    " set terminal colors
    autocmd TerminalWinOpen * if &tgc|call color#setTermColors()|endif

    " better, quieter statusline for terminal
    autocmd TerminalWinOpen * execute printf('file %s', substitute(@%, '^.*/', '', ''))
    autocmd TerminalWinOpen * setl stl=%{@%}%=[terminal]
    autocmd TerminalWinOpen * setl noswapfile

    autocmd TerminalWinOpen * setl nolist nonu
  endif

augroup end

" PLUGIN SETTINGS: {{{1

" Setup: {{{2

if !&loadplugins
  finish " --noplugin flag used: exit
endif

" auto-create autoload directory
if !isdirectory($VIMDIR.'/autoload')
  call mkdir($VIMDIR.'/autoload', 'p')
endif

if !filereadable($VIMDIR.'/autoload/plug.vim')
  " plug.vim not in autoload dir; (1) warn and (2) set up :PlugDownload

  function! s:plugWarnSetup()
    echohl WarningMsg
    if !executable('curl')
      echon 'curl is not installed; install it, then run :PlugDownload'
    else
      echon 'vim-plug is not installed; run :PlugDownload to install it'
    endif
    echohl None

    command! -nargs=0 -bar PlugDownload execute 'silent !curl -NsfLo '.$VIMDIR
     \ .'/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
     \ | redraw! | SourceVimrc | PlugInstall --sync | SourceVimrc
  endfunction

  augroup PlugDownload
    autocmd!
    " warn about plug on VimEnter since it's not isntalled
    autocmd VimEnter * call s:plugWarnSetup()
  augroup end

  finish " since vim-plug is not installed, exit
endif

" }}}

" C:              {{{2

let g:c_no_cformat = 1
let g:c_no_c99 = 1
let g:c_no_c11 = 1
let g:c_no_bsd = 1

" Vim:            {{{2

let g:vim_indent_cont = 1

" }}}
" Syntax Folding: {{{2

" let g:ada_folding               = 'ig'
" let g:baan_fold                 = 1
" let g:clojure_fold              = 1
" let g:fortran_fold              = 1
" let g:fortran_fold_conditionals = 1
" let g:ft_man_folding_enable     = 1
" let g:javaScript_fold           = 1
" let g:markdown_folding          = 1
" let g:perl_fold                 = 1
" let g:php_folding               = 1
" let g:r_syntax_folding          = 1
" let g:ruby_fold                 = 1
" let g:rust_fold                 = 1
" let g:sh_fold_enabled           = 3
" let g:tex_fold_enabled          = 1
" let g:tex_fold_enabled          = 1
" let g:vimsyn_folding            = 'afP'
" let g:vimtex_fold_manual        = 0
" let g:vimtex_folding            = 1
" let g:vimtex_toc_fold           = 1
" let g:xml_syntax_folding        = 1
" let g:zsh_fold_enable           = 1

" Banish Netrw:   {{{2

" let g:loaded_netrw       = 1
" let g:loaded_netrwPlugin = 1

" Placeholder:    {{{2

map <m-h> <plug>(placeholderPrev)
imap <m-h> <plug>(placeholderPrev)
smap <m-h> <plug>(placeholderPrev)
map <m-l> <plug>(placeholderNext)
imap <m-l> <plug>(placeholderNext)
smap <m-l> <plug>(placeholderNext)
imap <m-;> <plug>(placeholder)
imap <m-:> <plug>(placeholderPrompt)

" Matchup:        {{{2

let g:matchup_transmute_enabled = 0
let g:matchup_delim_noskips = 2
let g:matchup_matchparen_status_offscreen = 1
let g:matchup_matchparen_offscreen = { 'method': 'popup', 'scrolloff': 1 }
let g:matchup_matchparen_deferred = 1
" let g:matchup_matchparen_hi_surround_always = 1

" Ultisnips:      {{{2

let g:UltiSnipsExpandTrigger         = '<tab>'
let g:UltiSnipsJumpForwardTrigger    = '<m-o>'
let g:UltiSnipsJumpBackwardTrigger   = '<m-i>'
let g:UltiSnipsListSnippets          = '<F4>'
let g:UltiSnipsSnippetDirectories    = [ 'UltiSnips' ]
let g:ultisnips_python_quoting_style = 'double'

" Python Syntax:  {{{2

let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

" Vimtex:         {{{2

let g:tex_flavor = 'latex'
let vimtex_view_general_viewer = 'zathura'
let vimtex_viewer_general = 'zathura'
let vimtex_view_method = 'zathura'
let vimtex_quickfix_mode = 0
let tex_conceal = 'abdmg'
let g:vimtex_compiler_latexmk = {
 \ 'build_dir' : 'latexbuild',
 \}

" Tex Conceal:    {{{2

let g:tex_conceal='abdmg'

" Gruvbox:        {{{2

let g:gruvbox_italicize_strings = 0

" Plug:           {{{2

let g:plug_threads = 64

" }}}

" PLUGINS:         {{{1

call plug#begin($VIMDIR.'/plugged')

" GITHUB: {{{2

Plug 'dylnmc/ctrlg.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
" Plug 'dylnmc/lsbuffer.vim'
Plug 'dylnmc/placeholder.vim'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'dylnmc/synstack.vim'
Plug 'godlygeek/tabular'
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-abolish'
Plug 'fcpg/vim-altscreen'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-fugitive'
Plug 'sickill/vim-pasta'
" Plug 'junegunn/vim-plug'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-table-mode'
" Plug 'puremourning/vimspector'
Plug 'lervag/vimtex'

if exists('*matchaddpos')
  Plug 'andymass/vim-matchup'
endif

if has('python3') || has('python')
  Plug 'SirVer/ultisnips'
endif

" COLORS: {{{2

" BEST: The best, and the ones I use
Plug 'cocopon/iceberg.vim'
Plug 'ajh17/spacegray.vim'
Plug 'dylnmc/vim-colors-paramount'
Plug 'lifepillar/vim-gruvbox8'
Plug 'dylnmc/vulpo.vim'

" " GREAT: Some of the best, and I like 'em
" Plug 'AlessandroYorba/Alduin'
" Plug 'tlhr/anderson.vim'
" Plug 'romainl/Apprentice'
" Plug 'ayu-theme/ayu-vim' " g:ayucolor: dark,mirage,light
" Plug 'sjl/badwolf'
" Plug 'doums/darcula'
" Plug 'vivkin/flatland.vim'
" Plug 'yorickpeterse/happy_hacking.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'dikiaap/minimalist'
" Plug 'arcticicestudio/nord-vim'
" Plug 'dylnmc/novum.vim'
" Plug 'mhartington/oceanic-next'
" Plug 'joshdick/onedark.vim'
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'dolio/romainl-sorcerer'
" Plug 'zefei/simple-dark'
" Plug 'sainnhe/sonokai'
" Plug 'jacoborus/tender.vim'
" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'tyrannicaltoucan/vim-deep-space'
" Plug 'fcpg/vim-fahrenheit'
" Plug 'habamax/vim-habanight'
" Plug 'w0ng/vim-hybrid'
" Plug 'lifepillar/vim-solarized8'
" Plug 'cideM/yui'  " light

" GOOD: Some of the best, but not my taste
" Plug 'jdsimcoe/abstract.vim'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'dylnmc/silentium.vim'
" Plug 'liuchengxu/space-vim-dark'
" Plug 'wimstefan/vim-artesanal'
" Plug 'ajmwagar/vim-deus'
" Plug 'Lokaltog/vim-distinguished'  " :set notgc
" Plug 'kristijanhusak/vim-hybrid-material'  " hybrid_reverse best
" Plug 'jonathanfilip/vim-lucius'
" Plug 'tyrannicaltoucan/vim-quantum'

" GITLAB: {{{2

let g:plug_url_format = 'https://gitlab.com/%s.git'

" Plug 'dylnmc/dropcl.vim'
Plug 'HiPhish/info.vim'
" Plug 'dylnmc/lyne.vim'
Plug 'dylnmc/qfilter.vim'
" Plug 'dylnmc/vim-logipair'
" Plug 'dylnmc/vim-titlecase'
Plug 'dylnmc/ViMan'

unlet g:plug_url_format

" }}}

call plug#end()

" COLOR:           {{{1

let s:colors_name = get(g:, 'colors_name', 'default')
if s:colors_name is 'default' || s:colors_name is 'desert'
  try
    " TGC
    set background=dark
    colo vulpo
  catch /^Vim\%((\a\+)\)\=:E185:/
    colo desert
  endtry
else
  execute 'colo '.get(g:, 'colors_name', 'desert')
endif

