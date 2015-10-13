@echo off
%~d0
cd %~dp0
if exist "elevate.vbs" del /f "elevate.vbs"
echo Hang on a sec... Checking priviledges...
mkdir "%SystemRoot%\AdminAccessCheck" 2>nul
if not exist "%SystemRoot%\AdminAccessCheck" goto :admin
RD /S /Q "%SystemRoot%\AdminAccessCheck"
if not exist "%appdata%\rxToolsBuildKit\backups\systemenv.reg" echo No systemenv backup found.
if not exist "%appdata%\rxToolsBuildKit\backups\userenv.reg" echo No userenv backup found.
if exist "%appdata%\rxToolsBuildKit\backups\systemenv.reg" (
  echo Restoring system environment...
  reg import "%appdata%\rxToolsBuildKit\backups\systemenv.reg"
)
if exist "%appdata%\rxToolsBuildKit\backups\userenv.reg" (
  echo Restoring user environment...
  reg import "%appdata%\rxToolsBuildKit\backups\userenv.reg"
)
echo Done. I recommend a reboot :)
color A
goto :endpause
:admin
if "%1"=="admin" (
  echo Seems like you don't have the appropriate priviledges.
  echo Oh well. Go ask mommy to be an admin.
  goto :endpause
)
echo Gaining elevated access via UAC...
set THISPROGRAM=%0
set THISPROGRAM=%THISPROGRAM:"=%
set THISPROGRAM="%THISPROGRAM%"
@echo Set UAC = CreateObject("Shell.Application")> "elevate.vbs"
@echo Set args = WScript.Arguments>> "elevate.vbs"
@echo UAC.ShellExecute %THISPROGRAM%, "admin", "", "runas", 1 >> "elevate.vbs"
wscript "elevate.vbs" >>nul
exit
:endpause
pause
