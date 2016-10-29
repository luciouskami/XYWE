@ECHO OFF

REM 1.复制Override文件
REM 2.编译YDWE(XYEdition)

CD ..\Import\YDWE\Build\lua\luabuild\bin

SET LuaPath=%~dp0..\Import\YDWE\Build\lua\luabuild\bin\lua.exe
SET MakePath=%~dp0..\Import\YDWE\Build\lua\make.lua
SET 

ECHO %LuaPath%
ECHO %MakePath%
ECHO %%~dp0lua%

REM "%LuaPath" "%MakePath%" "%~dp0lua" %1 "%~dp0build.log" %2

PAUSE
EXIT