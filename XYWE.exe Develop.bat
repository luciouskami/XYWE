@ECHO OFF
IF EXIST "XYWE.exe" (
	START "" "XYWE.exe" "Develop"
) ELSE (
	ECHO Can't find XYWE.exe at current directory
	ECHO You should build Develop-Editor first
	ECHO=
	PAUSE
)