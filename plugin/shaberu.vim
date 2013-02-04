" super cool voice synthesis wrapper library
" Version: 0.0.1
" Author : supermomonga (@supermomonga)
" License: NYSL

if exists('g:loaded_ref')
  finish
endif
let g:loaded_ref = 1

let s:save_cpo = &cpo
set cpo&vim


command! -nargs=+ ShaberuSay call shaberu#say(<q-args>)
command! ShaberuMuteOn     call shaberu#mute(1)
command! ShaberuMuteOff    call shaberu#mute(0)
command! ShaberuMuteToggle call shaberu#mute_toggle()



" Default settings
let g:shaberu_is_mute = 0
let g:shaberu_echo_when_mute = 1


let &cpo = s:save_cpo
unlet s:save_cpo
