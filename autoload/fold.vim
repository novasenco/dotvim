
if !exists('g:folddash')
  " let g:folddash = '•'
  let g:folddash = '⦿'
endif

" efficient (consolidated from below)
function! fold#text()
  return substitute(substitute(substitute(getline(v:foldstart), '^\s\{-}\zs\t', repeat('',&tabstop),'g'), escape(split(&foldmarker,',')[0], '~$^*[]\.').'\d*\s*', '', ''), '^\s*'.(&commentstring =~ '%s' ? '\%('.escape(split(&commentstring, '%s')[0], '~$^*[]\.').'\)\?' : '').'\s*', (tr(v:folddashes, '-', g:folddash)).' ', '')
endfunction


finish

" tabs -> spaces
function! s:tab(line)
  return substitute(a:line, '^\s\{-}\zs\t', repeat('',&tabstop),'g')
endfunction

" remove foldmarker from line
function! s:rmFdm(line)
  return substitute(a:line, escape(split(&foldmarker,',')[0], '~$^*[]\.').'\d*\s*', '', '')
endfunction

" Add n '•'s to beginning of line (where n is foldlevel)
function! s:prefix(line)
  let cms = &commentstring =~ '%s' ? '\%('.escape(split(&commentstring, '%s')[0], '~$^*[]\.').'\)\?' : ''
  let dash = tr(v:folddashes, '-', g:folddash)
  return substitute(a:line, '^\s*'.cms.'\s*', dash.' ', '')
endfunction

" foldtext function
function! fold#text()
  return s:prefix(s:rmFdm(s:tab(getline(v:foldstart))))
endfunction

