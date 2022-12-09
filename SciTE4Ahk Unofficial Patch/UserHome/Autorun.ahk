; SciTE4AutoHotkey v3 user autorun script
;
; You are encouraged to edit this script!
;

#NoEnv
#NoTrayIcon
SetWorkingDir, %A_ScriptDir%

if (!FileExist(A_ScriptDir "\tools\$UPDATE"))
{
	Run, tools\PropUpdate.ahk
	Run, tools\AutoUpdate.ahk
	Run, tools\OldBakRemover.ahk
	Run, tools\PatchLog.ahk
}