@echo off

SET LW_SERIAL=ECHO

%LW_SERIAL% blue

call %*

if %ERRORLEVEL% NEQ 0 (
	%LW_SERIAL% red
) else (
	%LW_SERIAL% green
)

set /p temp=""

%LW_SERIAL% off
