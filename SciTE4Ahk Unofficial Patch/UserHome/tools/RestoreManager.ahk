;
; UnofficialPatch - Script Restore Manager
;

#NoEnv
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

scite := GetSciTEInstance()
target = %1%

if (!scite || !target)
{
	SoundPlay, *16
	ExitApp
}

LocalSciTEPath := scite.UserDir
UserPropsFile := LocalSciTEPath "\_config.properties"
FileRead, UserProps, %UserPropsFile%
bkstate := RegExMatch(UserProps, "make\.backup=([01])", Match) ? Match1 : 0

bkpath := scite.ResolveProp("SciteUserHome") "\backup\"
rep_target := StrReplace(StrReplace(target, ":\", ".."), "\", ".") . "_"

bklist := []
Loop, % bkpath . rep_target . "*", 0
	bklist[SubStr(A_LoopFileName, -17, 14)] := A_LoopFileFullPath

Gui, Margin, 10, 10
Gui, Add, Button, xm w710 h50 gRestore, 복원
Gui, Add, TreeView, w120 h500 gTV AltSubmit
Gui, Add, Edit, x+10 yp w580 hp T8 -Wrap +HScroll vED
Gui, Add, Checkbox, % "xm w710 Right vBackupState gCB " . (bkstate ? "Checked" : ""), % "파일 저장시 백업파일을 생성합니다"

lastdate := 0, Pn := 0
Parents := []
for i in bklist
{
	date := SubStr(i, 1, 8)
	if (date != lastdate)
		Pn++, Parents.push(TV_Add(Day(date))), lastdate := date, Cn := 1
	if (date = lastdate)
		TV_Add(Time(i), Parents[Pn]), Cn++
}
Gui, Show, , Restore Manager
return

TV:
if A_GuiEvent = Normal
{
	bkfile := bkpath . rep_target . GetFilename(A_EventInfo) . ".bak"
	FileRead, var, % bkfile
	if !errorlevel
		GuiControl, , ED, % var
}
return

CB:
GuiControlGet, val, , BackupState
UserProps := RegExReplace(UserProps, "(make\.backup=)([01])", "$1" . val, , 1)
FileDelete, % UserPropsFile
FileAppend, % UserProps, % UserPropsFile, UTF-8
scite.ReloadProps()
return

Restore:
scite.Message("0x111", "106")
FileCopy, % bkfile, % target, 1
scite.Message("0x111", "104")
return

GuiClose:
ExitApp
return

TV_Text(ID) {
	TV_GetText(var, ID)
	return var
}

GetFilename(ID) {
	return StrReplace(TV_Text(TV_GetParent(ID)), ".") . StrReplace(TV_Text(ID), ":")
}

Time(num) {
	return SubStr(num, 9, 2) . ":" . SubStr(num, 11, 2) . ":" . SubStr(num, 13, 2)
}

Day(num) {
	return SubStr(num, 1, 4) . "." . SubStr(num, 5, 2) . "." . SubStr(num, 7, 2)
}