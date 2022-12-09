;
; UnofficialPatch - ColorAssistant
;

#NoEnv
#NoTrayIcon
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

scite := GetSciTEInstance()
if !scite
{
	MsgBox, 16, Error, Can Not Found Scite Editor!
	ExitApp
}

Text := [["ColorAssistant", "색입력 도우미"], ["Insert to`nEditor", "에디터에`n입력"], ["Capture", "추출"]
			, ["Press the F1 key to extract the color, and press the F12 key to cancel the extraction."
				,"F1키를 누르면 현재 위치의 색을 추출하고, F12키를 누르면 추출을 취소합니다."]]
Language := InStr(scite.ResolveProp("locale.properties"), "한국어") ? 2 : 1
ThisColor := "ffffff", This_RGB := [255, 255, 255]
for i, v in ["Red", "Green", "Blue"]
{
	Gui, Add, Text, xm y+7 w40 h25 +0x202 Section, % v
	Gui, Add, Edit, % "w40 h20 +Center Number Limit3 vval" v " gRGBInput", % This_RGB[i]
	Gui, Add, Slider, % "x+0 ys w277 h25 AltSubmit TickInterval32 Page32 Thick18 Range0-255 Buddy2val" v " vbar" v " gColorSlider", % This_RGB[i]
}
Gui, Add, Progress, % "x+50 ym+1 w60 h60 Border +Background" ThisColor " vColorPreview"
Gui, Add, Edit, w60 +Center Limit6 vHexColor gHexInput, % ThisColor
Gui, Add, Button, ym w80 h88 vcSubmit gInsertScite, % Text[2][Language]
Gui, Add, Button, x+8 yp wp hp vSelector_Cancel gCaptureStart, % Text[3][Language]
Gui, Add, Text, xm y+12 w605 Center , % Text[4][Language]
Gui, +HwndAssistant +AlwaysOnTop
Gui, Show, h105, % Text[1][Language]
ControlFocus, Edit4, ahk_id %Assistant%
Capture := false
return

ColorSlider:
ColorName := SubStr(A_GuiControl, 4)
GuiControl, , % "val" ColorName, % %A_GuiControl%
ThisColor := RGB2Hex(valRed, valGreen, valBlue)
GuiControl, , HexColor, % ThisColor
GuiControl, % "+Background" ThisColor, ColorPreview
return

RGBInput:
Gui, Submit, Nohide
ControlGetFocus, var
if var in Edit1,Edit2,Edit3
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
	if (var = "Edit1")
		GuiControl, , barRed, % valRed
	else if (var = "Edit2")
		GuiControl, , barGreen, % valGreen
	else if (var = "Edit3")
		GuiControl, , barBlue, % valBlue
	ThisColor := RGB2Hex(valRed, valGreen, valBlue)
	GuiControl, , HexColor, % ThisColor
	GuiControl, % "+Background" ThisColor, ColorPreview
}
return

HexInput:
ControlGetFocus, var
if var != Edit4
	return
ColorChange:
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
GuiControl, % "+Background" HexColor, ColorPreview
GuiControl, , valRed, % RGBCode[1]
GuiControl, , barRed, % RGBCode[1]
GuiControl, , valGreen, % RGBCode[2]
GuiControl, , barGreen, % RGBCode[2]
GuiControl, , valBlue, % RGBCode[3]
GuiControl, , barBlue, % RGBCode[3]
return

InsertScite:
Gui, Submit, Nohide
WinActivate, % "ahk_id " scite.SciteHandle
scite.InsertText(HexColor)
Send, {Left}
return

CaptureStart:
if (!Capture)
{
	Gui, Show, h130
	MouseGetPos x, y
	Sx := x < 100 ? 0 : x - 100
	Sy := y > 240 ? y - 240 : y + 50
	Capture := true, Zoom := 20, Rx := 105, Ry := 105, Zx := Rx / Zoom, Zy := Ry / Zoom
	Gui, 2: +AlwaysOnTop -Caption +HwndZoomScreen
	Gui, 2: Show, % "x" Sx " y" Sy " w" 2 * Rx " h" 2 * Ry " NA"
	WinSet, Transparent, 255

	Gui, 3: -Caption +LastFound +AlwaysOnTop +Border
	Gui, 3: Add, Progress, x83 y83 w23 h23 BackgroundWhite
	Gui, 3: Add, Text, x84 y84 w21 h21 +Border
	Gui, 3: Show, % "x" Sx " y" Sy " w" 2 * Rx " h" 2 * Ry " NA"
	WinSet, TransColor, f0f0f0

	HDD_Frame := DllCall("GetDC", UInt, "")
	HDC_Frame := DllCall("GetDC", UInt, ZoomScreen)
	SetTimer, Repaint, 50
}
return

#if (Capture = true)
F1::
MouseGetPos, vx, vy
PixelGetColor, val, vx, vy, Slow RGB
GuiControl, 1:, HexColor, % SubStr(val, 3)
gosub, ColorChange
F12::
SetTimer, Repaint, Off
DllCall("gdi32.dll\DeleteDC", UInt,HDC_Frame )
DllCall("gdi32.dll\DeleteDC", UInt,HDD_Frame )
Gui, Show, h105
Gui, 2: Destroy
Gui, 3: Destroy
Capture := false
return
#If

Repaint:
MouseGetPos x, y
if (x != Px || y != Py)
{
	xz := x - Zx + 2
	yz := y - Zy + 2
	DllCall("gdi32.dll\StretchBlt", UInt, HDC_Frame, Int, 0, Int, 0, Int, 2 * Rx, Int, 2 * Ry
												, UInt, HDD_Frame, UInt, xz, UInt, yz, Int, 2 * Zx, Int, 2 * Zy, UInt, 0xCC0020)
	Sx := x < 100 ? 0 : x - 100
	Sy := y > 240 ? y - 240 : y + 50
	Gui, 2: Show, % "x" Sx " y" Sy " NA"
	Gui, 3: Show, % "x" Sx " y" Sy " NA"
	Px := x, Py := y
}
return

GuiClose:
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
ExitApp
return
