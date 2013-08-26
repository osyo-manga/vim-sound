scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! sound#play_wav(wav)
	if !filereadable(a:wav)
		return
	endif
	let cmd = ""
	if executable("afplay")
		let cmd = "afplay %s"
	elseif executable("aplay")
		let cmd = "aplay %s"
	elseif executable("sndrec32")
		let cmd = "sndrec32 /embedding /play /close %s"
	endif
	call vimproc#system_bg(printf(cmd, a:wav))
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
