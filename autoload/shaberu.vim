let s:save_cpo = &cpo
set cpo&vim


" Return speech synthesis command string
function! shaberu#command()
  if exists('g:shaberu_user_define_say_command')
    return g:shaberu_user_define_say_command
  else
    if has('mac')
      " TODO: sayは標準コマンドだけど日本語ボイスが標準かどうか微妙
      return 'say '
    elseif has('unix')
      " TODO: unixに標準ライブラリあるのかな…
    elseif has('win32') || has('win64')
      " TODO: WindowsにはSAPIというMS標準ライブラリがあるらしいがよくわかってない
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
      call vimproc#system_bg(l:command . a:text)
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
