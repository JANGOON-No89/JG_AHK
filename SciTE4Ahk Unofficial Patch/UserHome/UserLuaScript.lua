-- UserLuaScript.lua
-- =================

-- This file contains user-defined Lua functions
-- You are encouraged to add your own custom functions here!

function NextLineLF()
	editor:LineEnd()
	editor:NewLine()
end

function SelectLinesUp()
	local curPos = editor.CurrentPos
	if editor.SelectionEmpty or not string.find(editor:GetSelText(), "\n") then
		SingleLineMove(editor:LineFromPosition(curPos), editor:LineFromPosition(curPos) - 1)
	else
		local SelectionStartLine = editor:LineFromPosition(editor.SelectionStart)
		local SelectionEndLine = editor:LineFromPosition(editor.SelectionEnd)
		MultipleLinesMove(SelectionStartLine - 1, SelectionStartLine, SelectionEndLine)
	end
end

function SelectLinesDown()
	local curPos = editor.CurrentPos
	if editor.SelectionEmpty or not string.find(editor:GetSelText(), "\n") then
		SingleLineMove(editor:LineFromPosition(curPos), editor:LineFromPosition(curPos) + 1)
	else
		local SelectionStartLine = editor:LineFromPosition(editor.SelectionStart)
		local SelectionEndLine = editor:LineFromPosition(editor.SelectionEnd)
		MultipleLinesMove(SelectionEndLine + 1, SelectionStartLine, SelectionEndLine)
	end
end

function SingleLineMove(curLine, AfterLine)
	if editor.LineIndentation[curLine] == editor.LineIndentation[AfterLine] then
		LineMove(curLine, AfterLine)
	else
		local AfterLineText = editor:GetLine(AfterLine)
		local AfterIndent = string.sub(AfterLineText, string.find(AfterLineText, "^[ 	]*"))
		editor:SetSel(editor.LineEndPosition[curLine], editor:PositionFromLine(curLine))
		editor:ReplaceSel(string.gsub(editor:GetSelText(), "^%s*", AfterIndent))
		editor:HomeExtend()
	end
end

function MultipleLinesMove(AfterLine, SelectionStartLine, SelectionEndLine)
	local curWhileLine = SelectionStartLine
	local MinIndentation = editor.LineIndentation[curWhileLine]
	local MinIndent = string.sub(editor:GetLine(curWhileLine), string.find(editor:GetLine(curWhileLine), "^[ 	]*"))
	local SameIndent = true
	while curWhileLine <= SelectionEndLine do
		curIndent = editor.LineIndentation[curWhileLine]
		if curIndent ~= MinIndentation then
			SameIndent = false
			if curIndent < MinIndentation then
				MinIndentation = curIndent
				MinIndent = string.sub(editor:GetLine(curWhileLine), string.find(editor:GetLine(curWhileLine), "^[ 	]*"))
			end
		end
		curWhileLine = curWhileLine + 1
	end
	if MinIndentation == editor.LineIndentation[AfterLine] then
		LineMove(SelectionStartLine, AfterLine)
	else
		local AfterLineText = editor:GetLine(AfterLine)
		local AfterIndent = string.sub(AfterLineText, string.find(AfterLineText, "^[ 	]*"))
		if SameIndent then
			editor:SetSel(editor.LineEndPosition[SelectionEndLine], editor:PositionFromLine(SelectionStartLine))
			editor:ReplaceSel(string.gsub(string.gsub(editor:GetSelText(), "^%s*", AfterIndent), "\n%s*", "\n" .. AfterIndent))
			editor:SetSel(editor.LineEndPosition[SelectionEndLine], editor:PositionFromLine(SelectionStartLine))
		else
			editor:SetSel(editor.LineEndPosition[SelectionEndLine], editor:PositionFromLine(SelectionStartLine))
			editor:ReplaceSel(string.gsub(string.gsub(editor:GetSelText(), "^" .. MinIndent .. "(%s*)", AfterIndent .. "%1"), "\n".. MinIndent .."(%s*)", "\n" .. AfterIndent .. "%1"))
			editor:SetSel(editor.LineEndPosition[SelectionEndLine], editor:PositionFromLine(SelectionStartLine))
		end
	end

end

function LineMove(curLine, AfterLine)
	if curLine > AfterLine then
		editor:MoveSelectedLinesUp()
	else
		editor:MoveSelectedLinesDown()
	end
	editor:SetSel(editor.Anchor - 2, editor.CurrentPos)
end

function LinePasteUP()
	editor:BeginUndoAction()
	local LineText = editor:GetCurLine()
	local LineNum = editor:LineFromPosition(editor.CurrentPos)
	local InsertPos = editor:PositionFromLine(LineNum)
	editor:InsertText(InsertPos, LineText)
	editor:EndUndoAction()
end

