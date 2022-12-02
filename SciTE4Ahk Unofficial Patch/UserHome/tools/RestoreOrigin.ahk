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
	MsgBox, 262180, Restore Original Editor, 비공식 패치를 취소하고 원본 파일로 되돌리겠습니까?
	IfMsgBox, Yes
	{
		MsgBox, 262180, Restore Original Editor, 정말 원본 에디터로 복원하시겠습니까?
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
index := 0

Loop, Files, % SciteDefaultHome "\PatchBackup\*", R
{
	if (InStr(A_LoopFileFullPath, "UserHome"))
		DivPos := InStr(A_LoopFileFullPath, "UserHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 7), SciteUserHome)
	else
		DivPos := InStr(A_LoopFileFullPath, "LocalHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 8), SciteDefaultHome)
	FileCopy, % A_LoopFileFullPath, % Target, 1
	if (ErrorLevel != 0)
		index++
}

if (index = 0)
{
	MsgBox, % "복원이 완료되었습니다.`n에디터를 재실행하면 적용됩니다."
	FileRemoveDir, % SciteDefaultHome "\PatchBackup"
}
else
{
	MsgBox, % "일부 파일의 복원에 실패했습니다.`n확인을 눌러 수동으로 복원해주십시오.`n`n"
						. "LocalHome폴더의 기본 경로는 C:\Program Files\AutoHotkey\SciTE\ 이며,`n
						. "UserHome폴더의 기본 경로는 내 문서\AutoHotkey\SciTE\ 입니다."
	Run, % SciteDefaultHome "\PatchBackup"
}
	
ExitApp

