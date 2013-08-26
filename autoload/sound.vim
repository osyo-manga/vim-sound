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
	elseif executable("ruby") && (has("win32") || has("win64"))
		let cmd = "ruby -r \"Win32API\" -e \"Win32API.new('winmm','PlaySound', 'ppl', 'i').call('%s',nil,0)\""
	endif
	call vimproc#system_bg(printf(cmd, a:wav))
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
