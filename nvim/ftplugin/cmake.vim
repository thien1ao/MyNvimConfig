" CMakeLists.txt / *.cmake settings
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
setlocal commentstring=#\ %s

" build project from the top-level build dir (see g:BuildInSubDir in init.lua)
silent! call g:BuildInSubDir("/build")
nmap <buffer> <silent> \l :copen<CR>
