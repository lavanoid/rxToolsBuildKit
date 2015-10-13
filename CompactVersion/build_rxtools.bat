echo off
Title = Building rxTools...
cls
%~d0
cd %~dp0
if exist "rxTools" (
	cd rxTools
	Title = Building rxTools ^(Update^)...
	echo Updating repo...
	git pull origin master
	git submodule update --init --recursive
) else (
	Title = Building rxTools ^(Clone^)...
	echo Cloning repo...
	git clone --recursive https://github.com/roxas75/rxTools
	cd rxTools
)
echo Building...
Title = Building rxTools ^(Clean^)...
make clean
Title = Building rxTools ^(Release^)...
make release
Title =  Building rxTools ^(Done^)
echo.
echo ################################################
color A
echo Done. Files are in the "rxTools/release" folder.
cd ..
pause >nul
goto :EOF
