" super cool voice synthesis wrapper library
" Version: 0.0.1
" Author : supermomonga (@supermomonga)
" License: NYSL

if exists('g:loaded_shaberu')
  finish
endif
let g:loaded_shaberu = 1

let s:save_cpo = &cpo
set cpo&vim

" Default settings
let g:shaberu_use_voicetext_api      = get(g:, 'shaberu_use_voicetext_api', 0)
let g:shaberu_voicetext_apikey       = get(g:, 'shaberu_voicetext_apikey', '')
let g:shaberu_voicetext_speaker      = get(g:, 'shaberu_voicetext_speaker', 'haruka')
let g:shaberu_voicetext_play_command = get(g:, 'shaberu_voicetext_play_command', 'mplayer -really-quiet -cache 1024 -')
let g:shaberu_cache_dir              = get(g:, 'shaberu_cache_dir', '~/.shaberu_cache')
let g:shaberu_is_mute                = get(g:, 'shaberu_is_mute', 0)
let g:shaberu_echo_when_mute         = get(g:, 'shaberu_echo_when_mute', 1)
let g:shaberu_path_sapi              = substitute(substitute(expand('<sfile>'), '\.vim$', '_sapi.vbs', ''), '\\', '/', 'g')
let g:shaberu_dicts                  = get(g:, 'shaberu_dicts', {})
let g:shaberu_dicts.default          = get(g:shaberu_dicts, 'default', [
      \   ['https\?:\/\/.\+', 'URL'],
      \   ['vim\s*script', 'ビムスクリプト'],
      \   ['vim', 'ビム'],
      \   ['emacs', 'イーマックス'],
      \   ['ruby', 'ルビー'],
      \   ['hi', 'ハイ'],
      \   ['benri', '便利'],
      \   ['benry', '便利'],
      \   ['lingr', 'リングル'],
      \   ['twitter', 'ツイッター'],
      \   ['twitter', 'ツイッター'],
      \ ])

" Define commands
command! -nargs=1 ShaberuSay    call shaberu#say(<q-args>)
command! ShaberuSayInteractive  call shaberu#say_interactive()
command! ShaberuSayRecursive    call shaberu#say_interactive_recursive()
command! ShaberuMuteOn          call shaberu#mute(1)
command! ShaberuMuteOff         call shaberu#mute(0)
command! ShaberuMuteToggle      call shaberu#mute_toggle()

let &cpo = s:save_cpo
unlet s:save_cpo
