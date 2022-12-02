;
; UnofficialPatch - Remove Old(+31Day) BackupFiles
;

#NoEnv
#NoTrayIcon
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1

scite := GetSciTEInstance()

if !scite
	ExitApp

nDate := SubStr(A_Now, 1, 8)
Loop, % scite.ResolveProp("SciteUserHome") . "\backup\*.bak", 0
{
	tDate := SubStr(A_LoopFileName, -17, 8)
	tDate -= nDate, Days
	if (tDate < -31)
		FileDelete, % A_LoopFileFullPath
}
ExitApp