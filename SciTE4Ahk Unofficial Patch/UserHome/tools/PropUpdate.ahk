;
; UnofficialPatch - Props Updater
;

#NoEnv
#Persistent
#NoTrayIcon
#SingleInstance Off

scite := GetSciTEInstance()
file_path := scite.UserDir "\define_func.properties"
FileGetSize, file_size, % file_path
prev_size := file_size
SetTimer, Active, 100
return

Active:
IfWinActive, ahk_class SciTEWindow
{
	FileGetSize, file_size, % file_path
	if (file_size != prev_size)
	{
		try
			scite.ReloadProps()
		catch
			ExitApp
		prev_size := file_size
	}
}
else
{
	IfWinNotExist, ahk_class SciTEWindow
		ExitApp
}
return
