function Followfile() 
    wincmd b
    call StoreWinBuff()
    let g:window_buffers_idx[win_getid()] += 1
    wincmd t
    call StoreWinBuff()
    let g:window_buffers_idx[win_getid()] += 1
    wincmd b

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
    silent let output_full = trim(system("./scripts/follow.sh " . rtype . " " . rname . " ./" . rpath . " " . g:archive))
    if v:shell_error == 0
        silent let output = split(output_full)
        wincmd b
        " save buffer after following link to ensure only buffers that had
        " links are added
        call StoreWinBuff()
        let g:window_buffers_idx[win_getid()] += 1
        edit `=output[0]`
        wincmd t
        call StoreWinBuff()
        let g:window_buffers_idx[win_getid()] += 1
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
let g:hist_saved = {}
func! InitWinBuff()
    let g:window_buffers[win_getid()] = []
    let g:window_buffers_idx[win_getid()] = 0
    let g:hist_saved[win_getid()] = []
endfunc

func! StoreWinBuff()
    let winid = win_getid()
    let currind = g:window_buffers_idx[winid]
    " if in history, delete next buffers in this window
    if currind < (len(g:window_buffers[winid]) - 1)
        call remove(g:window_buffers[winid], currind + 1, len(g:window_buffers[winid]) - 1)
    " if at tail of history, do nothing
    " otherwise, add to history
    elseif currind > (len(g:window_buffers[winid]) - 1)
        call add(g:window_buffers[winid],bufname("%"))
    endif
endfunc

function FollowPDF(type)
    let rpath = expand('%:h')
    let pdf = trim(system("./scripts/get_pdf.sh " . rpath . " " . a:type . " " . g:archive))
    if g:remote == 0
        if exists("g:archives_pdf_cmd")
            echo g:archives_pdf_cmd . " " . pdf . " &"
            call system(g:archives_pdf_cmd . " " . pdf . " &")
        else
            echo "g:archives_pdf_cmd undefined."
        endif
    else
        if exists("g:remote_pdf_cmd")
            echo g:remote_pdf_cmd . " " . pdf . " &"
            call system(g:remote_pdf_cmd . " " . pdf . " &")
        else
            echo "g:remote_pdf_cmd undefined."
        endif
    endif
endfunction

function SelHistWin(choice)
    let winid = win_getid()
    let g:window_buffers[winid] = copy(g:hist_saved[winid][a:choice])
    let g:window_buffers_idx[winid] = len(g:window_buffers[winid]) - 1
    edit `=g:window_buffers[winid][g:window_buffers_idx[winid]]`
endfunction

function RefName(path)
    return trim(system("dirname `echo " . a:path . "` | cut -d/ -f2-"))
endfunction

function NextRPN()
    let ref = RefName(bufname("%"))
    call setline(line('.'), getline(line('.')) . trim(system("./scripts/next_rpn.sh " . ref)))
endfunction

function Make()
    let ref = RefName(bufname("%"))
    exe "!make output/tree/" . ref . "/tree.pdf"
    silent call FollowPDF("tree")
endfunction

function Upload()
    let ref = RefName(bufname("%"))
    echo "Are you sure you want to upload?"
    let choice = inputlist(['1. yes', '2. no'])
    if choice == 1
        if exists("g:client_secrets")
            exe "!./scripts/combine_record.sh " . ref
            exe "!./scripts/upload.sh " . ref . " " . g:client_secrets
        else
            echo "g:client_secrets undefined."
        endif
    else
        echo "aborting upload..."
    endif
endfunction

function Record()
    let ref = RefName(bufname("%"))
    exe "!./scripts/record.sh " . ref
endfunction

function FormatFilename(path)
    let ref = RefName(bufname(a:path))
    let filename = trim(system("basename `echo " . a:path . "`"))
    return ref . " (" . filename . ")"
endfunction

function SelHist()
    wincmd b
    let sel_list = []
    let i = 1
    for history in g:hist_saved[win_getid()]
        let formatted = FormatFilename(history[-1])
        call add(sel_list, i . ": " . formatted)
        let i = i + 1
    endfor

    let choice = inputlist(["Select history: "] + sel_list)
    let choice = choice - 1
    if (choice < 0) || (choice >= len(sel_list))
        return
    endif

    wincmd b
    call SelHistWin(choice)
    wincmd t
    call SelHistWin(choice)
    wincmd b
endfunction

function SaveHist()
    wincmd b
    call SaveHistWin()
    wincmd t
    call SaveHistWin()
    wincmd b
    echo "Saved " . FormatFilename(g:hist_saved[win_getid()][-1][-1])
endfunction

function SaveHistWin()
    let winid = win_getid()
    let currind = g:window_buffers_idx[winid]
    if currind == len(g:window_buffers[winid])
        call add(g:window_buffers[winid],bufname("%"))
    endif
    let this_hist = copy(g:window_buffers[winid][0:currind])
    call add(g:hist_saved[winid],this_hist)
endfunction

let g:remote=0

map <leader>f :call Followln()<CR>
map <leader>r :call Record()<CR>
map <leader>gf :call Followfile()<CR>
map <leader>H :call Backln()<CR>
map <leader>L :call Forwardln()<CR>
map <leader>c :call ChangeDef()<CR>
map <leader>p :call FollowPDF("tree")<CR>
map <leader>e :let g:remote = 1 - g:remote<CR>
map <leader>d :call FollowPDF("defs")<CR>
map <leader>n o\nrp <Esc>:call NextRPN()<CR>
map <leader>m :call Make()<CR>
map <leader>u :call Upload()<CR>
map <leader>x :call SaveHist()<CR>
map <leader>X :call SelHist()<CR>

map <leader>s :set hlsearch<CR>/\\refln[a-zA-Z]*{\w*}{[a-zA-Z_/]\{-}}/e<CR>

let options = system("find archives -maxdepth 1 -mindepth 1 -type d | cut -f2- -d/")
let archives = split(options)

let archives_fmt = []
let i = 1
for archive in archives
    let archives_fmt = archives_fmt + [i . ": " . archive]
    let i = i + 1
endfor

let choice = inputlist(["Select archive: "] + archives_fmt)
let choice = choice - 1
if (choice < 0) || (choice >= len(archives_fmt))
    quit
endif

let g:archive = archives[choice]
let archive_path = "archives/" . g:archive
edit `=archive_path . "/ref.tex"`
call InitWinBuff()
15split `=archive_path . "/defs.tex"`
call InitWinBuff()
set winfixheight
wincmd b

tabedit `=archive_path . "/preamble.tex"`
tabfirst
