@echo off

if "%~1"=="" (
	echo ERROR: ˆø”‚ª‘«‚è‚Ü‚¹‚ñ
	echo Usage: %~0 file
	exit /b 1
)

set file=%1

for /f "tokens=1,2" %%a in (moji_words.txt) do (
rem	echo %%a %%b
	findstr /ln %%a %file% && (
		echo š%%a ¨ %%b ‚É’uŠ·‚·‚é‚±‚Æ
		echo.
	)
)

pause

