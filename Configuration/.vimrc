
":syntax enable

set background=dark

set grepprg=grep\ -rnIH
noremap K	:grep "\<<C-R><C-W>\>" .<CR>
noremap gK	:grep "<C-R><C-W>" .<CR>

set ambiwidth=double

set hlsearch
set incsearch

:let loaded_matchparen = 0
:filetype indent on
set nobackup

set ts=4 shiftwidth=4

"set ttymouse=

"set encoding=japan
"set fileencodings=iso-2022-jp,sjis,utf-8,cp932,euc-jp

set tags=tags,~/tags

if &term == "xterm-256color"
	let &t_SI .= "\eP\e[3 q\e\\"
	let &t_EI .= "\eP\e[1 q\e\\"
elseif &term == "xterm"
	let &t_SI .= "\e[3 q"
	let &t_EI .= "\e[1 q"
endif

"set t_SI=[3\ q
"set t_EI=[1\ q

if &term == "xterm"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  set pastetoggle=<Esc>[201~
  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction
  map <special> <expr> <Esc>[200~ XTermPasteBegin("i")
  imap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  cmap <special> <Esc>[200~ <nop>
  cmap <special> <Esc>[201~ <nop>
endif

