let s:save_cpo = &cpo
set cpo&vim


" OSの判定
function! shaberu#os()
  if exists('g:shaberu_user_os')
    " 既に判定済みの場合は再計算しない
    return g:shaberu_user_os
  else
    if has('win16') || has('win32') || has('win64')
      let g:shaberu_user_os = 'win'
    elseif has('win32unix')
      let g:shaberu_user_os = 'win'
    elseif (has('mac') || has('macunix') || has('gui_macvim') ||
          \ (!executable('xdg-open') &&
          \ system('uname') =~? '^darwin'))
      let g:shaberu_user_os = 'mac'
    elseif system('uname') =~? '^Linux'
      let g:shaberu_user_os = 'linux'
    elseif has('unix')
      let g:shaberu_user_os = 'unix'
    else
      let g:shaberu_user_os = 'unknown'
    endif
    return g:shaberu_user_os
  endif
endfunction


" Return speech synthesis command string
function! shaberu#command()
  if exists('g:shaberu_user_define_say_command')
    return g:shaberu_user_define_say_command
  else
    let l:os = shaberu#os()
    if l:os == 'win'
      " TODO: sapi.dllのライセンスがよくわからないのでvbsでごまかしてる
      return 'cscript "' . g:shaberu_path_sapi . '" "%%TEXT%%"'
    elseif l:os == 'mac'
      " TODO: sayは標準コマンドだけど日本語ボイスが標準かどうか微妙
      return 'say "%%TEXT%%"'
    elseif l:os == 'unix'
      " TODO: unixに標準ライブラリあるのかな…
    elseif l:os == 'linux'
      " TODO: linuxに標準ライブラリあるのかな…
    endif
  endif
  return 0
endfunction


" Just speech
function! shaberu#say(text)
  let l:command = shaberu#command()
  if l:command != '' 
    if g:shaberu_is_mute && g:shaberu_echo_when_mute
      echo 'Mute : ' . a:text 
    else
      call vimproc#system_bg(substitute(l:command, '%%TEXT%%', a:text, ''))
    endif
  else
    echo 'No default speech command found. Please define the user command.'
  endif
endfunction

" Speech and do something 
function! shaberu#order(text, order)
  call shaberu#say(a:text)
  execute a:order
endfunction

" mute on/off
function! shaberu#mute(status)
  let g:shaberu_is_mute = a:status
endfunction

" toggle mute
function! shaberu#mute_toggle()
  let g:shaberu_is_mute = g:shaberu_is_mute == 1 ? 0 : 1
  echo 'Now mute is ' . (g:shaberu_is_mute == 1 ? 'ON' : 'OFF')
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
