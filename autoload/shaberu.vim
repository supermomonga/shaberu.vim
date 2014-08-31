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
  let text = shaberu#filter(a:text)
  let l:command = shaberu#command()
  if l:command != ''
    if g:shaberu_is_mute
      if g:shaberu_echo_when_mute
        echo 'Mute : ' . text
      endif
    else
      if g:shaberu_use_voicetext_api
        " Use VoiceText API
        call vimproc#system_bg(
              \   'curl "https://api.voicetext.jp/v1/tts" -s '
              \   . ' -u "' . g:shaberu_voicetext_apikey . ':"'
              \   . ' -d "text=' . text . '"'
              \   . ' -d "speaker=' . g:shaberu_voicetext_speaker . '"'
              \   . ' | ' . g:shaberu_voicetext_play_command
              \ )
      else
        " Normal
        call vimproc#system_bg(substitute(l:command, '%%TEXT%%', text, ''))
      endif
    endif
  else
    echo 'No default speech command found. Please define the user command.'
  endif
endfunction


" Filter with dicts
function! shaberu#filter(text)
  let text = a:text
  for key in keys(g:shaberu_dicts)
    let dict = g:shaberu_dicts[key]
    for filter in dict
      let text = substitute(text, '\c' . filter[0], filter[1], 'g')
    endfor
  endfor
  return text
endfunction



" Speech text interactive
function! shaberu#say_interactive()
  let l:text = input("Text to speech: ")
  if l:text == ""
    return 0
  else
    call shaberu#say(l:text)
    return 1
  end
endfunction


" Speech and then prepare to exec :ShaberuSay command again.
function! shaberu#say_interactive_recursive()
  let l:result = 1
  while l:result
    let l:result = shaberu#say_interactive()
  endwhile
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

" louise uwaaaaaaan
function! shaberu#louise()
  let l:text = 'ルイズ！ルイズ！ルイズ！ルイズぅぅうううわぁああああああああああああああああああああああん！！！' .
        \ 'あぁああああ…ああ…あっあっー！あぁああああああ！！！ルイズルイズルイズぅううぁわぁああああ！！！' .
        \ 'あぁクンカクンカ！クンカクンカ！スーハースーハー！スーハースーハー！いい匂いだなぁ…くんくん' .
        \ 'んはぁっ！ルイズ・フランソワーズたんの桃色ブロンドの髪をクンカクンカしたいお！クンカクンカ！あぁあ！！' .
        \ '間違えた！モフモフしたいお！モフモフ！モフモフ！髪髪モフモフ！カリカリモフモフ…きゅんきゅんきゅい！！' .
        \ '小説12巻のルイズたんかわいかったよぅ！！あぁぁああ…あああ…あっあぁああああ！！ふぁぁあああんんっ！！' .
        \ 'アニメ2期放送されて良かったねルイズたん！あぁあああああ！かわいい！ルイズたん！かわいい！あっああぁああ！' .
        \ 'コミック2巻も発売されて嬉し…いやぁああああああ！！！にゃああああああああん！！ぎゃああああああああ！！' .
        \ 'ぐあああああああああああ！！！コミックなんて現実じゃない！！！！あ…小説もアニメもよく考えたら…' .
        \ 'ル イ ズ ち ゃ ん は 現実 じ ゃ な い？にゃあああああああああああああん！！うぁああああああああああ！！' .
        \ 'そんなぁああああああ！！いやぁぁぁあああああああああ！！はぁああああああん！！ハルケギニアぁああああ！！' .
        \ 'この！ちきしょー！やめてやる！！現実なんかやめ…て…え！？見…てる？表紙絵のルイズちゃんが僕を見てる？' .
        \ '表紙絵のルイズちゃんが僕を見てるぞ！ルイズちゃんが僕を見てるぞ！挿絵のルイズちゃんが僕を見てるぞ！！' .
        \ 'アニメのルイズちゃんが僕に話しかけてるぞ！！！よかった…世の中まだまだ捨てたモンじゃないんだねっ！' .
        \ 'いやっほぉおおおおおおお！！！僕にはルイズちゃんがいる！！やったよケティ！！ひとりでできるもん！！！' .
        \ 'あ、コミックのルイズちゃああああああああああああああん！！いやぁあああああああああああああああ！！！！' .
        \ 'あっあんああっああんあアン様ぁあ！！シ、シエスター！！アンリエッタぁああああああ！！！タバサｧぁあああ！！' .
        \ 'ううっうぅうう！！俺の想いよルイズへ届け！！ハルゲニアのルイズへ届け'
  echo l:text
  call shaberu#say(l:text)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
