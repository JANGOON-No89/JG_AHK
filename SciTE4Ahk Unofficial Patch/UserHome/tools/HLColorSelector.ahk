;
; UnofficialPatch - Highlight Color Selector
;

#NoEnv
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

Scite := GetSciTEInstance()
if !Scite
{
	SoundPlay, *16
	ExitApp
}
SciteUserHome := Scite.UserDir
PreviewHLColor := [0, 255, 0, 150], PreviewHLHex := "00ff00"
if (scite.ResolveProp("highlight.current.word") != "")
{
	UsersHLColor := scite.ResolveProp("highlight.current.word.colour")
	if (UsersHLColor != "")
	{
		UsersHLRGB := Hex2RGB(SubStr(UsersHLColor, 2), false), PreviewHLHex := SubStr(UsersHLColor, 2)
		PreviewHLColor[1] := UsersHLRGB[1], PreviewHLColor[2] := UsersHLRGB[2], PreviewHLColor[3] := UsersHLRGB[3]
	}
	UsersHLTrans := scite.ResolveProp("Indicators.alpha")
	if (UsersHLTrans != "")
		PreviewHLColor[4] := UsersHLTrans
}
SciteBaseStyle := Scite.ResolveProp("style.*.32"), SciteTextStyle := Scite.ResolveProp("style.ahk1.0")
PreviewStyle := PropStyle, PreviewStyle.Overlap(SciteBaseStyle), PreviewStyle.Overlap(SciteTextStyle)
PreviewBG := PreviewStyle.GetBG(), PreviewFont := PreviewStyle.GetFont()
HLChecked := !Scite.ResolveProp("highlight.current.word")

Gui, +HwndMainGui
Gui, Margin, 10, 10
for i, v in ["Red", "Green", "Blue", "Trans"]
{
	Gui, Add, Text, % (i = 1 ? "x440" : (i = 4 ? "x+20" : "x+10")) " y" (i = 1 ? "m" : "s") " w35 h25 +0x201 Section", % i = 4 ? "투명도" : v
	Gui, Add, Edit, % "w40 h20 +Center Number Limit3 vval" v " gRGBInput", % PreviewHLColor[i]
	Gui, Add, Slider, % "xp yp-10 w35 h150 AltSubmit Vertical Left Invert TickInterval32 Page32 Thick18 Range0-255 Buddy2val" v " vbar" v " gColorSlider", % PreviewHLColor[i]
}
Gui, Add, Edit, xm+432 y+30 w130 +Center Limit6 vHexColor gHexInput, % PreviewHLHex
Gui, Font, S12
Gui, Add, Button, xm y+10 w625 h40 gSubmit, 적용
Gui, Font, S9
Gui, Add, Checkbox, % "wp Right vHLDisable " . (HLChecked ? "Checked" : "") , % "선택단어 강조기능을 사용하지 않겠습니다."
Gui, Show, , HighlightColor Selector

Gui, Font, % PreviewFont
Gui, Add, Progress, % "xm ym w420 h225 +Background" PreviewBG " vmp"
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
ControlGetPos, h1x, h1y, h1w, h1h, Static6, ahk_id %MainGui%
ControlGetPos, h2x, h2y, h2w, h2h, Static9, ahk_id %MainGui%
ControlGetPos, h3x, h3y, h3w, h3h, Static11, ahk_id %MainGui%

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
return

Submit:
Gui, Submit, NoHide
FileRead, PropFile, % SciteUserHome "\SciTEUser.properties"
PropFile := RegExReplace(RegExReplace(RegExReplace(PropFile
					, "(highlight\.current\.word\.colour=#)[\w]{6}", "$1" . HexColor, , 1)
					, "(indicators\.alpha=)\d+", "$1" . valTrans, , 1)
					, "(highlight\.current\.word=)[01]", "$1" . !HLDisable, , 1)
FileMove, % SciteUserHome "\SciTEUser.properties", % SciteUserHome "\SciTEUser.properties.bak", 1
FileAppend, % PropFile, % SciteUserHome "\SciTEUser.properties", UTF-8
Scite.ReloadProps()
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
if var in Edit1,Edit2,Edit3,Edit4
{
	if (SubStr(%A_GuiControl%, 1, 1) = 0)
	{
		GuiControl, , % %A_GuiControl%, % LTrim(%A_GuiControl%, "0")
		SendInput, {End}
	}
	if (%A_GuiControl% > 255)
	{
		GuiControl, , % %A_GuiControl%, 255
		SendInput, {End}
	}
	if (var = "Edit1")
		GuiControl, , barRed, % valRed
	else if (var = "Edit2")
		GuiControl, , barGreen, % valGreen
	else if (var = "Edit3")
		GuiControl, , barBlue, % valBlue
	else if (var = "Edit4")
	{
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
if var = Edit5
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