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
Gui, Add, Text, xm+110 y20, % "�ڵ��ϼ� ����� ǥ���� ���ڼ�"
Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet1
Gui, Add, UpDown, Range1-9, % scite.ResolveProp("autocomplete.define.prefix")
Gui, Font, S9
Gui, Add, Text, xm y+6 w500 Center, % "�� ���ڼ���ŭ �Է����� ������ ����� �ڵ��ϼ� ����� ��Ÿ���� �ʽ��ϴ�."
Gui, Font, S12
Gui, Add, Text, xm+80 y+30, % "�ڵ��ϼ��� ���Խ�ų �ܾ��� �ּ� ���ڼ�"
Gui, Add, Edit, x+10 yp-4 w40 Number vAutoCSet2
Gui, Add, UpDown, Range1-9, % scite.ResolveProp("autocomplete.define.identifier")
Gui, Font, S9
Gui, Add, Text, xm y+6 w500 Center, % "�� ���ڼ� �̸��� �ܾ�� ����� �ڵ��ϼ� ��Ͽ� ���Ե��� �ʽ��ϴ�."
Gui, Add, Text, xm y+5 w500 Center, % "(����� �ڵ��ϼ� ����� �ƴ� ���� �ڵ��ϼ� ����� �� ������ ������ �ʽ��ϴ�.)"
Gui, Font, S12
Gui, Add, Button, xm y+20 w500 h40 gApply, ����
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
