; SciTE4AutoHotkey v3 user autorun script
;
; You are encouraged to edit this script!
;

#NoEnv
#NoTrayIcon
SetWorkingDir, %A_ScriptDir%

Run, "%A_AhkPath%" "tools\AutoUpdate.ahk"
if (!FileExist(A_ScriptDir "\tools\$UPDATE"))
{
	Run, "%A_AhkPath%" "tools\PropUpdate.ahk"
	Run, "%A_AhkPath%" "tools\OldBakRemover.ahk"
	Run, "%A_AhkPath%" "tools\PatchLog.ahk"
}