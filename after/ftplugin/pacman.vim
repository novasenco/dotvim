" Author: Nova Senco
" Last Change: 01 October 2020

syntax match PacmanTitle    "^\S.*"
syntax match PacmanRepo     "^[^/]\+" contained containedin=PacmanTitle nextgroup=PacmanPkgName
syntax match PacmanPkgName  "/\S\+"hs=s+1 contained containedin=PacmanTitle

hi! link PacmanRepo Statement
hi! link PacmanPkgName Type
" Identifier

