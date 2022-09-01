;~ ##################################################
;~ ***** Developed by 잔군 . JANGOON *****
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
FileEncoding, UTF-8

;~ ##################################################
;~ ***** 경로 확인 . Scite path check *****
;~ ##################################################

Base_Path := A_MyDocuments "\AutoHotkey\SciTE"
if (!FileExist(Base_Path "\_config.properties"))
	Base_Path := A_ScriptDir
Loop
{
	if (FileExist(Base_Path "\_config.properties"))
		break
	else
	{
		MsgState := false
		MsgBox, 17, Error!, % "경로를 찾을 수 없습니다!`n`n"
											. "확인을 눌러서 SciTE 폴더를 직접 선택해주세요.`n"
											. "기본 경로는 내 문서\AutoHotkey\SciTE 입니다.`n`n"
											. "취소를 누르면 프로그램이 종료됩니다.`n`n`n"
											. "Could not find the path.`n`n"
											. "Click OK to manually select Scite folder.`n"
											. "The default path is My Documents\AutoHotkey\SciTE`n`n"
											. "Click Cancel to exit the program."
		IfMsgBox, OK
			MsgState := true
		if (!MsgState)
			ExitApp
		FileSelectFolder, Base_Path
	}
}

;~ ##################################################
;~ ***** 이용자 수 집계 . User Count *****
;~ ##################################################

CountURL := "http://jgstyler.ivyro.net/public.php"
if (!FileExist(Base_Path "\$STYLER"))
	URLDownloadToFile, %CountURL%, % Base_Path "\$STYLER"

;~ ##################################################
;~ ***** 객체 생성 . Create Object *****
;~ ##################################################

Options := [["설정", "Propertie"], ["전경색", "Fore Color"], ["배경색", "Back Color"], ["글꼴", "Font Style"], ["크기", "Size"]]

Buttons := [["새로 만들기", "New File"], ["불러오기", "Open to..."], ["현재 스타일`n불러오기", "Open`nCurrent style"]
					, ["미리보기", "Preview"], ["취소", "Cancel"], ["저장", "Save"], ["적용", "Apply"]]

Others := [["기본값", "Default"], ["없음", "None"], ["제작자`n잔군", "Developed by`nJANGOON"], ["영문번역`n압살맨", "Translated by`nApsalman"]]

Messages := [["주의", "Exclamation"], ["변경된 사항이 있습니다. 이를 저장하지 않고 파일을 불러오겠습니까?", "There are changes. Are you sure you want to load the file without save?"]
						, ["파일이 이미 있습니다.", "File already exists"], ["파일을 덮어쓰겠습니까?", "Do you want to overwrite it?"]
						, ["스타일 적용", "Apply style"], ["SciTE의 스타일을 이 스타일로 적용하겠습니까?", "Would you like to apply SciTE's style to this?"]
						, ["저장되었습니다.", "Saved"], ["적용되었습니다.", "Applied"]
						, ["사용할 수 없는 파일명입니다.", "Invalid file name"], ["에디터의 현재 스타일", "Editor's current style"]
						, ["에디터를 찾을 수 없습니다. SciTE4AutoHotkey 에디터를 실행 후 다시 시도해주세요.", "cant found editor."]]

EditorStyles := [new Settings(["에디터 설정", "Editor Base"], ["style.*.32"]
												, ["에디터의 기본 스타일", "The basic style of the editor"], 0, 0, 0)
							, new Settings(["일반 글자", "Common Text"], ["style.ahk1.0", "s4ahk.style.default"]
													, ["스타일이 적용되지 않는 평범한 글자의 스타일", "Styles of common texts that do not apply styles"])
							, new Settings(["줄 번호", "Line Number"], ["style.*.33"]
													, ["에디터 좌측에 표시되는 줄 번호의 스타일과 배경색", "The style and background color of the line number displayed on the left of the editor"], , , 0)
							, new Settings(["에러메세지", "Console Style"], ["style.errorlist.32"]
													, ["커맨드라인(F8)의 배경색과 에러 메세지의 스타일", "Background color of the command line(console) (F8) and the style of error messages"])
							, new Settings(["출력메세지", "Console Message"], ["style.errorlist.4"]
													, ["커맨드라인(F8)의 출력되는 메세지의 스타일", "The style of the console message(output) of the command line(console) (F8)"])]

EditorColors := [new Settings(["캐럿 색", "Caret"], ["caret.fore"]
													, ["캐럿(키보드 커서)의 색깔", "Caret color"])
							, new Settings(["현재 줄 색", "Current Line"], ["caret.line.back"]
													, ["캐럿이 위치한 줄의 배경색", "Background color of the row where the caret located"])
							, new Settings(["선택영역 글자색", "Selection Fore"], ["selection.fore"]
													, ["선택 영역(드래그)의 글자색", "The text color of the selection area"])
							, new Settings(["선택영역 배경색", "Selection Back"], ["selection.back"]
													, ["선택 영역(드래그)의 배경색", "Background color of selection area"])
							, new Settings(["접기 강조", "Fold Highlight"], ["fold.highlight.colour"]
													, ["캐럿이 위치한 접기(폴드)를 강조할 색상", "The color to highlight the folding where the caret located"])
							, new Settings(["접기 영역", "Fold Margin"], ["fold.margin.colour", "fold.margin.highlight.colour"]
													, ["접기 영역의 배경 색상 (줄 번호 영역과 편집영역 사이)", "Background color in the folding margin (between the line number area and the editorial area)"])
							, new Settings(["들여쓰기 표시", "Indent Line"], ["style.*.37"]
													, ["들여쓰기를 표시하는 탭 라인", "Tab line that displays indentation"])]

