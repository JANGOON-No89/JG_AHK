Hex2RGB(hex, str = true) {
	if (str)
		return format("{1:u}, {2:u}, {3:u}", "0x" SubStr(hex, 1, 2), "0x" SubStr(hex, 3, 2), "0x" SubStr(hex, 5, 2))
	else
		return [format("{1:u}", "0x" SubStr(hex, 1, 2)), format("{1:u}", "0x" SubStr(hex, 3, 2)), format("{1:u}", "0x" SubStr(hex, 5, 2))]
}
