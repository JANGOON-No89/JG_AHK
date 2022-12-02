;
; UnofficialPatch - HotkeyAssistant
;

#NoEnv
#Persistent
#NoTrayIcon
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

scite := GetSciTEInstance()
if !scite
{
	SoundPlay, *16
	ExitApp
}

SciteHwnd := scite.SciTEHandle
Text := ["`n키를 입력하면 현재 위치에 핫키가 추가됩니다.`n`n창을 더블클릭하면 입력을 마칩니다."
			, "다른 키가 눌려있어도 핫키를 실행합니다."
			, "Send 명령으로는 이 핫키가 실행되지 않게 합니다. "
			, "핫키로 지정되어도 해당 키의 기능을 막지 않습니다."
			, "직전입력`n취소"]

Gui, Font, S12 bold
Gui, Add, Text, x0 y0 w410 h80 Center Border , % Text[1]
Gui, Font, S9 Normal
Gui, Add, Text, x0 y+-1 w410 h80 Border Section
Gui, Add, Checkbox, xm+10 ys+12 vop1 , % Text[2]
Gui, Add, Checkbox, xp y+10 vop2 , % Text[3]
Gui, Add, Checkbox, xp y+10 vop3 , % Text[4]
Gui, Font, S12 Bold
Gui, Add, Button, x409 y0 w120 h159 Border gUndo, % Text[5]
Gui, -Caption +AlwaysOnTop
Gui, Show, w529 h159
OnMessage(0x201, "LBDN")
OnMessage(0x203, "DBCL")
State := 0, Combs := 0, PrevKey := "", InputKey := "", InputHotkey := "", Count := 0
SetTimer, GetHotkey, 100
return

GetHotkey:
Gui, Submit, Nohide
if (State = 0 && InputKey != "")
{
	Symbol := (op1 ? "*" : "") . (op2 ? "$" : "")
	Keys := StrSplit(Trim(InputKey), " ")
	if (Combs > 5)
		SoundPlay, *16
	else if (Combs > 2)
	{
		if (valid(Keys))
			InputHotkey := GetCombs(Keys)
		else
			SoundPlay, *16
	}
	else if (Combs = 2)
		InputHotkey := GetCombs(Keys)
	else
		InputHotkey := (op3 ? "~" : "") . Trim(InputKey)
	if (InputHotkey)
	{
		scite.InsertText(Symbol . StrReplace(InputHotkey, ";", "``;") . "::`r`n`r`nreturn`r`n`r`n")
		WinActivate, ahk_id %SciteHwnd%
		Send, {Left}
		scite.Message("0x111", 106), Count++
	}
	InputKey := "", PrevKey := "", InputHotkey := "", Combs := 0
}
return

Undo:
if (Count > 0)
	scite.Message("0x111", 201), Count--
return

valid(Keys) {
	r := true
	for i, v in Keys
	{
		if (i != Keys.Length())
			if v not in Ctrl,Alt,Shift,LWin,RWin
				r := false
	}
	return r
}

GetCombs(Keys) {
	global op3
	Len := Keys.Length(), KeySymbol := "", Symbol := op3 ? "~" : ""
	for i, v in Keys
	{
		if (i != Len)
			KeySymbol .= GetSymbol(v)
	}
	if (KeySymbol != "")
		return Symbol . KeySymbol . Keys[Len]
	else
		return Symbol . Keys[1] . " & " . Symbol . Keys[2]
}

GetSymbol(Key) {
	if (Key = "Ctrl")
		Symbol := "^"
	else if (Key = "Alt")
		Symbol := "!"
	else if (Key = "Shift")
		Symbol := "+"
	else if (Key = "LWin" || Key = "Rwin")
		Symbol := "#"
	return Symbol
}

DBCL() {
	MouseGetPos, , , , ThisCtrl
	if (ThisCtrl != "Button4")
		ExitApp
}

LBDN() {
	PostMessage, 0xA1, 2, , , A
}

Ctrl::
Alt::
LWin::
RWin::
Shift::
CapsLock::
Space::
Tab::
Enter::
Esc::
BackSpace::
ScrollLock::
Delete::
Insert::
Home::
End::
PGUP::
PGDN::
Up::
Down::
Left::
Right::
AppsKey::
PrintScreen::
Pause::
`::
-::
=::
,::
.::
/::
`;::
'::
[::
]::
A::
B::
C::
D::
E::
F::
G::
H::
I::
J::
K::
L::
M::
N::
O::
P::
Q::
R::
S::
T::
U::
V::
W::
X::
Y::
Z::
0::
1::
2::
3::
4::
5::
6::
7::
8::
9::
F1::
F2::
F3::
F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
Numpad0::
Numpad1::
Numpad2::
Numpad3::
Numpad4::
Numpad5::
Numpad6::
Numpad7::
Numpad8::
Numpad9::
NumLock::
NumpadDot::
NumpadDiv::
NumpadMult::
NumpadAdd::
NumpadSub::
NumpadEnter::
if (A_ThisHotkey != PrevKey)
	State++, Combs++, PrevKey := A_ThisHotkey, InputKey .= A_ThisHotkey " "
return


Ctrl Up::
Alt Up::
LWin Up::
RWin Up::
Shift Up::
CapsLock Up::
Space Up::
Tab Up::
Enter Up::
Esc Up::
BackSpace Up::
ScrollLock Up::
Delete Up::
Insert Up::
Home Up::
End Up::
PGUP Up::
PGDN Up::
Up Up::
Down Up::
Left Up::
Right Up::
AppsKey Up::
PrintScreen Up::
Pause Up::
` Up::
- Up::
= Up::
vkbc Up::
. Up::
/ Up::
`; Up::
' Up::
[ Up::
] Up::
A Up::
B Up::
C Up::
D Up::
E Up::
F Up::
G Up::
H Up::
I Up::
J Up::
K Up::
L Up::
M Up::
N Up::
O Up::
P Up::
Q Up::
R Up::
S Up::
T Up::
U Up::
V Up::
W Up::
X Up::
Y Up::
Z Up::
0 Up::
1 Up::
2 Up::
3 Up::
4 Up::
5 Up::
6 Up::
7 Up::
8 Up::
9 Up::
F1 Up::
F2 Up::
F3 Up::
F4 Up::
F5 Up::
F6 Up::
F7 Up::
F8 Up::
F9 Up::
F10 Up::
F11 Up::
F12 Up::
Numpad0 Up::
Numpad1 Up::
Numpad2 Up::
Numpad3 Up::
Numpad4 Up::
Numpad5 Up::
Numpad6 Up::
Numpad7 Up::
Numpad8 Up::
Numpad9 Up::
NumLock Up::
NumpadDot Up::
NumpadDiv Up::
NumpadMult Up::
NumpadAdd Up::
NumpadSub Up::
NumpadEnter Up::
State--
return