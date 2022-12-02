;
; UnofficialPatch - AutoUpdate
;

#NoEnv
#NoTrayIcon
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1

File_URL := "https://github.com/JANGOON-No89/JG_AHK/raw/main/SciTE4Ahk%20Unofficial%20Patch/SciTE4AutoHotkey%20Unofficial%20Patch.exe"
scite := GetSciTEInstance()

if !scite
	ExitApp

CheckFile := scite.UserDir "\tools\$UPDATE"
if (FileExist(CheckFile))
{
	FileRead, val, % CheckFile
	if (val = 0)
	{
		MsgBox, 52, Unofficial Patch Update, % "이전에 업데이트를 다운로드 하였지만`, 완료되지 않았습니다.`n"
																			. "다시 업데이트를 하시겠습니까?`n`n"
																			. "업데이트를 완료하였음에도 이 메세지가 반복될 경우 제작자에게 문의 바랍니다."
		IfMsgBox, Yes
			Run, % scite.UserDir "\tools\SciTE4AutoHotkey Unofficial Patch.exe"
		ExitApp
	}
	else
}

if (scite.ResolveProp("patch.updates") = 1)
{
	FileRead, Current_ver, % scite.UserDir "\$PATCHVER"
	Elements := Get_Elements("https://github.com/JANGOON-No89/JG_AHK/releases")
	if (Elements != "")
	{
		RegExMatch(Elements, ">[\n\s]*(v[0-9.]*)[\n\s]*<", Releases_ver) ? Releases_ver := Releases_ver1 : false
		if (Current_ver != Releases_ver)
		{
			MsgBox, 36, Unofficial Patch Update, 비공식 패치의 새 버전이 있습니다.`n지금 업데이트 하시겠습니까?
			IfMsgBox, Yes
			{
				URLDownloadToFile, %File_URL%, % scite.UserDir "\tools\SciTE4AutoHotkey Unofficial Patch.exe"
				if errorlevel = 0
				{
					FileAppend, 1, % scite.UserDir "\tools\$UPDATE"
					Run, % scite.UserDir "\tools\SciTE4AutoHotkey Unofficial Patch.exe"
					ExitApp
				}
				else
					MsgBox, 16, ERROR, 파일 다운로드에 실패하여 업데이트를 연기합니다.
			}
		}
	}
}
ExitApp

Get_Elements(var) {
	try
	{
		p := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		p.Open("GET",var)
		p.Send()
		p.WaitForResponse()
		return p.ResponseText 
	}
	catch
		return
}