KeywordStyles := [new Settings(["라벨", "Label"], ["style.ahk1.10", "s4ahk.style.label"]
														, ["GuiClose, GuiDropFiles 등의 이벤트 라벨과 GoSub, SetTimer 등에서 사용하는 사용자 정의 라벨"
															, "Event labels such as GuiClose, GuiDropFiles and Custom labels used in Gosub, SetTimer, Etc"])
								, new Settings(["컨트롤 명령", "Flow Control"], ["style.ahk1.11", "s4ahk.style.flow"]
														, ["Pause, ExitApp, if 등의 컨트롤 명령", "Flow control such as Pause, ExitApp, if, etc."])
								, new Settings(["명령문", "Command"], ["style.ahk1.12", "s4ahk.style.bif"]
														, ["MsgBox, GuiControl, FileAppend 등의 전통식 명령", "Legacy commands such as Msgbox, GuiControl, FileAppend, etc."])
								, new Settings(["함수", "Function"], ["style.ahk1.13", "s4ahk.style.func"]
														, ["InStr(), RegExMatch(), ComObjCreate() 등의 내장 함수", "Built-in functions such as InStr(), RegExMatch(), ComObjCreate(), etc."])
								, new Settings(["지시문", "Directive"], ["style.ahk1.14", "s4ahk.style.directive"]
														, ["#if, #Include, #NoEnv 등의 지시문", "Directive such as #if, #Include, #NoEnv, etc."])
								, new Settings(["키 && 버튼", "Key && Button"], ["style.ahk1.15", "s4ahk.style.old.key"]
														, ["LButton, F12 등의 키 버튼", "KeyButtons on Keyboards, Mice and Controllers such as LButtno, F12, etc."])
								, new Settings(["정의 키워드", "Param Keyword"], ["style.ahk1.17", "s4ahk.style.wordop"]
														, ["ahk_id, submit, this 등의 에디터에 정의된 키워드", "Param Keywords in editors such as ahk_id, SubMit, this, etc."])
								, new Settings(["내장변수", "Built-in var"], ["style.ahk1.16", "s4ahk.style.biv"]
														, ["A_Index, A_LoopField, A_WorkingDir 등의 내장변수", "Built-in variables such as A_Index, A_LoopField, A_WorkingDir, etc."])
								, new Settings(["역참조 내장변수", "Built-in var Deref"], ["style.ahk1.19", "s4ahk.style.biv"]
														, ["%A_xxxx% 와 같은 전통식 역참조 내장변수", "Legacy dereference built-in variables like %A_xxxx%"])
								, new Settings(["사용자 키워드", "Define Keyword"], ["style.ahk1.18", "s4ahk.style.old.user"]
														, ["사용자가 임의로 추가한 키워드", "Keywords added by users"])
								, new Settings(["주석", "Line Comment"], ["style.ahk1.1", "s4ahk.style.comment.line"]
														, ["세미콜론으로 시작하는 주석", "The comments defined by `; Semicolon"])
								, new Settings(["영역 주석", "Block Comment"], ["style.ahk1.2", "s4ahk.style.comment.block"]
														, ["/* */ 에 둘러쌓인 영역 주석", "The block comments surrounded by /* */"])
								, new Settings(["탈출문자", "Escape Word"], ["style.ahk1.3", "s4ahk.style.escape"]
														, ["``n, ``r, ``t 등과 같이 그레이브( `` )가 붙은 탈출문자", "Escape words with a grave(``) such as ``n, ``r, ``t, etc."])
								, new Settings(["불완전 괄호", "Incomplete Brace"], ["style.*.35", "style.*.35"]
														, ["쌍이 없는 괄호", "Incomplete parentheses"])
								, new Settings(["괄호쌍 강조", "Brace Highlight"], ["style.*.34", "style.*.34"]
														, ["캐럿(커서)이 위치한 괄호와 쌍을 이루는 괄호", "The parentheses fonts in pair with the parentheses where the caret(keyboard cursor) positioned"])
								, new Settings(["연산기호", "Operator Sign"], ["style.ahk1.5", "s4ahk.style.operator"]
														, ["+ - = 등의 단독 연산기호와 대괄호[]와 소괄호()", "Single operators such as + - = and [ brackets ], ( parentheses )"])
								, new Settings(["표현식 연산자", "Expression Operator"], ["style.ahk1.4", "s4ahk.style.operator"]
														, [":= += 등의 할당 연산자와 전통식 역참조 선언(%%)과 구분자인 반점( , )", "The Assignment operators such as := + - = and the defined of legacy dereference (%%) and the distinctive spots(,)"])
								, new Settings(["문자열", "String"], ["style.ahk1.6", "s4ahk.style.string"]
														, ["쌍따옴표에 둘러쌓인 문자열", "String surrounded by double quotes"])
								, new Settings(["숫자", "Number"], ["style.ahk1.7", "s4ahk.style.number"]
														, ["글자와 붙어있지 않은 숫자", "Numbers that are not attached to letters"])
								, new Settings(["동적 키워드", "Dynamic Keyword"], ["style.ahk1.8", "s4ahk.style.var"]
														, ["Test%A_Index% 와 같이 전통식 역참조 선언을 포함하는 동적 키워드", "Dynamic keywords with legacy dereference definations like Test%A_Index%"])
								, new Settings(["역참조 변수", "Deref var"], ["style.ahk1.9", "s4ahk.style.var"]
														, ["%MyTest% 와 같이 전통식 역참조 선언에 쓰인 내장변수가 아닌 변수", "Variables that are not built-in variables used in the legacy dereference defination like %MyTest%"])
								, new Settings(["오류 문자", "Error Word"], ["style.ahk1.20", "s4ahk.style.error"]
														, ["닫히지 않은 문자열과 같이 형식이 맞지 않은 오류 문자", "Malformed error word like unclosed strings"])]

