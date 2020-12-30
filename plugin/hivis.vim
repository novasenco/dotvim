" Author: Nova Senco
" Last Change: 06 December 2020

augroup HiVis
  autocmd!

  " when populating new window with a colorscheme buffer
  autocmd BufRead */colors/*.vim if !get(g:, 'no_auto_hivis', get(b:, 'no_auto_hivis'))
  autocmd BufRead */colors/*.vim   sil doautocmd User HivisPre
  autocmd BufRead */colors/*.vim   call hivis#hi()
  autocmd BufRead */colors/*.vim   sil doautocmd User Hivis
  autocmd BufRead */colors/*.vim endif
  if exists('##WinNew')
    autocmd WinNew */colors/*.vim if !get(g:, 'no_auto_hivis', get(b:, 'no_auto_hivis'))
    autocmd WinNew */colors/*.vim   sil doautocmd User HivisPre
    autocmd WinNew */colors/*.vim   call hivis#hi()
    autocmd WinNew */colors/*.vim   sil doautocmd User Hivis
    autocmd WinNew */colors/*.vim endif
  endif

  " when entering window again
  autocmd BufWinEnter */colors/*.vim if !get(g:, 'no_auto_hivis', get(b:, 'no_auto_hivis'))
  autocmd BufWinEnter */colors/*.vim   sil doautocmd User HivisPre
  autocmd BufWinEnter */colors/*.vim   call clearmatches()
  autocmd BufWinEnter */colors/*.vim   call hivis#hi()
  autocmd BufWinEnter */colors/*.vim   sil doautocmd User Hivis
  autocmd BufWinEnter */colors/*.vim endif

  " when leaving window
  autocmd BufWinLeave */colors/*.vim call clearmatches()
  autocmd BufLeave    */colors/*.vim call clearmatches()

  " when writing color scheme
  autocmd BufWritePost */colors/*.vim if !get(g:, 'no_auto_hivis', get(b:, 'no_auto_hivis'))
  autocmd BufWritePost */colors/*.vim   sil doautocmd User HivisPre
  autocmd BufWritePost */colors/*.vim   source %
  autocmd BufWritePost */colors/*.vim   call clearmatches()
  autocmd BufWritePost */colors/*.vim   call hivis#hi()
  autocmd BufWritePost */colors/*.vim   sil doautocmd User Hivis
  autocmd BufWritePost */colors/*.vim endif
augroup end

