;
; SciTE4AutoHotkey Unofficial Patch
; Developed by JANGOON on 2022.12.02
; Blog : https://jg-no89.tistory.com/
; GitHub : https://github.com/JANGOON-No89/JG_AHK
;

#Persistent
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

FileCreateDir, %A_Temp%\SciTE_UnofficalPatch\LocalHome
FileCreateDir, %A_Temp%\SciTE_UnofficalPatch\UserHome\backup
FileCreateDir, %A_Temp%\SciTE_UnofficalPatch\UserHome\Settings
FileCreateDir, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\Lib
FileCreateDir, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\Banner

FileInstall, LocalHome\ahk.api, %A_Temp%\SciTE_UnofficalPatch\LocalHome\ahk.api, 1
FileInstall, LocalHome\ahk.keywords.properties, %A_Temp%\SciTE_UnofficalPatch\LocalHome\ahk.keywords.properties, 1
FileInstall, LocalHome\ahk.lua, %A_Temp%\SciTE_UnofficalPatch\LocalHome\ahk.lua, 1
FileInstall, LocalHome\toolicon.icl, %A_Temp%\SciTE_UnofficalPatch\LocalHome\toolicon.icl, 1

FileInstall, UserHome\Autorun.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\Autorun.ahk, 1
FileInstall, UserHome\define_func.properties, %A_Temp%\SciTE_UnofficalPatch\UserHome\define_func.properties, 1
FileInstall, UserHome\$PATCHVER, %A_Temp%\SciTE_UnofficalPatch\UserHome\PATCHVER, 1
FileInstall, UserHome\SciTEUser.properties, %A_Temp%\SciTE_UnofficalPatch\UserHome\SciTEUser.properties, 1
FileInstall, UserHome\UserLuaScript.lua, %A_Temp%\SciTE_UnofficalPatch\UserHome\UserLuaScript.lua, 1
FileInstall, UserHome\UserToolbar.properties, %A_Temp%\SciTE_UnofficalPatch\UserHome\UserToolbar.properties, 1

FileInstall, UserHome\Settings\PatchLog.ini, %A_Temp%\SciTE_UnofficalPatch\UserHome\Settings\PatchLog.ini, 1
FileInstall, UserHome\tools\Lib\GetSciTEInstance.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\Lib\GetSciTEInstance.ahk, 1
FileInstall, UserHome\tools\Banner\ScitePatchBanner.png, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\Banner\ScitePatchBanner.png, 1
FileInstall, UserHome\tools\AbbrevsEditor.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\AbbrevsEditor.ahk, 1
FileInstall, UserHome\tools\AutoCSet.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\AutoCSet.ahk, 1
FileInstall, UserHome\tools\AutoUpdate.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\AutoUpdate.ahk, 1
FileInstall, UserHome\tools\ColorAssistant.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\ColorAssistant.ahk, 1
FileInstall, UserHome\tools\HLColorSelector.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\HLColorSelector.ahk, 1
FileInstall, UserHome\tools\HotkeyAssistant.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\HotkeyAssistant.ahk, 1
FileInstall, UserHome\tools\KeywordCreator.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\KeywordCreator.ahk, 1
FileInstall, UserHome\tools\OldBakRemover.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\OldBakRemover.ahk, 1
FileInstall, UserHome\tools\PatchLog.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\PatchLog.ahk, 1
FileInstall, UserHome\tools\PropUpdate.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\PropUpdate.ahk, 1
FileInstall, UserHome\tools\RestoreManager.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\RestoreManager.ahk, 1
FileInstall, UserHome\tools\RestoreOrigin.ahk, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\RestoreOrigin.ahk, 1
FileInstall, UserHome\tools\StyleEditor.exe, %A_Temp%\SciTE_UnofficalPatch\UserHome\tools\StyleEditor.exe, 1

paramCheck = %1%
if (A_IsAdmin && paramCheck = "")
{
	MsgBox, 4144, Scite Not Exist, % "이 패치는 관리자 권한이 없는 상태에서 에디터의 정보를 확인 후 관리자 권한으로 재실행하여 패치를 진행하는 구조입니다.`n`n"
															. "관리자 권한 없이 다시 패치를 진행해주세요."
	ExitApp
}