FontObj := ListFonts()
FontFirst := [["기본값", "에디터 설정값"], ["Default", "Inherit Base"]]
FontList := GetFontFamilys(FontObj)
FontObj.Insert("Default", "기본값")
FontObj.Insert("Inherit Base", "에디터 설정값")

;~ ##################################################
;~ ***** 기본 설정 . Base Setting *****
;~ ##################################################

Language := 1
FileRead, Config, % Base_Path "\_config.properties"
SciteStyle := RegExMatch(Config, "import Styles\\(.+?)\.style", Match) ? Match1 : ""
CurrentStyle := "New Style"
SciTE_Path := "C:\Program Files\AutoHotkey\SciTE\SciTE.exe"
OnMessage(0x200, "Hover")

;~ ##################################################
;~ ***** 메인 Gui 설정 . Set Main Gui *****
;~ ##################################################

Gui, Margin, 10, 10
Gui, Add, Text, xm+5 w120 Section Center vOptions1, % Options[1][Language]
Gui, Add, Text, ys w80 Center vOptions2, % Options[2][Language]
Gui, Add, Text, ys wp Center vOptions3, % Options[3][Language]
Gui, Font, Bold
Gui, Add, Text, x+13 ys w25 Center, B
Gui, Font, Norm Italic
Gui, Add, Text, ys wp Center, I
Gui, Font, Norm Underline
Gui, Add, Text, ys wp Center, U
Gui, Font, Norm
Gui, Add, Text, x+16 ys w100 Center vOptions4, % Options[4][Language]
Gui, Add, Text, ys w40 Center vOptions5, % Options[5][Language]
Gui, Add, Radio, x+18 ys w42 Checked vLanguage gSetLang, KOR
Gui, Add, Radio, ys wp gSetLang, ENG

for i, v in EditorStyles
{
	Gui, Add, Text, % (i = 1 ? "y+10 " : "") "xm+5 w120 h20 Section +0x201 vop1_" i "_Text", % v.getText(Language)
	Gui, Add, TreeView, % "ys w80 hp AltSubmit gColorSelector vop1_" i "_Fore"
	Gui, Add, Text, % "xp yp wp hp +0x201 BackgroundTrans vop1_" i "_ForeNot", % Others[1][Language]
	Gui, Add, TreeView, % "ys wp hp AltSubmit gColorSelector vop1_" i "_Back"
	Gui, Add, Text, % "xp yp wp hp +0x201 BackgroundTrans vop1_" i "_BackNot", % Others[2][Language]
	Gui, Add, Checkbox, % "x+20 ys+4 w25 gChkBox vop1_" i "_Bold" . (v.B ? "" : " Hidden")
	Gui, Add, Checkbox, % "ys+4 wp gChkBox vop1_" i "_Italic" . (v.I ? "" : " Hidden")
	Gui, Add, Checkbox, % "ys+4 wp gChkBox vop1_" i "_Underline" . (v.U ? "" : " Hidden")
	Gui, Add, TreeView, % "ys w100 h20 AltSubmit vop1_" i "_Font_Box gFontBox"
	Gui, Add, Text, % "xp+5 yp wp-5 hp BackgroundTrans +0x200 vop1_" i "_Font", % FontFirst[Language][i = 1 ? 1 : 2]
	Gui, Add, Edit, % "ys w40 Center Number vop1_" i "_Size gSizeBox"
	Gui, Add, UpDown, Range0-99
}

for i, v in KeywordStyles
{
	Gui, Add, Text, % (i = 1 || i = 11 ? "y+15 " : "y+10 ") "xm+5 w120 Section +0x201 h20 vop2_" i "_Text", % v.getText(Language)
	Gui, Add, TreeView, % "ys w80 h20 AltSubmit gColorSelector vop2_" i "_Fore"
	Gui, Add, Text, % "xp yp wp hp +0x201 BackgroundTrans vop2_" i "_ForeNot", % Others[1][Language]
	Gui, Add, TreeView, % "ys wp h20 AltSubmit gColorSelector vop2_" i "_Back"
	Gui, Add, Text, % "xp yp wp hp +0x201 BackgroundTrans vop2_" i "_BackNot", % Others[2][Language]
	Gui, Add, Checkbox, % "x+20 ys+4 w25 gChkBox vop2_" i "_Bold"
	Gui, Add, Checkbox, % "ys+4 wp gChkBox vop2_" i "_Italic"
	Gui, Add, Checkbox, % "ys+4 wp gChkBox vop2_" i "_Underline"
	Gui, Add, TreeView, % "ys w100 h20 AltSubmit vop2_" i "_Font_Box gFontBox"
	Gui, Add, Text, % "xp+5 yp wp-5 hp BackgroundTrans +0x200 vop2_" i "_Font", % FontFirst[Language][2]
	Gui, Add, Edit, % "ys w40 Center -Wrap Number vop2_" i "_Size gSizeBox"
	Gui, Add, UpDown, Range0-99
}

