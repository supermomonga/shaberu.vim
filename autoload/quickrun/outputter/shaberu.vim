if exists('g:shaberu_quickrun_outputter_loaded') && g:shaberu_quickrun_outputter_loaded
    finish
endif
let g:shaberu_quickrun_outputter_loaded = 1

let s:outputter = quickrun#outputter#buffer#new()
let s:outputter.close_on_empty = 1

function! s:outputter.output(data, session)
    call shaberu#say(a:data)
endfunction

function! quickrun#outputter#shaberu#new()
    return deepcopy(s:outputter)
endfunction
