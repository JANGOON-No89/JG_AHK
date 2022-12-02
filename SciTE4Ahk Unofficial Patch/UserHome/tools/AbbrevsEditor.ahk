;
; UnofficialPatch - Abbrevs Editor
;

#NoEnv
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

Text := [["Abbrevs Editor", "약어 편집기"], ["Add Abbrev", "약어 추가"]
			, ["Modify Abbrev", "약어 변경"], ["Delete Abbrev", "약어 삭제"], ["Apply", "적용"]
			, ["* You can add or delete abbreviations by right-clicking the list on the left."
				, "* 좌측 리스트를 우클릭하여 약어를 추가, 삭제할 수 있습니다."]
			, ["* If you do not click Apply after editing the abbreviation, it will not be saved, so be sure to click Apply."
				, "* 약어 편집 후 적용을 누르지 않으면 저장되지 않으므로, 반드시 적용을 눌러주세요."]
			, ["* Added abbreviations can be expanded by pressing Ctrl + B in the editor."
				, "* 추가된 약어는 에디터에서 Ctrl + B 키를 눌러 확장할 수 있습니다." ]
			, ["That abbreviation already exists!", "이미 존재하는 약어입니다."]
			, ["Invalid abbreviation.`nThe abbreviation must not contain an equal sign (=) or begin with a sharp (#) character."
				, "유효하지 않은 약어입니다.`n약어는 등호(=)가 포함되거나 첫글자가 샵문자(#)로 시작하면 안됩니다."]]

scite := GetSciTEInstance()
Language := InStr(scite.ResolveProp("locale.properties"), "한국어") ? 2 : 1
AbbrevsFile := scite.UserDir "\AhkAbbrevs.properties" 
if (!scite || !FileExist(AbbrevsFile))
{
	MsgBox, 16, Error, Can Not Found Scite Editor!
	ExitApp
}

FileRead, var, % AbbrevsFile
Data := {}
Loop, Parse, var, `r`n
	if (RegExMatch(A_LoopField, "^([\w ]*)=([^\R]*)", Match))
		Data[Match1] := Match2

Menu, MyMenu, Add, % Text.2[Language], Item_Add
Menu, MyMenu, Add, % Text.3[Language], Item_Modify
Menu, MyMenu, Add, % Text.4[Language], Item_Del

Gui, Margin, 10, 10
Gui, Add, ListBox, w100 h200 vList gListBox, % GetList(Data)
Gui, Add, Edit, x+10 yp w400 hp ReadOnly WantTab T8 vEditBox
Gui, Add, Button, x+10 yp w60 hp vSubmitButton gSubmit , % Text.5[Language]
GuiControl, Disable, SubmitButton
Gui, Add, Text, xm , % Text.6[Language]
Gui, Add, Text, xm , % Text.7[Language]
Gui, Add, Text, xm , % Text.8[Language]
Gui, Show, , % Text.1[Language]
OnMessage(0x205, "RBCL")
State := false

Gui, 2: Margin, 10, 10
Gui, 2: Add, Edit, w200 h20 vItemName
Gui, 2: Add, Button, ym-1 w80 h22 Default gApply, % Text.5[Language]
Gui, 2: +AlwaysOnTop

return

GuiClose:
ExitApp
return

ListBox:
if (!State)
{
	State := true
	GuiControl, -ReadOnly, EditBox
	GuiControl, Enable, SubmitButton
}
GuiControlGet, Abbrevs, , % A_GuiControl
GuiControl, , EditBox, % Validation(Data[Abbrevs], 0)
return

Submit:
GuiControlGet, Extend, , EditBox
Data[Abbrevs] := Validation(Extend)
FileDelete, % AbbrevsFile
FileAppend, % Convert(Data), % AbbrevsFile, UTF-8
scite.ReloadProps()
return

Apply:
GuiControlGet, Item, , ItemName
if (!Item)
	return
if (Data.HasKey(Item))
{
	MsgBox, 4112, Error, % Text.9[Language]
	return
}
if (Item ~= "^#|=")
{
	MsgBox, 4112, Error, % Text.10[Language]
	return
}
Gui, 2: Hide
if Modify
	Data[Item] := Data[SelectItem], Data.Delete(SelectItem)
else
	Data[Item] := ""
GuiControl, 1:, List, % "|" GetList(Data)
GuiControl, 1: Choose, List, % Item
GuiControl, 1:, EditBox, % Validation(Data[Item], 0)
if !Modify
	GuiControl, 1: Focus, EditBox
Abbrevs := Item
FileDelete, % AbbrevsFile
FileAppend, % Convert(Data), % AbbrevsFile, UTF-8
return

Item_Add:
Modify := false
GuiControl, 2:, ItemName
Gui, 2: Show, , % Text.1[Language]
GuiControl, 2: Focus, ItemName
return

Item_Modify:
Modify := true
Gui, 2: Show, , % Text.1[Language]
GuiControl, 2: Focus, ItemName
return

Item_Del:
Data.Delete(SelectItem)
GuiControl, 1:, List, % "|" GetList(Data)
FileDelete, % AbbrevsFile
FileAppend, % Convert(Data), % AbbrevsFile, UTF-8
return

RBCL() {
	global SelectItem
	MouseGetPos, , , , Ctr
	if (InStr(Ctr, "ListBox"))
	{
		MouseClick, L
		GuiControlGet, SelectItem, , List
		GuiControl, 2:, ItemName, % SelectItem
		Menu, MyMenu, Show
	}
}

GetList(Arr) {
	for i, v in Arr
		text .= i "|"
	return Trim(text, "|")
}

Validation(Text, State := true) {
	return State ? StrReplace(StrReplace(Text, "`t", "\t"), "`n", "\n") : StrReplace(StrReplace(Text, "\t", "`t"), "\n", "`n")
}

Convert(Arr) {
	Text =
(
# User abbreviations file for SciTE4AutoHotkey
#
# You are encouraged to edit this file!
#


)
	for i, v in Arr
		Text .= i . "=" . v "`r`n"
	return Text
}