for i, v in EditorColors
{
	Gui, Add, Text, % (i = 1 ? "x+15 ym+175 " : "y+10 ") "w100 Center Section vop3_" i "_Text", % v.getText(Language)
	Gui, Add, TreeView, % "xp y+1 wp h20 AltSubmit vop3_" i "_Fore gColorSelector"
	Gui, Add, Text, % "xp yp wp hp +0x201 BackgroundTrans vop3_" i "_ForeNot", % Others[1][Language]
}

Gui, Add, Text, xs y492 w100 h30 Center vDeveloped, % Others[3][Language]
Gui, Add, Text, xs +10 wp hp Center vTranslated, % Others[4][Language]

Gui, Add, Button, xs ym+21 wp h44 Section vBTN1 gNewFile, % Buttons[1][Language]
Gui, Add, Button, xs y+5 wp hp vBTN2 gOpenTo, % Buttons[2][Language]
Gui, Add, Button, xs y+5 wp hp vBTN3 gStyleOpen, % Buttons[3][Language]

Gui, Add, Button, xp y655 wp h50 vBTN4 gPreview, % Buttons[4][Language]
Gui, Add, Button, xp y+0 wp h30 vBTN5 gPreview, % Buttons[5][Language]
Gui, Add, Button, xp y+10 wp h100 vBTN6 gSaveFile, % Buttons[6][Language]

Gui, Add, GroupBox, x598 ym+10 w115 h161 cBlack
Gui, Add, GroupBox, xp y+-8 wp h313 cBlack
Gui, Add, GroupBox, xp y+-8 wp h375 cBlack

Gui, Add, GroupBox, xm ym+10 w590 h161 cBlack
Gui, Add, GroupBox, xm y+-8 wp h313 cBlack
Gui, Add, GroupBox, xm y+-8 wp h375 cBlack

Gui, Add, StatusBar

Gui, +HwndMainHwnd
Gui, Show, , SciTE4AutoHotkey Style Editor - New Style
EditLog := false
return

;~ ##################################################
;~ ***** Gui 종료 . Gui Close *****
;~ ##################################################

Detector:
IfWinNotActive, ahk_id %Selector%
{
	IfWinExist, ahk_id %Selector%
		Gui, 2: Destroy
	SetTimer, Detector, Off
}
return

~ESC::
SetTimer, Detector, Off
Gui, 2: Destroy
return

GuiClose:
if (PreviewState)
{
	FileDelete, % Base_Path "\_config.properties"
	FileAppend, % Config, % Base_Path "\_config.properties"
	scite := GetSciTEInstance()
	scite.ReloadProps()
}
ExitApp
return

;~ ##################################################
;~ ***** 한/영 언어 토글 . Kor/Eng Language Toggle *****
;~ ##################################################

SetLang:
Gui, 1: Submit, Nohide
GuiControlGet, Language
Language := Language ? 1 : 2
for i, v in Options
	GuiControl, , % "Options" i, % v[Language]
for i, v in Buttons
	GuiControl, , % "BTN" i, % v[Language]
for n, obj in [EditorStyles, KeywordStyles, EditorColors]
{
	for i, v in obj
	{
		GuiControl, , % "op" n "_" i "_Text", % v.getText(Language)
		GuiControl, , % "op" n "_" i "_ForeNot", % Others[1][Language]
		GuiControl, , % "op" n "_" i "_BackNot", % Others[2][Language]
		
		FontControl := "op" n "_" i "_Font"
		GuiControlGet, FontName, , %FontControl%
		GuiControl, , % "op" n "_" i "_Font", % Language = 1 ? FontObj[FontName] : GetFontKR(FontName)
	}
}
GuiControl, , Developed, % Others[3][Language]
GuiControl, , Translated, % Others[4][Language]
return

;~ ##################################################
;~ ***** 파일 생성 & 불러오기 . Create & Load to File *****
;~ ##################################################

OpenTo:
Gui, 2: Destroy
Gui, 2: Margin, 10, 10
Gui, 2: Font, S11
Gui, 2: Add, Text, w470 h50 +0x201, % Messages[10][Language] " : " SciteStyle
Gui, 2: Add, GroupBox, xm ym-4 w470 h50 cBlack
Gui, 2: Font, S9
Loop, % Base_Path "\Styles\*.style.properties", 0
	Gui, 2: Add, Button, % (Mod(A_Index - 1, 3) = 0 ? "xm" : "x+10 yp") " w150 h35 vItem" A_Index " gStyleOpen", % SubStr(A_LoopFileName, 1, InStr(A_LoopFileName, ".style.properties") - 1)
Gui, 2: +HwndSelector
Gui, 2: Show, , File open to...
SetTimer, Detector, 100
return

StyleOpen:
GuiControlGet, SelectStyle, , % A_GuiControl
SelectStyle := InStr(A_GuiControl, "BTN") ? SciteStyle : SelectStyle
FileRead, Properties, % Base_Path "\Styles\" SelectStyle ".style.properties"
Gui, 2: Destroy