if not A_IsAdmin
{
	Scite := GetSciTEInstance()
	if !Scite
	{
		MsgBox, 4144, Scite Not Exist, % "패치를 진행하기 위해선 SciTE4AutoHotkey 에디터가 실행되어있어야 합니다.`n`n"
																. "에디터 실행 후 확인 버튼을 눌러주세요."
		Loop
		{
			Scite := GetSciTEInstance()
			if (Scite)
				break
			MsgBox, 4145, Scite Not Exist, % "SciTE4AutoHotkey 에디터가 실행되지 않았습니다.`n"
																. "에디터 실행 후 다시 확인 버튼을 눌러주세요.`n`n"
																. "에디터가 실행됐음에도 이 메세지가 반복될 경우 취소 버튼을 누르고 제작자에게 문의 바랍니다."
			IfMsgBox, Cancel
			{
				Run, % "https://jg-no89.tistory.com/"
				ExitApp
			}
		}
	}
	
	if (Scite.IsPortable || RegExReplace(StrReplace(Scite.Version, "."), "(\d)(\d+)", "$1.$2") > 3.00601)
	{
		MsgBox, 16, Patch Error, 이 패치는 최신버전 or 무설치 버전에서는 사용할 수 없습니다.`n죄송합니다.
		ExitApp
	}
	
	p1 := Scite.SciTEDir, p2 := Scite.UserDir, p3 := Scite.ResolveProp("highlight.current.word")
	, p4 := Scite.ResolveProp("highlight.current.word.colour"), p5 := Scite.ResolveProp("Indicators.alpha")
	, p6 := Scite.ResolveProp("style.*.32"), p7 := Scite.ResolveProp("style.ahk1.0")

	MsgBox, 48, is not Admin, % "에디터에서 필요한 정보가 확인되었습니다.`n패치 진행을 위해 확인을 누른 후 관리자 권한을 허용해주세요."
	Run, *RunAs "%A_ScriptFullPath%" "%p1%" "%p2%" "%p3%" "%p4%" "%p5%" "%p6%" "%p7%"
	ExitApp
}

SciteDefaultHome = %1%
SciteUserHome = %2%
UsersHLSet = %3%
UsersHLColor = %4%
UsersHLTrans = %5%
SciteBaseStyle = %6%
SciteTextStyle = %7%

FileCreateDir, %SciteDefaultHome%\PatchBackup\LocalHome
FileCreateDir, %SciteDefaultHome%\PatchBackup\UserHome\backup
FileCreateDir, %SciteDefaultHome%\PatchBackup\UserHome\Settings
FileCreateDir, %SciteDefaultHome%\PatchBackup\UserHome\tools\Lib
FileCreateDir, %SciteDefaultHome%\PatchBackup\UserHome\tools\Banner

FileCreateDir, %SciteUserHome%\backup
FileCreateDir, %SciteUserHome%\Settings
FileCreateDir, %SciteUserHome%\tools\Lib
FileCreateDir, %SciteUserHome%\tools\Banner

CountURL := "http://jgstyler.ivyro.net/unoffpatch.php"
if (!FileExist(SciteUserHome "\$PATCHVER"))
	URLDownloadToFile, %CountURL%, %A_Temp%\SciTE_UnofficalPatch\$PATCH

CheckFile := SciteUserHome "\tools\$UPDATE"
if (FileExist(CheckFile))
{
	FileDelete, % CheckFile
	FileAppend, 0, % CheckFile
}

PreviewHLColor := [0, 255, 0, 150], PreviewHLHex := "00ff00"
if (UsersHLSet != "")
{
	if (UsersHLColor != "")
		UsersHLRGB := Hex2RGB(SubStr(UsersHLColor, 2), false), PreviewHLHex := SubStr(UsersHLColor, 2)
		, PreviewHLColor[1] := UsersHLRGB[1], PreviewHLColor[2] := UsersHLRGB[2], PreviewHLColor[3] := UsersHLRGB[3]
	if (UsersHLTrans != "")
		PreviewHLColor[4] := UsersHLTrans
}
PreviewStyle := PropStyle, PreviewStyle.Overlap(SciteBaseStyle), PreviewStyle.Overlap(SciteTextStyle)
PreviewBG := PreviewStyle.GetBG(), PreviewFont := PreviewStyle.GetFont()

AnnounceText := [["잔군의 SciTE4AutoHotkey 비공식 패치를 다운로드해 주셔서 감사합니다."
									, "패치를 적용하기에 앞서, 몇가지 안내말의 확인해야 할 사항이 있습니다."
									, "되도록이면 각 항목을 모두 읽은 후 다음을 눌러주시길 바랍니다."]
								, ["1. 이 패치는 최소한의 디버깅을 마쳤을 뿐, 무결점으로 완성되지 않았습니다."
									, "때문에 제작자가 생각하지 못한 방식으로 에디터를 운용할 경우 오류가 발생할 수 있습니다."
									, "오류가 확인될 경우 업데이트가 진행될 수 있으며, 이 때 모든 설정 작업을 다시 진행해야 할 수 있습니다."
									, "또한 패치로 추가됐던 기능이 안정성 문제로 제거되어 더 이상 쓸 수 없게 될 수도 있습니다."]
								, ["2. 이 패치는 몇가지 설정파일을 제작자가 만든 파일로 덮어씌우는 방식입니다."
									, "때문에 귀하가 내부파일(lua, properties 등)의 설정을 변경했다면 해당 설정은 적용이 취소됩니다."
									, "패치 진행시 자동으로 백업파일을 생성하도록 했으나, 알 수 없는 오류로 백업이 되지 않을 수도 있습니다."
									, "이를 방지하기 위해, 귀하가 내부파일을 변경했다면 다음을 누르기 전 백업을 진행해 주십시오."]
								, ["3. 이 패치는 영문 코딩을 기본 전제로 만들어졌습니다."
									, "때문에 한글을 사용한 코딩시에는 몇몇 기능이 오류를 일으켜 출력창에 에러 메세지가 표시되기도 하고,"
									, "엉뚱한 기능이 실행되거나, 글자가 두세번씩 중복으로 입력되는 등의 증상이 나타날 수 있습니다."
									, "또한, 이는 한글 이외에도 일본어, 중국어, 러시아어 등. 영어를 제외한 모든 언어에 공통적인 사항입니다."
									, "이를 숙지하셨다면 다음을 눌러 설정을 진행해주십시오."]
								, ["4. 이 패치를 통해 단어의 자동완성 기능이 확장됩니다."
									, "이로 인해 기존에 등록된 키워드 뿐만 아니라, 문서 내에서 입력된 모든 단어가 자동완성으로 표시됩니다."
									, "자동완성에 포함될 최소 글자수는 기본적으로 3글자이며, 아래의 설정으로 기준값을 변경할 수 있습니다."
									, "또한 이 값은 도구 메뉴에 추가되는 [자동완성 글자수 변경] 으로 언제든 수정 가능합니다. "]
								, ["5. 이 패치를 통해 에디터에 선택 단어 강조 기능이 추가됩니다."
									, "이 기능은 사용자가 선택한 단어 혹은 캐럿(키보드 커서)이 위치한 단어와 중복된 단어들에 박스를 씌워서"
									, "변수나 함수가 쓰인곳을 검색기능 없이 쉽게 확인할 수 있도록 하는 기능입니다."
									, "색상 설정값은 아래의 미리보기로 확인 가능하며, 이 기능의 설정을 마치면 비공식 패치가 적용됩니다."]
								, ["패치를 적용중입니다. 이 작업은 수 초 내로 완료됩니다."
									, "패치가 완료되면 아래의 마침 버튼이 활성화 됩니다."]
								, ["패치가 완료되었습니다."
									, "에디터를 재실행하면 패치가 적용되며,"
									, "에디터 실행시 패치내역을 확인할 수 있습니다."]]

Page := 1
GuiCreate:
Gui, Margin, 10, 10
Gui, Add, GroupBox, y4 w640 h180 cBlack vGroupBox1
Gui, Add, GroupBox, xm y+-8 w640 h210 cBlack vGroupBox2
Gui, Add, Picture, x20 y20, % A_Temp "\SciTE_UnofficalPatch\UserHome\tools\Banner\ScitePatchBanner.png"
if (Page = 1)
{
	Gui, +HwndMainGui
	Gui, Font, S10 Bold
	Gui, Add, Text, xp+5 y+40 w620 vAnnounce1 , % AnnounceText[Page][1]
	Gui, Font, Normal
	Gui, Add, Text, xp w620 y+10 vAnnounce2 , % AnnounceText[Page][2]
	Gui, Add, Text, xp wp y+5 vAnnounce3 , % AnnounceText[Page][3]
	Gui, Add, Text, xp wp y+5 vAnnounce4 , % AnnounceText[Page][4]
	Gui, Add, Text, xp wp y+5 vAnnounce5 , % AnnounceText[Page][5]
}
else
{
	Gui, Font, S14 Bold
	Gui, Add, Text, xp+5 y+40 w620 Center vAnnounce1, % AnnounceText[Page][1]
	Gui, Font, S12 Normal
	Gui, Add, Text, xp y+20 wp Center vAnnounce2, % AnnounceText[Page][2]
	Gui, Add, Text, xp y+20 wp Center vAnnounce3, % AnnounceText[Page][3]
}
Gui, Add, Button, xp-5 y+20 w620 h50 vButton1 gButtonNext, 다음
Gui, Show
return

ButtonNext:
Page++
Loop, 5
	GuiControl, , % "Announce" A_Index, % AnnounceText[Page][A_Index]
switch Page
{
	case 5:
		GuiControl, Hide, Announce5
		GuiControl, MoveDraw, GroupBox2, h136
		Gui, Add, GroupBox, xm y304 w640 h167 cBlack Section vGroupBox3
		GuiControl, MoveDraw, Button1, y410
		Gui, Font, S12
		Gui, Add, Text, xs+10 ys+30 vAutoCCtrl1, % "자동완성 목록을 표시할 글자수"
		Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet1
		Gui, Add, UpDown, Range1-9 vAutoCUD1, 3
		Gui, Add, Text, xs+10 y+14 vAutoCCtrl2, % "자동완성에 포함시킬 단어의 최소 글자수"
		Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet2
		Gui, Add, UpDown, Range1-9 vAutoCUD2, 3
		Gui, Show, h480
		
	case 6:
		GuiControlGet, AutoCSet1, , AutoCSet1
		GuiControlGet, AutoCSet2, , AutoCSet2
		GuiControl, Hide, AutoCCtrl1
		GuiControl, Hide, AutoCCtrl2
		GuiControl, Hide, AutoCSet1
		GuiControl, Hide, AutoCSet2
		GuiControl, Hide, AutoCUD1
		GuiControl, Hide, AutoCUD2
		LineMoveSet := "Ctrl+" . (A_GuiControl = "LineMove1" ? "" : "Shift+")
		GuiControl, MoveDraw, Button1, x19 y580
		GuiControl, MoveDraw, GroupBox3, h337
		Gui, Add, Text, xm+10 ys+20 w420 h225 +Center +Border vNotScite
		Gui, Font, S9

		for i, v in ["Red", "Green", "Blue", "Trans"]
		{
			Gui, Add, Text, % (i = 1 ? "x450" : (i = 4 ? "x+20" : "x+10")) " y" (i = 1 ? "s+20" : "s") " w35 h25 +0x201 Section", % i = 4 ? "투명도" : v
			Gui, Add, Edit, % "w40 h20 +Center Number Limit3 vval" v " gRGBInput", % PreviewHLColor[i]
			Gui, Add, Slider, % "xp yp-10 w35 h150 AltSubmit Vertical Left Invert TickInterval32 Page32 Thick18 Range0-255 Buddy2val" v " vbar" v " gColorSlider", % PreviewHLColor[i]
		}
		Gui, Add, Edit, xm+442 y+30 w130 +Center Limit6 vHexColor gHexInput, % PreviewHLHex
		Gui, Add, Checkbox, y+8 w190 vHLDisable, % "이 기능을 사용하지 않을래요."
		Gui, Show, h650
		
		Gui, Font, % PreviewFont
		Gui, Add, Progress, % "xm+10 ys w420 h245 +Background" PreviewBG " vmp"
		Gui, Add, Text, xm+30 yp+20 cCBCBAB BackgroundTrans, % "Peter Piper "
		Gui, Add, Text, x+0 yp cCBCBAB BackgroundTrans vHighlight1, % "picked"
		Gui, Add, Text, x+0 yp cCBCBAB BackgroundTrans, % " a peck of pickled peppers"
		Gui, Add, Text, xm+30 y+10 cCBCBAB BackgroundTrans, % "A peck of pickled peppers Peter Piper "
		Gui, Add, Text, x+0 yp cCBCBAB BackgroundTrans vHighlight2, % "picked"
		Gui, Add, Text, xm+30 y+10 cCBCBAB BackgroundTrans, % "If Peter Piper "
		Gui, Add, Text, x+0 yp cCBCBAB BackgroundTrans vHighlight3, % "picked"
		Gui, Add, Text, x+0 yp cCBCBAB BackgroundTrans, % " a peck of pickled peppers"
		Gui, Add, Text, xm+30 y+10 cCBCBAB BackgroundTrans, % "How many pickled peppers did Peter Piper pick"
		GuiControl, Hide, mp
		GuiControl, Show, mp
		
		WinGetPos, vx, vy, vw, vh, ahk_id %MainGui%
		ControlGetPos, h0x, h0y, h0w, h0h, msctls_progress321
		ControlGetPos, h1x, h1y, h1w, h1h, Static15, ahk_id %MainGui%
		ControlGetPos, h2x, h2y, h2w, h2h, Static18, ahk_id %MainGui%
		ControlGetPos, h3x, h3y, h3w, h3h, Static20, ahk_id %MainGui%
		
		Gui, 2: -Caption +LastFound +Owner1 +HwndHLW
		Gui, 2: Add, Progress, % "x" h1x - 1 " y" h1y " w" h1w + 2 " h" h1h " +Background" PreviewHLHex " vHL1"
		Gui, 2: Add, Progress, % "x" h2x - 1 " y" h2y " w" h2w + 2 " h" h2h " +Background" PreviewHLHex " vHL2"
		Gui, 2: Add, Progress, % "x" h3x - 1 " y" h3y " w" h3w + 2 " h" h3h " +Background" PreviewHLHex " vHL3"
		Gui, 2: Show, % "x" vx " y" vy " h630 w" vw " NA"
		WinSet, TransColor, % "f0f0f0 " PreviewHLColor[4]
		
		hookProcAdr := RegisterCallback("HookProc")
		hHook := SetWinEventHook(0x800B,0x800B,0,hookProcAdr,0,0,0)
		DllCall("RegisterShellHookWindow", UInt, ThisList)
		MsgId := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
		OnMessage(MsgId, "MsgMonitor")
		
	case 7:
		GuiControlGet, HLColorSet, , HexColor
		GuiControlGet, HLTransSet, , valTrans
		GuiControlGet, HLUsedSet, , HLDisable
		Gui, 2: Destroy
		Gui, Destroy
		gosub, GuiCreate
		GuiControl, Disable, Button1
		GuiControl, , Button1, % "마침"
		goto, ScitePatch
		
	case 9:
		ExitApp
}
if (Page < 7)
{
	GuiControl, Disable, Button1
	GuiControl, , Button1, % "5초 후 버튼이 활성화 됩니다"
	SetTimer, ButtonWait, 5000
}
return

ButtonWait:
GuiControl, Enable, Button1
GuiControl, , Button1, % "다음"
SetTimer, ButtonWait, Off
return

ScitePatch:
Loop, Files, %A_Temp%\SciTE_UnofficalPatch\*, R
{
	if (InStr(A_LoopFileFullPath, "UserHome"))
		DivPos := InStr(A_LoopFileFullPath, "UserHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 7), SciteUserHome)
	else
		DivPos := InStr(A_LoopFileFullPath, "LocalHome")
		, Target := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos + 8), SciteDefaultHome)
	Backup := StrReplace(A_LoopFileFullPath, SubStr(A_LoopFileFullPath, 1, DivPos - 2), SciteDefaultHome "\PatchBackup")
	
	FileCopy, % Target, % Backup
	
	if (A_LoopFileName = "SciTEUser.properties")
	{
		FileRead, PatchFile, % A_LoopFileFullPath
		FileRead, UserProp, % Target
		DefineKeyword := false
		if (InStr(UserProp, "user.keywords"))
		{
			KeywordList := []
			Loop, 8
			{
				ThisKeywords := RegExMatch(UserProp, "sU)user.keywords" A_Index "=\\\s*(\S.*)?(?:[\r\n]*[^\r\n]+=|\s*$)", Match)
				if (Match1 != "")
					KeywordList[A_Index] := Match1, DefineKeyword := true
			}
		}
		if (DefineKeyword)
			for i, v in KeywordList
				PatchFile := RegExReplace(PatchFile, "s)(user.keywords" i "=\\..)", "$1" v, , 1)
		if (AutoCSet1 != 3)
			PatchFile := RegExReplace(PatchFile, "(autocomplete\.define\.prefix=)[\d]", "$1" AutoCSet1, , 1)
		if (AutoCSet2 != 3)
			PatchFile := RegExReplace(PatchFile, "(autocomplete\.define\.identifier=)[\d]", "$1" AutoCSet2, , 1)
		PatchFile := RegExReplace(RegExReplace(RegExReplace(PatchFile
							, "(highlight\.current\.word\.colour=#)[\w]{6}", "$1" . HLColorSet, , 1)
							, "(indicators\.alpha=)\d+", "$1" . HLTransSet, , 1)
							, "(highlight\.current\.word=)[01]", "$1" . !HLUsedSet, , 1)
		
		FileDelete, % Target
		FileAppend, % PatchFile, % Target, UTF-8
	}
	else
		FileCopy, % A_LoopFileFullPath, % Target, 1
}
if (FileExist(CheckFile))
	FileDelete, % CheckFile
