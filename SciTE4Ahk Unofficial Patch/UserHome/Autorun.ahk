; SciTE4AutoHotkey v3 user autorun script
;
; You are encouraged to edit this script!
;

#NoEnv
#NoTrayIcon
SetWorkingDir, %A_ScriptDir%

Run, tools\PropUpdate.ahk

Run, tools\OldBakRemover.ahk

if (!FileExist(A_ScriptDir "\tools\$UPDATE"))
	Run, tools\PatchLog.ahk
