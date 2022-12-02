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
		MsgBox, 52, Unofficial Patch Update, % "������ ������Ʈ�� �ٿ�ε� �Ͽ�����`, �Ϸ���� �ʾҽ��ϴ�.`n"
																			. "�ٽ� ������Ʈ�� �Ͻðڽ��ϱ�?`n`n"
																			. "������Ʈ�� �Ϸ��Ͽ������� �� �޼����� �ݺ��� ��� �����ڿ��� ���� �ٶ��ϴ�."
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
			MsgBox, 36, Unofficial Patch Update, ����� ��ġ�� �� ������ �ֽ��ϴ�.`n���� ������Ʈ �Ͻðڽ��ϱ�?
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
					MsgBox, 16, ERROR, ���� �ٿ�ε忡 �����Ͽ� ������Ʈ�� �����մϴ�.
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
