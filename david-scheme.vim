" Vim color file
" Maintainer:   Your name <youremail@something.com>
" Last Change:  
" URL:		

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" your pick:
set background=dark	" or light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="david-scheme"

"hi Normal

" OR

" highlight clear Normal
" set background&
" highlight clear
" if &background == "light"
"   highlight Error ...
"   ...
" else
"   highlight Error ...
"   ...
" endif

" A good way to see what your colorscheme does is to follow this procedure:
" :w 
" :so % 
"
" Then to see what the current setting is use the highlight command.  
" For example,
" 	:hi Cursor
" gives
"	Cursor         xxx guifg=bg guibg=fg 
 	
" Uncomment and complete the commands you want to change from the default.

"hi Cursor		
"hi CursorIM	
"hi Directory	
"hi DiffAdd		
"hi DiffChange	
"hi DiffDelete	
"hi DiffText	
"hi ErrorMsg	
hi VertSplit cterm=Bold,None ctermfg=15 ctermbg=0
hi Folded ctermfg=6 ctermbg=0
"hi FoldColumn	
"hi IncSearch	
hi LineNr ctermfg=8 ctermbg=0
hi ColorColumn ctermbg=8
"hi ModeMsg		
"hi MoreMsg		
"hi NonText		
"hi Question	
"hi Search		
"hi SpecialKey	
hi TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4
"hi Title		
"hi Visual		
"hi VisualNOS	
"hi WarningMsg	
"hi WildMenu	
"hi Menu		
"hi Scrollbar	
"hi Tooltip		

" syntax highlighting groups
hi Comment ctermfg=8
hi Constant ctermfg=2
hi Identifier ctermfg=9
hi Statement ctermfg=9
hi PreProc ctermfg=4
hi Type	ctermfg=3
"hi Special	
"hi Underlined	
"hi Ignore		
"hi Error		
"hi Todo		

