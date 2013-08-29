scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:wav_cmd(wav)
	if !filereadable(a:wav)
		return ""
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
	return printf(cmd, a:wav)
endfunction


function! s:wav_cmd(wav)
	return s:wav_cmd(a:wav)
endfunction

function! s:wav_list_cmd(wavs)
	let wavs = filter(a:wavs, "filereadable(v:val)")
	if empty(wavs)
		return ""
	endif
	if executable("ruby") && (has("win32") || has("win64"))
		let expr = join(map(wavs, "\"Win32API.new('winmm','PlaySound', 'ppl', 'i').call(\" . string(v:val) . \",nil,0)\""), ';')
		return printf("ruby -r \"Win32API\" -e \"%s\"", expr)
	else
		return ""
	endif
endfunction


function! sound#play_wav(wav)
	if type(a:wav) == type([])
		let cmd = s:wav_list_cmd(a:wav)
	else
		let cmd = s:wav_cmd(a:wav)
	endif
	if empty(cmd)
		return
	endif
	echo cmd
	call vimproc#system_bg(cmd)
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