while(RegExMatch(Properties, "\$\((.+?)\)", Match))
{
	Match_Prop := RegExReplace(Match1, "[\.\*]", "\$0")
	Match_Option := RegExMatch(Properties, Match_Prop "=(.*)", subMatch) ? subMatch1 : ""
	Properties := StrReplace(Properties, Match, Match_Option)
}

if (SubStr(Properties, 3, 16) = "User Custom Style")
	PropType := 1
else
{
	if (InStr(Properties, "s4ahk.style"))
		PropType := 2
	else
		PropType := 1
}

NewFile:
if (EditLog)
{
	MsgBox, 52, % Messages[1][Language], % Messages[2][Language]
	IfMsgBox, No
	{
		Properties := ""
		return
	}
}
Load := true
for n, obj in [EditorStyles, KeywordStyles, EditorColors]
{
	for i, v in obj
	{
		RegExMatch(Properties, "\n" RegExReplace(v.getType(PropType), "(\.|\*)", "\$1") "=(.*)", Match)
		v.setProp(Match1)
		
		ChangeColor(v, "op" n "_" i "_Fore")
		ChangeColor(v, "op" n "_" i "_Back")
		GuiControl, 1:, % "op" n "_" i "_Bold", % v.Styles.Bold
		GuiControl, 1:, % "op" n "_" i "_Italic", % v.Styles.Italic
		GuiControl, 1:, % "op" n "_" i "_Underline", % v.Styles.Underline
		GuiControl, 1:, % "op" n "_" i "_Size", % v.Styles.Size
		
		propFont := v.Styles.Font
		if (FontObj.HasKey(propFont))
			GuiControl, 1:, % "op" n "_" i "_Font", % Language = 2 ? propFont : FontObj[propFont]
		else
		{
			GuiControl, 1:, % "op" n "_" i "_Font", % n * i = 1 ? FontFirst[Language][1] : FontFirst[Language][2]
			v.Styles.Font := ""
		}
	}
}
Gui, 1: Show, , % "SciTE4AutoHotkey Style Editor - " . CurrentStyle := A_GuiControl = "BTN1" ? "New Style" : SelectStyle
Properties := "", EditLog := false, Load := false
return

;~ ##################################################
;~ ***** 스타일 미리보기 . Preview edit style *****
;~ ##################################################

Preview:
switch A_GuiControl
{
	case "BTN4":
		FileDelete, % Base_Path "\Styles\Temp.style.properties"
		FileAppend, % GetProperties(), % Base_Path "\Styles\Temp.style.properties"
		FileDelete, % Base_Path "\_config.properties"
		FileAppend, % RegExReplace(Config, "import (Styles\\.+?\.style)", "import Styles\Temp.style"), % Base_Path "\_config.properties"
		PreviewState := true
	case "BTN5":
		if (!PreviewState)
			return
		FileDelete, % Base_Path "\Styles\Temp.style.properties"
		FileDelete, % Base_Path "\_config.properties"
		FileAppend, % Config, % Base_Path "\_config.properties"
		PreviewState := false
}
scite := GetSciTEInstance()
if (scite)
	scite.ReloadProps()
else
{
	if (FileExist(SciTE_Path))
		Run, % SciTE_Path
	else
		MsgBox, 48, , % Messages[11][Language]
}
return

;~ ##################################################
;~ ***** 스타일 저장 . Save edit style *****
;~ ##################################################

SaveFile:
if (CurrentStyle = "New Style")
{
	Gui, 2: Destroy
	Gui, 2: Margin, 10, 10
	Gui, 2: Add, Edit, w100 h20 Right vSaveName
	Gui, 2: Add, Text, x+0 hp +0x201, .style.properties
	Gui, 2: Add, Button, xm w100 Section Default gSaveConfirm, % Buttons[6][Language]
	Gui, 2: Add, Button, ys wp gSaveCancel, % Buttons[5][Language]
	Gui, 2: +HwndSelector -SysMenu +AlwaysOnTop
	Gui, 2: Show, , % Buttons[4][Language]
	WinWaitClose, ahk_id %Selector%
	if (SaveName != "")
	{
		if (AlreadyFile(SaveName))
		{
			MsgBox, 36, % Messages[3][Language], % Messages[4][Language]
			IfMsgBox, Yes
				FileDelete, % Base_Path "\Styles\" CurrentStyle ".style.properties"
			else
				goto, SaveFile
		}
		else if (SaveName = "Temp")
		{
			MsgBox, 16, Error!, % Messages[9][Language]
			goto, SaveFile
		}
		FileAppend, % GetProperties(), % Base_Path "\Styles\" SaveName ".style.properties"
		if (ErrorLevel = 1)
		{
			MsgBox, 16, Error!, % Messages[9][Language]
			goto, SaveFile
		}
		Gui, 1: Show, , % "SciTE4AutoHotkey Style Editor - " . CurrentStyle := SaveName
	}
	else
		return
}
else
{
	FileDelete, % Base_Path "\Styles\" CurrentStyle ".style.properties"
	FileAppend, % GetProperties(), % Base_Path "\Styles\" CurrentStyle ".style.properties"
}
EditLog := false
MsgBox, % Messages[7][Language]