GuiControl, Enable, Button1
goto, ButtonNext
return

ColorSlider:
ColorName := SubStr(A_GuiControl, 4)
GuiControl, , % "val" ColorName, % %A_GuiControl%
if (ColorName = "Trans")
	WinSet, TransColor, % "f0f0f0 " %A_GuiControl%, ahk_id %HLW%
else
{
	ThisColor := RGB2Hex(valRed, valGreen, valBlue)
	GuiControl, , HexColor, % ThisColor
	GuiControl, % "2: +Background" ThisColor, HL1
	GuiControl, % "2: +Background" ThisColor, HL2
	GuiControl, % "2: +Background" ThisColor, HL3
}
return

RGBInput:
Gui, Submit, Nohide
ControlGetFocus, var
if var in Edit3,Edit4,Edit5,Edit6
{
	if (%A_GuiControl% != 0 && SubStr(%A_GuiControl%, 1, 1) = 0)
	{
		GuiControl, , % %A_GuiControl%, % LTrim(%A_GuiControl%, "0")
		SendInput, {End}
	}
	if (%A_GuiControl% > 255)
	{
		GuiControl, , % %A_GuiControl%, 255
		SendInput, {End}
	}
	switch var
	{
		case "Edit3":
			GuiControl, , barRed, % valRed
		case "Edit4":
			GuiControl, , barGreen, % valGreen
		case "Edit5":
			GuiControl, , barBlue, % valBlue
		case "Edit6":
			GuiControl, , barTrans, % valTrans
			WinSet, TransColor, % "f0f0f0 " %A_GuiControl%, ahk_id %HLW%
	}
	ThisColor := RGB2Hex(valRed, valGreen, valBlue)
	GuiControl, , HexColor, % ThisColor
	GuiControl, % "2: +Background" ThisColor, HL1
	GuiControl, % "2: +Background" ThisColor, HL2
	GuiControl, % "2: +Background" ThisColor, HL3
}
return