function LinePasteDN()
	editor:BeginUndoAction()
	local LineText = editor:GetCurLine()
	local LineNum = editor:LineFromPosition(editor.CurrentPos) + 1
	local InsertPos = editor:PositionFromLine(LineNum)
	editor:InsertText(InsertPos, LineText)
	editor:EndUndoAction()
end

function LineSelection()
	editor:Home()
	editor:LineEndExtend()
end

function ExitBraceR()
	CancelAutoComplete()
	local BraceChar = {"\r", ")", "}", "]"}
	local curPos = editor.CurrentPos
	local lim = editor.TextLength
	while true do
		local curN = FindTableChar(BraceChar, str(editor.CharAt[curPos]))
		if curN ~= 0 then
			if curN == 1 then
				editor:GotoPos(curPos)
			else
				editor:GotoPos(curPos + 1)
			end break
		else
			if curPos == lim then
				editor:GotoPos(curPos)
				break
			end
			curPos = curPos + 1
		end
	end
end

function ExitBraceL()
	CancelAutoComplete()
	local BraceChar = {"\n", "(", "{", "["}
	local curPos = editor.CurrentPos - 1
	while true do
		local curN = FindTableChar(BraceChar, str(editor.CharAt[curPos]))
		if curN ~= 0 then
			if curN == 1 then
				editor:GotoPos(curPos + 1)
			else
				editor:GotoPos(curPos)
			end break
		else
			if curPos < 1 then
				editor:GotoPos(0)
				break
			end
			curPos = curPos - 1
		end
	end
end

function FindTableChar(table, elem)
	if table == null then return 0 end
	for k,i in ipairs(table) do
		if i == elem then
			return k
		end
	end
	return 0
end

function DelPairBrace()
	local curPos = editor.CurrentPos
	local PairPos = editor:BraceMatch(curPos, 0)
	if PairPos ~= -1 then
		editor:DeleteRange(PairPos, 1)
		if curPos > PairPos then
			editor:DeleteRange(curPos - 1, 1)
		else 
			editor:DeleteRange(curPos, 1)
		end
	end
end

function BlockComment()
	editor:BeginUndoAction()
	local Caret = editor.CurrentPos
	local Anchor = editor.Anchor
	local Limit = editor.TextLength
	local BlockStyle = SCE_AHK_COMMENTBLOCK
	if editor.StyleAt[Caret] ~= BlockStyle and editor.StyleAt[Anchor] ~= BlockStyle then
		if Caret < Anchor then
			editor:SetSel(Caret, Anchor) editor:LineEnd() editor:NewLine() editor:HomeExtend() editor:ReplaceSel("*/")
			editor:GotoPos(Caret) editor:Home() editor:AddText("\r\n") editor:LineUp() editor:AddText("/*")
			editor:SetSel(Caret + 4, Anchor + 4)
		else
			editor:LineEnd() editor:NewLine() editor:HomeExtend() editor:ReplaceSel("*/")
			editor:GotoPos(Anchor) editor:Home() editor:AddText("\r\n") editor:LineUp() editor:AddText("/*")
			editor:SetSel(Anchor + 4, Caret + 4)
		end
	else
		local BlockPos = 0
		if editor.StyleAt[Caret] == BlockStyle then
			BlockPos = Caret else BlockPos = Anchor
		end
		local ThisPos = BlockPos
		while true do
			ThisPos = ThisPos + 1
			if editor.StyleAt[ThisPos] ~=BlockStyle then
				if not string.find(str(editor.CharAt[ThisPos]), "[\r\n]") then
					editor:DeleteRange(ThisPos - 2, 2)
					if ThisPos == Limit then break end
					if not string.find(editor:GetLine(editor:LineFromPosition(ThisPos - 2)), "[^ 	\r\n]") then
						editor:DeleteRange(ThisPos - 2, editor.LineEndPosition[editor:LineFromPosition(ThisPos - 2)] - ThisPos + 4)
					end
				else editor:DeleteRange(ThisPos - 2, 4) end break
			end
		end
		while true do
			BlockPos = BlockPos - 1
			if editor.StyleAt[BlockPos] ~=BlockStyle then
				if not string.find(str(editor.CharAt[BlockPos + 3]), "[\r\n]") then
					editor:DeleteRange(BlockPos + 1, 2)
					local ThisLineNumber = editor:LineFromPosition(BlockPos + 1)
					local ThisLineStart = editor:PositionFromLine(ThisLineNumber)
					if not string.find(editor:GetLine(ThisLineNumber), "[^ 	\r\n]") then
						editor:DeleteRange(ThisLineStart, editor.LineEndPosition[ThisLineNumber] - ThisLineStart + 2)
					end
				else editor:DeleteRange(BlockPos + 1, 4) end break
			end
		end
	end
	editor:EndUndoAction()
end
