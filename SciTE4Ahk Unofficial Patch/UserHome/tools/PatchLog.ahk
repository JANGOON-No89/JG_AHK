;
; UnofficialPatch - Show PatchLog
;

#NoEnv
#KeyHistory 0
#SingleInstance Ignore
ListLines Off
SetWinDelay, -1
SetBatchLines, -1
SetControlDelay, -1

Scite := GetSciTEInstance()
SciteUserHome := Scite.UserDir
SPath := SciteUserHome . "\Settings"
IniRead, Auto, % SPath "\PatchLog.ini", Settings, ShowNext
Manual = %1%
if (Auto = 1 && !Manual)
	ExitApp

PatchLog =
(
<style>
	* {font-family: "나눔고딕";}
	li {color: #A04040;}
	ul {list-style: none; padding-left: 10px; margin: 10px 0px 30px 0px;}
	div.title {font-size: 15pt; font-weight: bold; color: #0004AA; padding-bottom: 3px; border-bottom: 2px solid gray;}
	span {font-size: 8pt; color: gray;}
	pre {width: 100`%; word-wrap: break-word; color: black; font-size: 10pt;padding-left: 10px; margin: 3px 20px 10px 0px; line-height: 13pt;}
</style>
<html>
<div class="title">기능 개선 및 강화</div>
<ul>
	<li>파일 백업 기능 개선 및 복원 기능 추가 </li><span>[ v0.1 ]</span>
    <pre>이제 파일명에 영어가 아닌 언어가 포함되어도 백업파일이 생성됩니다.
단, 스크립트와 같은 폴더에 백업파일이 생성되 기존방식과 달리 별도의 지정된 폴더에 백업파일이 생성되며, 이를 관리하기 위한 복원 기능을 도구 메뉴에 추가하여 현재 파일을 지정 시점의 내용으로 복원할 수 있도록 하였습니다.</pre>
    <li>블럭 주석 기능 개선 </li><span>[ v0.1 ]</span>
	<pre>이제 블럭주석 단축키(Ctrl+Shift+Q)가 블럭 주석을 해제할수도 있습니다.</pre>
    <li>Switch문 자동 들여쓰기 </li><span>[ v0.1 ]</span>
	<pre>Switch문 입력 후 Enter를 누르면 자동으로 괄호와 Case가 입력됩니다.
Case, Default문 입력 후 Enter를 누르면 자동으로 들여쓰기가 적용되며,
이 때 콜론":"이 누락됐다면 자동으로 입력해줍니다.</pre>
    <li>중괄호 자동 들여쓰기 </li><span>[ v0.1 ]</span>
	<pre>중괄호"{"가 열리면 문맥을 감지하여 현재 구문에 해당하는 들여쓰기가 적용됩니다.</pre>
    <li>자동완성 기능 강화 </li><span>[ v0.1 ]</span>
	<pre>기존 등록된 키워드 이외에도 문서내에 존재하는 모든 단어가 자동완성 목록에 포함됩니다.</pre>
    <li>키패드 + - 입력 허용 </li><span>[ v0.1 ]</span>
	<pre>두 키에 할당되있던 괄호 펼치기, 주석 전환 기능의 할당을 해제하였습니다.
이제 키패드로도 + - 를 입력할 수 있습니다.</pre>
</ul>
<div class="title">자동 동작 기능 추가</div>
<ul>
	<li>반점 뒤에 공백 입력 </li><span>[ v0.1 ]</span>
	<pre>가독성을 위해 콤마(반점) 입력시 자동으로 공백(Sapce)을 입력합니다. 또한 콤마 뒤에서 문자 입력시 자동으로 한 칸을 띄우고 입력을 진행합니다.</pre>
	<li>괄호 자동 닫기 </li><span>[ v0.1 ]</span>
	<pre>여는 괄호"[{("입력시 자동으로 쌍이되는 괄호"]})"가 입력됩니다.</pre>
	<li>쌍괄호 자동 제거 </li><span>[ v0.1 ]</span>
	<pre>한 쪽 괄호를 지울 때 해당 괄호가 비어있다면 자동으로 쌍이되는 괄호를 지웁니다.</pre>
	<li>사용자 정의 함수 실시간 적용 </li><span>[ v0.1 ]</span>
	<pre>사용자 정의 함수가 추가될 경우 자동으로 함수 스타일과 툴팁, 자동완성이 적용되며, 지정 영역에 도움말 입력 후 저장을 누르면 해당 함수의 툴팁의 변경사항을 적용합니다.</pre>
	<li>선택단어 강조 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>현재 캐럿(키보드 커서)이 위치한 단어, 혹은 드래그로 선택된 단어와 중복이 되는 단어를 모두 표시하며, 강조된 단어가 존재하는 모든 줄을 줄번호 영역에 표시합니다.
단, 글자는 같더라도 에디터에 표시되는 스타일이 다르면 같은 단어로 취급하지 않습니다.</pre>
	<li>템플릿 시스템 추가 </li><span>[ v0.1 ]</span>
	<pre>문서를 비우면 미리 작성한 템플릿의 내용이 자동으로 입력됩니다.</pre>
</ul>
<div class="title">단축키 기능 추가</div>
<ul>
	<li>다시실행 키 추가 </li><span>[ v0.1 ]</span>
	<pre>되돌리기(Ctrl + Z)를 취소하는 Redo 기능의 단축키가 기존 Ctrl + Y에 더해
Ctrl + Shift + Z 키로도 동작하게 되었습니다.</pre>
	<li>줄 이동 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Ctrl + 위 아래 방향키로 현재 선택된 줄을 위 아래로 이동시킬 수 있게 되었습니다.</pre>
	<li>줄 복사 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Ctrl + Shift + 위 아래 방향키로 현재 캐럿(키보드 커서)이 위치한 줄을 위 아래로 복사시킬 수 있게 되었습니다.</pre>
	<li>괄호간 이동 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Alt + 좌 우 방향키로 괄호간 이동을 할 수 있게 되었습니다.
좌 방향키는 좌측 방향으로 여는괄호"[{("를 찾아서 괄호의 왼쪽으로 이동하며,
우 방향키는 우측 방향으로 닫는괄호"]})"를 찾아서 괄호의 오른쪽으로 이동합니다.
해당하는 괄호가 없으면 줄 끝으로 이동합니다.
닫는 괄호를 찾는 기능은 Alt + Enter 키로도 동작합니다.</pre>
	<li>짝괄호 제거 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>괄호 왼쪽에서 Alt + Delete 키를 누르면 해당 괄호의 짝이 되는 괄호를 같이 지웁니다.</pre>
	<li>다음 줄로 이동 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Shift + Enter 키를 누르면 다음 줄을 한 칸 띄우면서 이동합니다.</pre>
	<li>현재 줄 선택 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Ctrl + I 키를 누르면 현재 줄 전체를 선택합니다.</pre>
	<li>현재 줄 잘라내기 기능 추가 </li><span>[ v0.1 ]</span>
	<pre>Ctrl + E 키를 누르면 현재 줄을 지우고, 그 내용을 클립보드에 복사합니다.</pre>
</ul>
<p></p>
<div class="title">보조 프로그램 추가</div>
<ul>
	<li>스타일 에디터 추가 </li><span>[ v0.1 ]</span>
	<pre>Scite 에디터에 적용되는 키워드 스타일을 쉽게 바꿀 수 있는 보조 프로그램이 추가되었습니다.
자체 내장된 에디터보다 많은 항목을 변경할 수 있으며, 한글과 미리보기를 지원합니다.</pre>
	<li>키워드 생성기 추가 </li><span>[ v0.1 ]</span>
	<pre>자동완성과 툴팁, 스타일이 적용되는 키워드를 추가할 수 있습니다.
( 향후 편집을 지원하도록 업데이트 예정입니다. )</pre>
	<li>핫키 입력기 추가 </li><span>[ v0.1 ]</span>
	<pre>핫키를 키보드를 누르는 것으로 추가할 수 있는 입력기가 추가되었습니다.
이것으로 조합키와 심볼을 편하게 입력할 수 있습니다.</pre>
	<li>약어 편집기 추가 </li><span>[ v0.1 ]</span>
	<pre>흔히 Snippet 혹은 Template으로 불리는 약어를 편집할 수 있는 편집기가 추가되었습니다.
키워드를 입력하고 Ctrl + B 키 입력시 지정된 내용으로 확장됩니다.</pre>
	<li>색 입력 도우미 추가 </li><span>[ v0.1 ]</span>
	<pre>PixelSearch 혹은 Gui Color에 쓰이는 6자리 Hex 코드를 입력하는 편집기가 추가되었습니다.
색을 직접 지정하거나, 마우스가 위치한 픽셀의 색상을 캡쳐하여 입력할 수 있습니다.</pre>
</ul>
<p></p>
<div class="title">제외된 기능</div>
<ul>
    <li>Tillagoto 비활성 </li><span>[ v0.1 ]</span>
	<pre>F12키로 활성되는 Tillagoto는 그 기능을 아는사람이 영문으로만 코딩할 땐 은근히 도움이 됩니다.
하지만 이 기능에 대해 모르는 유저에겐 가끔씩 나타나는 방해물에 불과하죠.
게다가 이 기능을 알더라도 문서 내에 영어가 아닌 언어가 단 한 글자라도 존재하면 좌표계가 꼬여버려서 쓸모없는 애물단지로 전락합니다.
그러므로 우리 한국 유저에게는 불필요한 존재라 판단. 비활성 했습니다.</pre>
</ul>
<p></p>
<div class="title">알려진 문제점</div>
<ul>
	<li>외국어 중복 입력 </li><span>[ v0.1 ]</span>
	<pre>영어가 아닌 외국어(한글, 일본어 등)를 입력시 때때로 영어를 제외한 모든 외국어 글자가 두세번씩 중복입력되는 현상이 발생합니다.
해당 현상은 에디터를 재실행 하는 것으로 해결이 가능하며, 재실행하지 않으면 영원히 지속되는것으로 확인됩니다.</pre>
	<li>선택 단어 강조 </li><span>[ v0.1 ]</span>
	<pre>더블클릭 혹은 글자를 드래그하여 선택한 단어는 단어가 강조되더라도 줄번호 옆에 그 위치가 표시되지 않는 현상이 발생합니다.
단, 그 상태에서 스크롤을 움직이면 정상적으로 표시가 나타나며, 더블클릭, 드래그가 아닌 입력지연으로 강조된 단어 또한 정상적으로 표시됩니다.</pre>
	<li>잘못된 자동 들여쓰기 </li><span>[ v0.1 ]</span>
	<pre>일부 구문에서 문맥을 잘못 감지하여 문맥에 맞지않는 줄나눔 혹은 들여쓰기가 적용되는 현상이 발생합니다.</pre>
</ul>
<p></p>
<div class="title">업데이트</div>
<ul>
	<li>v0.1</li>
	<pre>디버그용 최초 배포 버전</pre>
	<li>v0.11</li>
	<pre>- 패치 프로그램과 패치로 추가되는 기능들의 일부 오류 수정
- 자동 들여쓰기 문맥 감지 기능 사아아알짝 개선
- 자동 백업시 오류메세지 나타나던 증상 해결 (피드백 패치)</pre>
</ul>
<p></p>
<div class="title"></div>
</html>
)

Gui, Margin, 10, 10
Gui, Add, Picture, , % SciteUserHome . "\tools\Banner\ScitePatchBanner.png"
Gui, Add, ActiveX, w620 h600 vwb, Shell.Explorer
wb.silent := true
wb.Navigate("about:blank")
while (wb.readyState != 4 || wb.busy)
	Sleep, -1
wb.document.write(PatchLog)
Gui, Add, Link, w310, 자세한 사용법은 <a href="https://jg-no89.tistory.com/4">제작자 블로그</a>에서 확인할 수 있습니다.
Gui, Add, Checkbox, % "x470 yp w160 Right vShowNext " . (Auto = 1 ? "Checked" : ""), 다음 실행부터 보지 않음
Gui, Show, , PatchLog
OnMessage(0x200, "Hover")
return

GuiClose:
Gui, Submit, NoHide
if (!FileExist(SPath))
	FileCreateDir, % SPath
IniWrite, % ShowNext, % SPath "\PatchLog.ini", Settings, ShowNext
ExitApp
return

Hover()
{
	MouseGetPos, , , , Ctr
	if (Ctr = "Button1")
		ToolTip, % "이 창은 도구 메뉴를 통해 다시 열 수 있습니다."
	else
		ToolTip
}
