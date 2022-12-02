;
; UnofficialPatch - Restore Original Editor
;

#NoTrayIcon
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1

if (!A_IsAdmin)
{
	MsgBox, 262180, Restore Original Editor, ����� ��ġ�� ����ϰ� ���� ���Ϸ� �ǵ����ڽ��ϱ�?
	IfMsgBox, Yes
	{
		MsgBox, 262180, Restore Original Editor, ���� ���� �����ͷ� �����Ͻðڽ��ϱ�?
		IfMsgBox, Yes
		{
			scite := GetSciTEInstance()
			param1 := scite.UserDir, param2 := scite.SciTEDir
			Run, *RunAs "%A_ScriptFullPath%" "%param1%" "%param2%"
			ExitApp
		}
		else
			ExitApp
	}
	else
		ExitApp
}

SciteUserHome = %1%
SciteDefaultHome = %2%

Loop, Files, % SciteDefaultHome "\PatchBackup\*", R
{
	if (InStr(A_LoopFileFullPath, "UserHome"))
		DivPos := InStr(A_LoopFileFullPath, "UserHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 7), SciteUserHome)
	else
		DivPos := InStr(A_LoopFileFullPath, "LocalHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 8), SciteDefaultHome)
	FileCopy, % A_LoopFileFullPath, % Target, 1
	if (!ErrorLevel)
		FileDelete, % A_LoopFileFullPath
}

index := 0
Loop, Files, % SciteDefaultHome "\PatchBackup\*", R
	index++

if (index = 0)
	FileRemoveDir, % SciteDefaultHome "\PatchBackup", 1

ExitApp