HexInput:
ControlGetFocus, var
if var = Edit7
{
	GuiControlGet, HexColor, , HexColor
	HexColor := RegExReplace(HexColor, "[^0-9a-fA-F]+", "", Cnt)
	if (Cnt != 0)
	{
		GuiControl, , HexColor, % HexColor
		SendInput, {End}
	}
	HexLen := StrLen(HexColor)
	if (HexLen < 6)
		HexColor := SubStr(HexColor "000000", 1, 6)
	RGBCode := Hex2RGB(HexColor, false)
	GuiControl, % "2: +Background" HexColor, HL1
	GuiControl, % "2: +Background" HexColor, HL2
	GuiControl, % "2: +Background" HexColor, HL3
	GuiControl, , valRed, % RGBCode[1]
	GuiControl, , barRed, % RGBCode[1]
	GuiControl, , valGreen, % RGBCode[2]
	GuiControl, , barGreen, % RGBCode[2]
	GuiControl, , valBlue, % RGBCode[3]
	GuiControl, , barBlue, % RGBCode[3]
}
return

GuiClose:
ExitApp
return

WinGetPosEx(hwnd, byref x := 0, byref y := 0, byref w := 0, byref h := 0){
	VarSetCapacity(rect, 16)
	if !DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 9, "ptr", &rect, "uint", 16) {
		x := NumGet(rect, "int")
		y := NumGet(rect, 4, "int")
		w := NumGet(rect, 8, "int") - x
		h := NumGet(rect, 12, "int") - y
		return true
	}
}

