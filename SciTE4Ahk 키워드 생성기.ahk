;~ ##################################################
;~ Developed by 잔군
;~ ##################################################

#NoEnv
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
Process, Priority, , H
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
SetTitleMatchMode, 2

;~ ##################################################
;~ 경로 및 설정파일 확인
;~ ##################################################

Base_Path := A_MyDocuments "\AutoHotkey\SciTE"
if (!isFile(Base_Path "\_config.properties"))
	Base_Path := A_ScriptDir
Loop
{
	if (isFile(Base_Path "\_config.properties"))
		break
	else
	{
		MsgState := false
		MsgBox, 17, Error!, 경로를 찾을 수 없습니다!`n`n확인을 눌러서 SciTE 폴더를 직접 선택해주세요.`n기본 경로는 내 문서\AutoHotkey\SciTE 입니다.`n`n취소를 누르면 프로그램이 종료됩니다.
		IfMsgBox, OK
			MsgState := true
		if (!MsgState)
			ExitApp
		FileSelectFolder, Base_Path
	}
}

Api_File := Base_Path "\user.ahk.api"
Prop_File := Base_Path "\SciTEUser.properties"
Backup_Path := Base_Path "\Keyword_Backup"

if (!isDir(Backup_Path))
	FileCreateDir, % Backup_Path

if (!isFile(Api_File))
	FileAppend, , % Api_File, UTF-8-RAW

if (!isFile(Prop_File))
{
	Prop_Base =
(
# User initialization file for SciTE4AutoHotkey
#
# You are encouraged to edit this file!
#

# Import the platform-specific settings
import _platform

# Import the settings that can be edited by the bundled properties editor
import _config

# Add here your own settings

)
	FileAppend, % Prop_Base, % Prop_File
}

FileRead, Prop_txt, % Prop_File
Loop, 7
{
	if (!InStr(Prop_txt, "user.keywords" A_Index "=\"))
	{
		Index := A_Index = 1 ? "" : A_Index
		FileAppend, % "user.keywords" A_Index "=\`n`nkeywords" Index ".$(file.patterns.ahk)=$(ahk.keywords" Index ") $(user.keywords" A_Index ")`n`n", % Prop_File
	}
}

;~ ##################################################
;~ Gui 설정
;~ ##################################################

Gui, Margin, 10, 10
Gui, Add, Text, xm , 키워드 :	ex) zfill
Gui, Add, Edit, w400 vKeyword , 
Gui, Add, Text, , 툴팁 :	ex) (Number [, Length = 3])
Gui, Add, Edit, w400 h50 WantTab t8 vExplan , 
Gui, Add, Button, w100 h30 gPreview , 미리보기
Gui, Add, Button, x+10 yp wp hp gApply , 적용
Gui, Add, Button, x310 yp wp hp gCancel , 취소
Gui, Add, Radio, x+10 ym w80 vType , 컨트롤
Gui, Add, Radio, wp y+8 , 명령
Gui, Add, Radio, wp y+8 Checked , 함수
Gui, Add, Radio, wp y+8 , 지시문
Gui, Add, Radio, wp y+8 , 키, 버튼
Gui, Add, Radio, wp y+8 , 내장변수
Gui, Add, Radio, wp y+8 , 키워드
Gui, Add, Button, wp h22 gHelp , Help
Gui, Add, Text, x225 y150 w80 Center, Developed by`n잔군

Api_List := []
Loop, % Backup_Path "\*.api"
{
	if (RegExMatch(A_LoopFileName, "^(\d{14}_.*?)\.api", Match))
	{
		Api_List.InsertAt(1, Match1)
		Lasted_File := Match1
	}
}
if (Api_List.Length())
{
	for i, v in Api_List
	{
		if (i >8)
			break
		Menu, RollBack_Items, Add, % v, Sel_File
	}	
}
else
{
	Menu, RollBack_Items, Add, 백업파일 없음, Sel_File
	Menu, RollBack_Items, Disable, 백업파일 없음
}
Menu, RollBack_Menu, Add, 선택 파일로 복원, :RollBack_Items
Menu, RollBack_Menu, Add, 최근 파일로 복원, Sel_Lasted
if (!Api_List.Length())
	Menu, RollBack_Menu, Disable, 최근 파일로 복원
Menu, Menubar, Add, 복원, :RollBack_Menu
Gui, Menu, Menubar

Gui, Show, , SciTe4Ahk 키워드 생성기
State := false
return

Cancel:
GuiClose:
ExitApp
return

;~ ##################################################
;~ 미리보기용 Gui 설정
;~ ##################################################

Preview_Gui:
FileRead, Ahk_Config, % Base_Path "\_config.properties"
if (RegExMatch(Ahk_Config, "import (Styles\\.*?\.style)", Match))
	Style_File := Base_Path "\" Match1 ".properties"

if (Style_File)
{
	FileRead, Ahk_Style, % Style_File
	Style_Text := RegExMatch(Ahk_Style, "style\.\*\.32=(.*)", Match) ? Match1 : ""
	
	if (Style_Text)
	{
		Base_BG := RegExMatch(Style_Text, "back:#(.{6})", Match) ? Match1 : "FFFFFF"
		Base_Font := RegExMatch(Style_Text, "font:(.*?)(,|$)", Match) ? Match1 : ""
		if (Base_Font = "$(default.text.font)")
			Base_Font := RegExMatch(Ahk_Style, "default\.text\.font=(.*)", Match) ? Match1 : "Courier New"
		Base_Styles := Get_Styles(Style_Text)
	}
	else
		Base_Styles := ["c000000", "10", "", ""]
	
	This_Styles := Parse_Style(Type, Ahk_Style)
	Side_Styles := Parse_Side(Type, Ahk_Style)
	
	Style_Option := ""
	for i, v in This_Styles
		Style_Option .= v ? v : Base_Styles[i]
	
	Side_Option := ""
	for i, v in Side_Styles
		Side_Option .= v ? v : Base_Styles[i]
}
else
	Style_Set_HOG()

Gui, 2: Margin, 20, 20
Gui, 2: Font, % Side_Option, % Base_Font
Gui, 2: Add, Text, % Type = 6 ? "" : "w0", % Type = 6 ? "%" : ""
Gui, 2: Font, Norm
Gui, 2: Font, % Style_Option, % Base_Font
Gui, 2: Add, Text, x+0 yp , % Keyword
Gui, 2: Font, Norm
Gui, 2: Font, % Side_Option, % Base_Font
switch Type
{
	case 2:
		Gui, 2: Add, Text, x+0 yp , % ", "
	case 3:
		Gui, 2: Add, Text, x+0 yp , % "()"
	case 5:
		Gui, 2: Add, Text, x+0 yp , % "::"
	case 6:
		Gui, 2: Add, Text, x+0 yp , % "%"
}
Gui, 2: Color, % Base_BG
Gui, 2: -Caption
Gui, 2: Show, w400 h100
ToolTip, % Keyword StrReplace(Explan, "`t", "    "), 20, 36
return

