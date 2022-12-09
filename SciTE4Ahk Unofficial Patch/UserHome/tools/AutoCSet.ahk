;
; UnofficialPatch - AutoComplete Setting
;

#NoEnv
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
Target := scite.UserDir "\SciTEUser.properties"

Gui, Font, S12
Gui, Add, Text, xm+110 y20, % "자동완성 목록을 표시할 글자수"
Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet1
Gui, Add, UpDown, Range1-9, % scite.ResolveProp("autocomplete.define.prefix")
Gui, Font, S9
Gui, Add, Text, xm y+6 w500 Center, % "이 글자수만큼 입력하지 않으면 사용자 자동완성 목록은 나타나지 않습니다."
Gui, Font, S12
Gui, Add, Text, xm+80 y+30, % "자동완성에 포함시킬 단어의 최소 글자수"
Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet2
Gui, Add, UpDown, Range1-9, % scite.ResolveProp("autocomplete.define.identifier")
Gui, Font, S9
Gui, Add, Text, xm y+6 w500 Center, % "이 글자수 미만의 단어는 사용자 자동완성 목록에 포함되지 않습니다."
Gui, Add, Text, xm y+5 w500 Center, % "(사용자 자동완성 목록이 아닌 기존 자동완성 목록은 이 설정을 따르지 않습니다.)"
Gui, Font, S12
Gui, Add, Button, xm y+20 w500 h40 gApply, 적용
Gui, Show
return

Apply:
Gui, Submit, NoHide
FileRead, PropFile, % Target
PropFile := RegExReplace(PatchFile, "(autocomplete\.define\.prefix=)\d+", "$1" AutoCSet1, , 1)
PropFile := RegExReplace(PatchFile, "(autocomplete\.define\.identifier=)\d+", "$1" AutoCSet2, , 1)
FileDelete, % Target
FileAppend, % PropFile, % Target, UTF-8
scite.ReloadProps()
return

GuiClose:
ExitApp
return