MsgMonitor(wParam, lParam)
{
	if (wParam = 0x8004 || wParam = 0x8004) 
		HookProc("whatever", "whatever", lParam)
}
	
HookProc(hWinEventHook, event, hwnd) 
{ 
	global MainGui
	static pPos := 0
	IfWinExist, ahk_id %MainGui%
	{
		WinGetPos, vx, vy, , , ahk_id %MainGui%
		nPos := vx+vy
		if (nPos != pPos)
		{
			try
				Gui, 2: Show, % "x" vx " y" vy " NA"
			pPos := nPos
		}
	}
} 

SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) 
{ 
	DllCall("CoInitialize", "uint", 0) 
	return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags) 
}

Hex2RGB(hex, str = true) {
	if (str)
		return format("{1:u}, {2:u}, {3:u}", "0x" SubStr(hex, 1, 2), "0x" SubStr(hex, 3, 2), "0x" SubStr(hex, 5, 2))
	else
		return [format("{1:u}", "0x" SubStr(hex, 1, 2)), format("{1:u}", "0x" SubStr(hex, 3, 2)), format("{1:u}", "0x" SubStr(hex, 5, 2))]
}

class PropStyle
{
	__New() {
		this.Fore := "000000", this.Back := "ffffff", this.Bold := false, this.Italic := false, this.Underline := false, this.Size := 10
	}
	Overlap(prop) {
		this.Fore := RegExMatch(prop, "fore:#(\w{6})", match) ? match1 : this.Fore
		this.Back := RegExMatch(prop, "back:#(\w{6})", match) ? match1 : this.Back
		this.Bold := InStr(prop, "bold") ? true : this.Bold
		this.Italic := InStr(prop, "italics") ? true : this.Italic
		this.Underline := InStr(prop, "underlined") ? true : this.Underline
		this.Size := RegExMatch(prop, "size:(\d+)", match) ? match1 : this.Size
	}
	GetBG() {
		return this.Back
	}
	GetFont() {
		return "s" (this.Size > 13 ? 13 : this.Size) . " c" this.Fore . (this.Bold ? " Bold" : "") . (this.Italic ? " italic" : "") . (this.Underline ? " underline" : "")
	}
}