;~ ##################################################
;~ 메뉴 버튼 작용
;~ ##################################################

Sel_File:
Target_File := A_ThisMenuItem
Sel_State := true
gosub, RollBack
return

Sel_Lasted:
Target_File := Lasted_File
gosub, RollBack
return

RollBack:
MsgState := false
if not (isFile(Backup_Path "\" Target_File ".api") && isFile(Backup_Path "\" Target_File ".properties"))
{
	MsgBox, 16, Error!, 복원에 실패하였습니다.`n선택 키워드의 api 파일 혹은 properties 파일이 없습니다.
	return
}
MsgBox, 36, Question, % SubStr(Target_File, 16) " 키워드를 추가하기 전으로 복원하겠습니까?"
IfMsgBox, Yes
{
	if (Sel_State)
	{
		MsgBox, 52, Question, 해당 키워드보다 나중에 추가된 키워드는 모두 제거됩니다.`n정말 복원하겠습니까?
		IfMsgBox, Yes
			MsgState := true
		if (!MsgState)
			return
	}
	FileMove, % Backup_Path "\" Target_File ".api", % Api_File, 1
	FileMove, % Backup_Path "\" Target_File ".properties", % Prop_File, 1
	if (Sel_State)
	{
		Target_Tick := SubStr(Target_File, 1, 14)
		for i, v in Api_List
		{
			if (Target_Tick <= SubStr(v, 1, 14))
			{
				FileDelete, % Backup_Path "\" v ".api"
				FileDelete, % Backup_Path "\" v ".properties"
			}
		}
	}
	MsgBox, 설정이 복원되었습니다.
	Reload
}
Target_File := ""
return

;~ ##################################################
;~ Gui 버튼 작용
;~ ##################################################

Preview:
Gui, Submit, Nohide
if (State)
{
	ToolTip
	Gui, 2: Destroy
	State := false
}
else
{
	if (Keyword != "")
	{
		gosub, Preview_Gui
		State := true
	}
	
}
return

Apply:
Gui, Submit, Nohide
MsgState := false
if (!Keyword)
{
	MsgBox, 키워드가 입력되지 않았습니다.
	return
}
if (!Explan)
{
	MsgBox, 52, Caution!, 설명이 없습니다.`n이대로 저장하시겠습니까?
	IfMsgBox, Yes
		MsgState := true
	if (!MsgState)
		return
}
else
	Explan := RegExMatch(Explan, "^[^, (]") ? " " Explan : Explan
Now := A_Now
FileCopy, % Api_File, % Backup_Path "\" Now "_" Keyword ".api"
Api_txt := Keyword . StrReplace(StrReplace(Explan, "`t", "    "), "`n", "\n") . "`n"
FileAppend, % Api_txt, % Api_File
FileRead, Prop_txt, % Prop_File
Prop_txt := StrReplace(Prop_txt, "user.keywords" Type "=\`r`n", "user.keywords" Type "=\`r`n" Keyword " ")
FileMove, % Prop_File, % Backup_Path "\" Now "_" Keyword ".properties"
FileAppend, % Prop_txt, % Prop_File
WinGet, var, , SciTE4AutoHotkey
MsgBox, % var ? "적용되었습니다.`n에디터 재실행시 적용됩니다." : "적용되었습니다."
Reload
return

Help:
if (State)
	ToolTip
else
{
	TipText =
	(
컨트롤 : return, break, ExitApp 등

명령 : MsgBox, GuiControl, FileAppend 등

함수 : InStr(), RegExMatch(), ComObjCreate() 등

지시문 : #If, #Include, #NoEnv 등

키, 버튼 : LButton, F12, PGDN 등

내장변수 : A_Index, A_LoopField, A_WorkingDir 등

키워드 : ahk_id, text, Checked 등

** 미리보기를 누르면 스타일을 확인할 수 있습니다 **
	)
	ToolTip, % TipText, 150, 20
}
State := !State
return

~LButton::
if (State)
{
	Gui, 2: Destroy
	ToolTip
	State := false
}
return

;~ ##################################################
;~ 사용자 정의 함수
;~ ##################################################

isFile(path) {
	FileGetAttrib, This_Att, % path
	return !ErrorLevel
}

isDir(path) {
	FileGetAttrib, This_Att, % path
	return InStr(This_Att, "D")
}

Parse_Side(Index, txt) {
	switch Index
	{
		case 2, 5:
			pos := RegExMatch(txt, "(style\.ahk1\.4|s4ahk\.style\.operator)=(.*)", Match) ; 2=명령 , || 5=버튼 ::
		case 3:
			pos := RegExMatch(txt, "(style\.ahk1\.5|s4ahk\.style\.operator)=(.*)", Match) ; 함수 ()
		case 6:
			pos := RegExMatch(txt, "(style\.ahk1\.9|s4ahk\.style\.operator)=(.*)", Match) ; 내장변수 %%
			if (InStr(Match2, "$(style.ahk1.8)"))
				Match2 := StrReplace(Match2, "$(style.ahk1.8)", RegExMatch(txt, "style\.ahk1\.8=(.*)", SubMatch) ? SubMatch1 : "")
	}
	return pos ? Get_Styles(Match2) : ["", "", "", ""]
}

Parse_Style(Index, txt) {
	switch Index
	{
		case 1:
			pos := RegExMatch(txt, "(style\.ahk1\.11|s4ahk\.style\.flow)=(.*)", Match)
		case 2:
			pos := RegExMatch(txt, "(style\.ahk1\.12|s4ahk\.style\.bif)=(.*)", Match)
		case 3:
			pos := RegExMatch(txt, "(style\.ahk1\.13|s4ahk\.style\.func)=(.*)", Match)
		case 4:
			pos := RegExMatch(txt, "(style\.ahk1\.14|s4ahk\.style\.directive)=(.*)", Match)
		case 5:
			pos := RegExMatch(txt, "(style\.ahk1\.15|s4ahk\.style\.old\.key)=(.*)", Match)
		case 6:
			pos := RegExMatch(txt, "(style\.ahk1\.16|s4ahk\.style\.biv)=(.*)", Match)
		case 7:
			pos := RegExMatch(txt, "(style\.ahk1\.17|s4ahk\.style\.wordop)=(.*)", Match)
	}
	return pos ? Get_Styles(Match2) : ["", "", "", ""]
}

Get_Styles(txt) {
	Styles := []
	Styles.push(RegExMatch(txt, "fore:#(.{6})", Match) ? "c" Match1 " " : "")
	Styles.push(RegExMatch(txt, "size:(\d*)", Match) ? "s" Match1 " " : "")
	Styles.push(InStr(txt, "bold") ? "bold " : "")
	Styles.push(InStr(txt, "italics") ? "italic " : "")
	return Styles
}

Style_Set_HOG() {
	global
	switch Type
	{
		case 1:
			Style_Option := "cA6E22E s10 bold italic"
		case 2:
			Style_Option := "cF79B57 s10 bold"
		case 3:
			Style_Option := "c7CC8CF s10 italic"
		case 4:
			Style_Option := "c7CC8CF s10 bold italic"
		case 5:
			Style_Option := "cCB8DD9 s10 bold"
		case 6:
			Style_Option := "cFF2679 s10 bold italic"
		case 7:
			Style_Option := "cFFE000 s10"
	}
	Base_BG := "000000"
	Base_Font := "Bitstream Vera Sans Mono"
}

