function Followfile() 
  let rpos = searchpos('rinclude', 'bn')
  if rpos[0] == line(".")
    let rlist = matchlist(strpart(getline('.'), rpos[1] + 1), '{\(.\{-}\)}')
    let rpath = expand('%:h')
    let rtail = rlist[1]
    let rpathtail = rpath . "/" . rtail . ".tex"
    edit `=rpathtail`
  endif
endfunction

function ChangeDef()
  if len(getbufinfo({'bufmodified': 1})) == 0
    let rpos = searchpos('\\def\\', 'bne')
    if rpos[0] == line(".")
      let rlist = matchlist(strpart(getline('.'), rpos[1]), '\([a-zA-Z]*\)')
      let orig = rlist[1]
      let rpath = expand('%:h')
      let new = input("Replace '" . orig  . "' with: ")
      call system("./scripts/replace_def.sh " . rpath . " " . orig . " " . new)
      set autoread | checktime | set noautoread
    endif
  else
    echo "Close all modified buffers before changing defs."
  endif
endfunction

function Followln() 
  let rpos = searchpos('refln[a-zA-Z]*', 'bne')
  if rpos[0] == line(".")
    let rlist = matchlist(strpart(getline('.'), rpos[1]), '{\(.\{-}\)}{\(.\{-}\)}')
    let rtype = rlist[1]
    let rname = rlist[2]
    let rpath = expand('%:h')
    silent let output_full = trim(system("./scripts/follow.sh " . rtype . " " . rname . " ./" . rpath))
    if v:shell_error == 0
        silent let output = split(output_full)
        wincmd b
        " save buffer after following link to ensure only buffers that had
        " links are added
        call StoreWinBuff()
        edit `=output[0]`
        wincmd t
        call StoreWinBuff()
        edit `=output[1]`
        wincmd b
    else
        echo "Error following \"" . rname . "\": " . output_full . ""
    endif
  endif
endfunction

function Backln()
    wincmd b
    call Backlnwin()
    wincmd t
    call Backlnwin()
    wincmd b
endfunction

function Backlnwin()
    let winid = win_getid()
    let currind = g:window_buffers_idx[winid]
    if currind > 0
        " on the most recently opened buffer, need to save
        if currind == len(g:window_buffers[winid])
            call add(g:window_buffers[winid],bufname("%"))
        endif
        let currind = g:window_buffers_idx[winid] - 1
        let g:window_buffers_idx[winid] = currind
        edit `=g:window_buffers[winid][currind]`
    endif
endfunction

function Forwardln()
    wincmd b
    call Forwardlnwin()
    wincmd t
    call Forwardlnwin()
    wincmd b
endfunction

function Forwardlnwin()
    let winid = win_getid()
    let currind = g:window_buffers_idx[winid]
    if currind < (len(g:window_buffers[winid]) - 1)
        let currind = g:window_buffers_idx[winid] + 1
        let g:window_buffers_idx[winid] = currind
        edit `=g:window_buffers[winid][currind]`
    endif
endfunction

let g:window_buffers = {}
let g:window_buffers_idx = {}
func! InitWinBuff()
    let g:window_buffers[win_getid()] = []
    let g:window_buffers_idx[win_getid()] = 0
endfunc

func! StoreWinBuff()
    let winid = win_getid()
    let currind = g:window_buffers_idx[winid]
    " if in history, delete next buffers in this window
    if currind < (len(g:window_buffers[winid]) - 1)
        call remove(g:window_buffers[winid], currind + 1, len(g:window_buffers[winid]) - 1)
    else " otherwise, add to history
        call add(g:window_buffers[winid],bufname("%"))
    endif
    let currind += 1
    let g:window_buffers_idx[winid] = currind
endfunc

function FollowPDF()
    let rpath = expand('%:h')
    call system("./scripts/follow_pdf.sh " . rpath)   
endfunction

function FollowDefs()
    let rpath = expand('%:h')
    call system("./scripts/follow_defs.sh " . rpath)   
endfunction

function FormatDefs()
    let rpath = expand('%:h')
    call system("./scripts/format_pdf.sh " . rpath . " defs")
endfunction

function FormatPDF()
    let rpath = expand('%:h')
    call system("./scripts/format_pdf.sh " . rpath . " ref")
endfunction

map <leader>f :call Followln()<CR>
map <leader>gf :call Followfile()<CR>
map <leader>H :call Backln()<CR>
map <leader>L :call Forwardln()<CR>
map <leader>c :call ChangeDef()<CR>
map <leader>p :call FollowPDF()<CR>
map <leader>d :call FollowDefs()<CR>
map <leader>P :call FormatPDF()<CR>
map <leader>D :call FormatDefs()<CR>

map <leader>s :set hlsearch<CR>/\\refln[a-zA-Z]*{\w*}{[a-zA-Z_/]\{-}}/e<CR>

edit src/archives/ref.tex
call InitWinBuff()
15split src/archives/defs.tex
call InitWinBuff()
set winfixheight
wincmd b
tabedit src/archives.cls

tabfirst