if (SciteStyle != CurrentStyle)
{
	MsgBox, 36, % Messages[5][Language], % Messages[6][Language]
	IfMsgBox, Yes
	{
		Config := RegExReplace(Config, "import Styles\\(.+?)\.style", "import Styles\" CurrentStyle ".style")
		FileDelete, % Base_Path "\_config.properties"
		FileAppend, % Config, % Base_Path "\_config.properties"
		SciteStyle := CurrentStyle
		scite := GetSciTEInstance()
		scite.ReloadProps()
		PreviewState := false
		MsgBox, % Messages[8][Language]
	}
}
else
{
	scite := GetSciTEInstance()
	scite.ReloadProps()
}
return

SaveCancel:
GuiControl, , SaveName
SaveConfirm:
GuiControlGet, SaveName
Gui, 2: Destroy
return

; ##################################################
; ***** 색상 선택 . Color Select *****
; ##################################################

ColorSelector:
if A_GuiEvent = Normal
{
	Gui, 2: Destroy
	ParseObj(A_GuiControl)
	This_Color := %This_Object%[This_Prop].Styles[This_Option]

	if (This_Color = "")
		This_Color := "ffffff", This_RGB := [255, 255, 255]
	else
		This_RGB := Hex2RGB(This_Color, false)
	for i, v in ["Red", "Green", "Blue"]
	{
		Gui, 2: Add, Text, xm y+5 w40 h25 +0x202 Section, % v
		Gui, 2: Add, Edit, % "w40 h20 +Center Number Limit3 vval" v " gRGBInput", % This_RGB[i]
		Gui, 2: Add, Slider, % "x+0 ys w277 h25 AltSubmit TickInterval32 Page32 Thick18 Range0-255 Buddy2val" v " vbar" v " gColorSlider", % This_RGB[i]
	}
	Gui, 2: Add, Progress, % "x+50 ym+1 w60 h60 Border +Background" This_Color " vColorPreview"
	Gui, 2: Add, Edit, w60 +Center Limit6 vHexColor gHexInput, % This_Color
	Gui, 2: Add, Button, ym w80 h88 vcSubmit gSelector_Submit, % Buttons[7][Language]
	Gui, 2: Add, Button, x+8 yp wp h40 vcNil gSelector_Submit, % This_Option = "Fore" ? Others[1][Language] : Others[2][Language]
	Gui, 2: Add, Button, y+8 wp hp vSelector_Cancel gSelector_Cancel, % Buttons[5][Language]
	Gui, 2: +HwndSelector +AlwaysOnTop -SysMenu
	Gui, 2: Show, h100, % "  " %This_Object%[This_Prop].getText(Language) . " - " . (This_Option = "Fore" ? Options[2][Language] : Options[3][Language])
	ControlFocus, Edit4, ahk_id %Selector%
	SetTimer, Detector, 100
}
return

Selector_Submit:
Gui, 2: Submit, Nohide
%This_Object%[This_Prop].Styles[This_Option] := A_GuiControl = "cSubmit" ? HexColor : ""
ChangeColor(%This_Object%[This_Prop], This_Control)
EditLog := true
Selector_Cancel:
Gui, 2: Destroy
return

ColorSlider:
ColorName := SubStr(A_GuiControl, 4)
GuiControl, 2:, % "val" ColorName, % %A_GuiControl%
This_Color := RGB2Hex(valRed, valGreen, valBlue)
GuiControl, 2:, HexColor, % This_Color
GuiControl, % "+Background" This_Color, ColorPreview
return

RGBInput:
Gui, 2: Submit, Nohide
ControlGetFocus, var
if var in Edit1,Edit2,Edit3
{
	if (SubStr(%A_GuiControl%, 1, 1) = 0)
	{
		GuiControl, 2:, % %A_GuiControl%, % LTrim(%A_GuiControl%, "0")
		SendInput, {End}
	}
	if (%A_GuiControl% > 255)
	{
		GuiControl, 2:, % %A_GuiControl%, 255
		SendInput, {End}
	}
	switch var
	{
		case "Edit1":
			GuiControl, 2:, barRed, % valRed
		case "Edit2":
			GuiControl, 2:, barGreen, % valGreen
		case "Edit3":
			GuiControl, 2:, barBlue, % valBlue
	}
	This_Color := RGB2Hex(valRed, valGreen, valBlue)
	GuiControl, 2:, HexColor, % This_Color
	GuiControl, % "+Background" This_Color, ColorPreview
}
return

HexInput:
ControlGetFocus, var
if var = Edit4
{
	GuiControlGet, HexColor, , HexColor
	HexColor := RegExReplace(HexColor, "[^0-9a-fA-F]+", "", Cnt)
	if (Cnt != 0)
	{
		GuiControl, 2:, HexColor, % HexColor
		SendInput, {End}
	}
	HexLen := StrLen(HexColor)
	if (HexLen < 6)
		HexColor := SubStr(HexColor "000000", 1, 6)
	RGBCode := Hex2RGB(HexColor, false)
	GuiControl, % "+Background" HexColor, ColorPreview
	GuiControl, 2:, valRed, % RGBCode[1]
	GuiControl, 2:, barRed, % RGBCode[1]
	GuiControl, 2:, valGreen, % RGBCode[2]
	GuiControl, 2:, barGreen, % RGBCode[2]
	GuiControl, 2:, valBlue, % RGBCode[3]
	GuiControl, 2:, barBlue, % RGBCode[3]
}
return

;~ ##################################################
;~ ***** 글자 스타일 B.U.I 설정 . Set font B.U.I style *****
;~ ##################################################

ChkBox:
ParseObj(A_GuiControl)
GuiControlGet, val, , % A_GuiControl
%This_Object%[This_Prop].Styles[This_Option] := val
EditLog := true, val := ""
return

;~ ##################################################
;~ ***** 글꼴 설정 . Set font family *****
;~ ##################################################

FontBox:
if A_GuiEvent = Normal
{
	WinGetPos, WinX, WinY, , , ahk_id %MainHwnd%
	ControlGetFocus, ThisNN, ahk_id %MainHwnd%
	ControlGetPos, CtrX, CtrY, , CtrH, %ThisNN%, ahk_id %MainHwnd%
	ThisControl := SubStr(A_GuiControl, 1, StrLen(A_GuiControl) - 4)
	GuiControlGet, val, , % ThisControl
	ParseObj(A_GuiControl)
	Font_FirstItem := (This_Object = "EditorStyles" && This_Prop = 1 ? FontFirst[Language][1] : FontFirst[Language][2]) . "|"

	Gui, 2: Destroy
	Gui, 2: Add, ListBox, x0 y0 w200 r12 vSelectFont gFontListBox, % Font_FirstItem . FontList[Language]
	Gui, 2: +HwndSelector -Caption
	GuiControl, 2: Choose, SelFont, % val
	Gui, 2: Show, % "x" WinX + CtrX " y" WinY + CtrY + CtrH " w200 h148"

	SetTimer, Detector, 100
}
return

FontListBox:
GuiControlGet, SelectFont
GuiControl, 1:, % ThisControl, % SelectFont
SelectFont := InheritFont(SelectFont) ? "" : SelectFont
%This_Object%[This_Prop].Styles.Font := Language ? GetFontKR(SelectFont) : SelectFont
Gui, 2: Destroy
SetTimer, Detector, Off
EditLog := true, SelectFont := ""
return

;~ ##################################################
;~ ***** 글자 크기 설정 . Set font size *****
;~ ##################################################

SizeBox:
if (Load)
	return
ParseObj(A_GuiControl)
GuiControlGet, val, , % A_GuiControl
GuiControl, , % A_GuiControl, % val ? (val > 99 ? val := 99 : val) : val := ""
%This_Object%[This_Prop].Styles.Size := val
EditLog := true, val := ""
return

; ##################################################
; ***** 클래스 . Class *****
; ##################################################

class Settings
{
	__New(Text, Prop, Tip, op1 = true, op2 = true, op3 = true)
	{
		this.Text := Text
		this.Prop := Prop
		this.Tip := Tip
		this.B := op1
		this.I := op2
		this.U := op3
	}
	
	getText(lang) {
		return this.text[lang]
	}
	
	getType(style) {
		return this.Prop[style] ? this.Prop[style] : this.Prop[1]
	}
	
	getTip(lang) {
		return this.Tip[lang]
	}

	setProp(prop := "") {
		this.Styles := new Setter(prop)
	}

	getProp() {
		return "# " . this.Text[2] . "`n" . this.Prop[1] . "="
							. Trim((this.Styles.Fore != "" ? "fore:#" this.Styles.Fore "," : "")
									. (this.Styles.Back != "" ? "back:#" this.Styles.Back "," : "")
									. ((this.B && this.Styles.Bold) ? "bold," : "")
									. ((this.I && this.Styles.Italic) ? "italics," : "")
									. ((this.U && this.Styles.Underline) ? "underlined," : "")
									. (this.Styles.Font ? "font:" this.Styles.Font "," : "")
									. (this.Styles.Size ? "size:" this.Styles.Size : ""), ",") . "`n`n"
	}

	getColor(pair) {
		if (this.Styles.Fore)
			return "# " . this.Text[2] . "`n" . this.Prop[1] . "=#" . this.Styles.Fore . (pair ? "`n" this.Prop[2] . "=#" . this.Styles.Fore : "") . "`n`n"
		else
			return "# " . this.Text[2] . "`n" . this.Prop[1] . "=" . (pair ? "`n" this.Prop[2] . "=" . : "") . "`n`n"
	}
}

class Setter
{
	__New(prop)
	{
		this.Fore := RegExMatch(prop, "^#(\w{6})", match) ? match1 : RegExMatch(prop, "fore:#(\w{6})", match) ? match1 : ""
		this.Back := RegExMatch(prop, "back:#(\w{6})", match) ? match1 : ""
		this.Bold := InStr(prop, "bold") ? true : false
		this.Italic := InStr(prop, "italics") ? true : false
		this.Underline := InStr(prop, "underlined") ? true : false
		this.Font := RegExMatch(prop, "font:(.*?)(,|$)", match) ? match1 : ""
		this.Size := RegExMatch(prop, "size:(\d+)", match) ? match1 : ""
	}
}

; ##################################################
; ***** 사용자 정의 함수 . User Define Function *****
; ##################################################

GetProperties()
{
	global EditorStyles, KeywordStyles, EditorColors
	
	Comment := "# User Costom Style`n"
						. "# Edit From SciTE4AutoHotkey Style Editor`n"
						. "# Developed by JANGOON`n`n`n`n"

	Properties := ""
	for _, obj in [EditorStyles, KeywordStyles]
		for i, v in obj
			Properties .= v.getProp()
	for i, v in EditorColors
		Properties .= i = 7 ? v.getProp() : v.getColor(i = 6)
	Loop, Parse, Properties, `n
	{
		if (A_Index = 2)
		{
			If (!InStr(A_LoopField, "font:"))
				Properties := StrReplace(Properties, A_LoopField, A_LoopField . ",font:")
			break
		}
	}

	OthersProp := "# .ini and .properties files`n"
						. "style.props.0=$(style.ahk1.0)`n"
						. "style.props.1=$(style.ahk1.1)`n"
						. "style.props.2=$(style.ahk1.10)`n"
						. "style.props.3=$(style.ahk1.5)`n"
						. "style.props.5=$(style.ahk1.8)"
	return Comment . Properties . OthersProp
}

ParseObj(Control) {
	global This_Control, This_Object, This_Prop, This_Option
	This_Control := Control
	This_Prop := RegExMatch(This_Control, "op(\d+)_(\d+)_(\w+)", Match) ? Match2 : ""
	This_Object := Match1 = 1 ? "EditorStyles" : Match1 = 2 ? "KeywordStyles" : "EditorColors"
	This_Option := Match3
}

AlreadyFile(name) {
	global Base_Path
	Loop, % Base_Path "\Styles\*.style.properties", 0
	{
		if (A_LoopFileName = name ".style.properties")
			return true
	}
	return false
}

Hover() {
	global Language
	MouseGetPos, , , , var
	GuiControlGet, ctr, name, %var%
	CtrGroup := SubStr(ctr, 1, 2)
	switch CtrGroup
	{
		case "op":
			onProp := RegExMatch(ctr, "op(\d+)_(\d+)", Match) ? Match2 : ""
			onObject := Match1 = 1 ? "EditorStyles" : Match1 = 2 ? "KeywordStyles" : "EditorColors"
			SB_SetText(%onObject%[onProp].getTip(Language))
		default:
			SB_SetText("")
	}
}

ChangeColor(obj, ctr)
{
	Prop := SubStr(ctr, -3)
	GuiControl, 1: Hide, % ctr
	if (obj.Styles[Prop] != "")
	{
		GuiControl, % "1: +Background" obj.Styles[Prop], % ctr	
		GuiControl, 1: Show, % ctr
		GuiControl, 1: Hide, % ctr "Not"
	}
	else
	{
		GuiControl, 1: +BackgroundFFFFFF, % ctr
		GuiControl, 1: Show, % ctr
		GuiControl, 1: Show, % ctr "Not"
	}
}

GetFontKR(name)
{
	global FontObj
	for i, v in FontObj
	{
		if (v = name)
			return i
	}
	return ""
}

InheritFont(Font)
{
	global Language, FontFirst
	for i, v in FontFirst[Language]
	{
		if (v = Font)
			return true
	}
	return false
}

GetFontFamilys(obj) {
	korobj := [], 	engobj := []
	for i, v in obj
	{
		engs .= "|" . i
		RegExMatch(v, "[ㄱ-ㅎ가-힣]") ? korobj[v] := i : engobj[v] := i
	}
	for i, v in korobj
		kors .= "|" . i
	for i, v in engobj
		kors .= "|" . i
	return [Trim(kors, "|"), Trim(engs, "|")]
}

ListFonts() {
	gdipToken := Gdip_Startup()
	VarSetCapacity(logfont, 128, 0), NumPut(1, logfont, 23, "UChar")
	obj := []
	DllCall("EnumFontFamiliesEx", "ptr", DllCall("GetDC", "ptr", 0), "ptr", &logfont, "ptr", RegisterCallback("EnumFontProc"), "ptr", &obj, "uint", 0)
	Gdip_Shutdown(gdipToken)
	return obj
}

EnumFontProc(lpFont, tm, fontType, lParam) {
	static LF_FACESIZE := 32*(a_isUnicode ? 2 : 1)
	obj := Object(lParam)
	lfFaceName := StrGet(lpFont+28, LF_FACESIZE)
	try {
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "str", lfFaceName, "uint", 0, "uptrp", hfamily)
		VarSetCapacity(familyName, 512)
		if (DllCall("gdiplus\GdipGetFamilyName", "ptr", hfamily, "str", familyName, "ushort", 1033) != 0)
			throw
		obj[familyName] := lfFaceName
	} catch {
	} finally {
		DllCall("gdiplus\GdipDeleteFontFamily", "uptr", hfamily)
	}
	return 1
}

Gdip_Startup() {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
	return pToken
}

Gdip_Shutdown(pToken) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
	DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
		DllCall("FreeLibrary", Ptr, hModule)
	return 0
}

GetSciTEInstance() {
	olderr := ComObjError()
	ComObjError(false)
	scite := ComObjActive("{D7334085-22FB-416E-B398-B5038A5A0784}")
	ComObjError(olderr)
	return IsObject(scite) ? scite : ""
}

Hex2RGB(hex, str = true) {
	if (str)
		return format("{1:u}, {2:u}, {3:u}", "0x" SubStr(hex, 1, 2), "0x" SubStr(hex, 3, 2), "0x" SubStr(hex, 5, 2))
	else
		return [format("{1:u}", "0x" SubStr(hex, 1, 2)), format("{1:u}", "0x" SubStr(hex, 3, 2)), format("{1:u}", "0x" SubStr(hex, 5, 2))]
}

RGB2Hex(r, g, b) {
	return format("{1:02x}{2:02x}{3:02x}", r, g, b)
}
