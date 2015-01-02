"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim ftplugin file
"
" Language: JSX (JavaScript)
" Maintainer: David Wilhelm <dewilhelm@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('b:did_vim_react') && b:did_vim_react
    finish
endif
if &previewwindow
    finish
endif
let b:did_vim_react = 1

let s:jsxc = expand('<sfile>:p:h').'/../bin/jsxc'

function! JSXCompile() range
    let jsx_text = join(getline(a:firstline, a:lastline), "\n")

    let result = system(s:jsxc, jsx_text)
    "copy to register
    let @f = result

    "try to enter preview window
    silent! wincmd P
    if &previewwindow
        :%d
        normal "fp
        wincmd p
    else
        "setup preview window
        pedit jxsc
        silent! wincmd P

        setlocal bufhidden=hide
        setlocal nobuflisted
        setlocal buftype=nofile
        setlocal foldcolumn=0
        setlocal nofoldenable
        setlocal nonumber
        setlocal noswapfile

        set ft=javascript
        :%d
        normal "fp

        wincmd p
    endif
endfunction

"compile selected region using jsx compiler
command! -range JSXC <line1>,<line2>call JSXCompile()

vnoremap <silent> jc :JSXC<CR>
"for single liner
nnoremap <silent> jc :JSXC<CR>
"close
nnoremap <silent> cp :pc!<CR>
