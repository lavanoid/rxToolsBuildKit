@echo off
%~d0
cd %~dp0
set attempt=0
set magic=yes
Title = Environment installer
REM ##################### ADMIN STUFF #####################
if exist "elevate.vbs" del /f "elevate.vbs"
echo Hang on a sec... Checking priviledges...
mkdir "%SystemRoot%\AdminAccessCheck" 2>nul
if not exist "%SystemRoot%\AdminAccessCheck" goto :admin
RD /S /Q "%SystemRoot%\AdminAccessCheck"
TASKKILL /F /IM dlc.exe
TASKKILL /F /IM dlc.exe
if exist "%TEMP%\Magic.bat" del /f "%TEMP%\Magic.bat"
if exist "%TEMP%\Magic.vbs" del /f "%TEMP%\Magic.vbs"
cls
REM ##################### BACKUP #####################
if not exist "%appdata%\rxToolsBuildKit\backups" mkdir "%appdata%\rxToolsBuildKit\backups"
if not exist "%appdata%\rxToolsBuildKit\backups\userenv.reg" (
  echo [BACKUP] Backing up user environment...
  reg export "HKEY_CURRENT_USER\Environment" "%appdata%\rxToolsBuildKit\backups\userenv.reg"
)
if not exist "%appdata%\rxToolsBuildKit\backups\systemenv.reg" (
  echo [BACKUP] Backing up system environment...
  reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "%appdata%\rxToolsBuildKit\backups\systemenv.reg"
)
if not exist "%appdata%\rxToolsBuildKit\backups\userenv.reg" (
  echo Failed to create a backup of the user environment.
  echo Cannot install.
  color c
  goto :endpause
)
if not exist "%appdata%\rxToolsBuildKit\backups\systemenv.reg" (
  echo Failed to create a backup of the system environment.
  echo Cannot install.
  color c
  goto :endpause
)
:option
if "%1"=="nomagic" set magic=nope
if "%2"=="nomagic" set magic=nope
if "%1"=="wget" (
  set downloader=wget.exe
  goto :meh
)
if "%1"=="aria2c" (
  set downloader=aria2c.exe
  goto :meh
)
echo What downloader would you like to use?
echo 1.) wget.exe  2.) aria2c.exe
set /p downloader=1 or 2: %=%
set tempv=%downloader%
set /a tempv=%tempv%+1
set /a tempv=%tempv%-1
if not %tempv%==%downloader% (
  echo WOW! I SAID ENTER 1 OR 2!!
  goto :option
)
if %downloader%==1 (
  set downloader=wget.exe
  goto :meh
)
if %downloader%==2 (
  set downloader=aria2c.exe
  goto :ex
)
goto :option
:ex
set fast=false
echo Enable an experimental download feature? Things MIGHT be quicker.
echo File verification will be disabled, however.
set /p q=Y/N: %=%
if "%q%"=="Y" set fast=true
if "%q%"=="y" set fast=true
echo Fast: %fast%
:meh
REM ##################### CREATE DIRECTORYS #####################
if exist "%appdata%\rxToolsBuildKit\downloads" RD /S /Q "%appdata%\rxToolsBuildKit\downloads"
mkdir "%appdata%\rxToolsBuildKit\downloads"
if not exist "%appdata%\rxToolsBuildKit\downloads" (
  echo WOW! WWWOOOWW!! D: I couldn't make a directory!
  echo Have you been wanking on your computer?
  echo Cannot install.
  color c
  goto :endpause
)
cls
REM ##################### DOWNLOAD STUFF #####################
echo [STAT] Shit backed up.
call :downloaddownloader
call :download_file "%appdata%\rxToolsBuildKit\downloads\7za.exe" 587776 7-ZipCMD "https://dl.dropbox.com/s/49fdd3oyi1e1qse/7za.exe" "7za.exe" "%appdata%\rxToolsBuildKit\downloads"
REM ##################### THE FUN STUFF #####################
if "%magic%"=="yes" call :Magic
REM ##################### KEEP DOWNLOADING #####################
if "%fast%"=="true" (
  call :download_file fast "" "" "" "" "%appdata%\rxToolsBuildKit\downloads"
  goto :skip
)
call :download_file "%appdata%\rxToolsBuildKit\downloads\python-2.7.10.msi" 18423808 Python2 "https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi" "python-2.7.10.msi" "%appdata%\rxToolsBuildKit\downloads"
call :download_file "%appdata%\rxToolsBuildKit\downloads\devkitProUpdater-1.5.4.exe" 220165 DevkitPro "https://dl.dropbox.com/s/m8qv4vy6bddhten/devkitProUpdater-1.5.4.exe" "devkitProUpdater-1.5.4.exe" "%appdata%\rxToolsBuildKit\downloads"
call :download_file "%appdata%\rxToolsBuildKit\downloads\ImageMagick-6.9.2-4-portable-Q16-x86.zip" 60462363 ImageMagickPortable "http://www.imagemagick.org/download/binaries/ImageMagick-6.9.2-4-portable-Q16-x86.zip" "ImageMagick-6.9.2-4-portable-Q16-x86.zip" "%appdata%\rxToolsBuildKit\downloads"
call :download_file "%appdata%\rxToolsBuildKit\downloads\armips.exe" 108032 ARMIPS "https://dl.dropbox.com/s/nhq0shjbxlayyp8/armips.exe" "armips.exe" "%appdata%\rxToolsBuildKit\downloads"
call :download_file "%appdata%\rxToolsBuildKit\downloads\mingw.zip" 98920110 MinGW "https://dl.dropbox.com/s/8n4ou1yc3c1hfgo/mingw.zip" "mingw.zip" "%appdata%\rxToolsBuildKit\downloads"
call :download_file "%appdata%\rxToolsBuildKit\downloads\PortableGit.zip" 81410161 PortableGit "https://dl.dropbox.com/s/06gvvz7s64o9pcq/PortableGit.zip" "PortableGit.zip" "%appdata%\rxToolsBuildKit\downloads"
:skip
Title = Environment installer
REM ##################### INSTALL STUFF #####################
echo [STAT] Python2 - Installing your shit...
if not exist "%appdata%\rxToolsBuildKit\downloads\python-2.7.10.msi" (
  echo **ERROR** I can't find python. What the fuck happened? 0_o
  echo Cannot install.
  color c
  goto :endpause
)
explorer "%appdata%\rxToolsBuildKit\downloads\python-2.7.10.msi"
echo #####################
color B
echo Where did you install python to? Leave blank for the default
echo ^(%SystemDrive%\Python27^)
set /p py=Path: %=%
color 7
if "%py%"=="" (
  echo Using default directory.
  set py=%SystemDrive%\Python27
)
echo [STAT] DevkitPro - Installing that shit... One sec.
echo        Just select all installation options and you're good.
if not exist "%appdata%\rxToolsBuildKit\downloads\devkitProUpdater-1.5.4.exe" (
  echo.
  echo **ERROR** devkitPro must have taken a dump because I can't find it.
  echo Cannot install.
  color c
  goto :endpause
)
explorer "%appdata%\rxToolsBuildKit\downloads\devkitProUpdater-1.5.4.exe"
echo #####################
color B
echo [STAT] M'kay, now where did you install DevkitPro? Leave blank for default
echo ^(%SystemDrive%\devkitPro^)
set /p dkp=Path: %=%
color 7
if "%dkp%"=="" (
  echo Using default directory.
  set dkp=%SystemDrive%\devkitPro
)
Title = Environment installer - Extracting MinGW
echo [STAT] Extracting MinGW
if not exist "%appdata%\rxToolsBuildKit\downloads\mingw.zip" (
  echo.
  echo **ERROR** I can't find "%appdata%\rxToolsBuildKit\downloads\mingw.zip" :/
  echo Cannot install.
  color c
  goto :endpause
)
if exist "%SystemDrive%\MinGW" RD /S /Q "%SystemDrive%\MinGW"
mkdir "%SystemDrive%\MinGW"
"%appdata%\rxToolsBuildKit\downloads\7za.exe" -y x "%appdata%\rxToolsBuildKit\downloads\mingw.zip" -o"%SystemDrive%\MinGW"
if not exist "%SystemDrive%\MinGW" (
  echo [ERROR] I can't find "%SystemDrive%\MinGW" :/
  echo Cannot install.
  color c
  goto :endpause
)
Title = Environment installer - Extracting PortableGit
echo [STAT] Extracting PortableGit
if not exist "%appdata%\rxToolsBuildKit\downloads\PortableGit.zip" (
  echo.
  echo **ERROR** I can't find "%appdata%\rxToolsBuildKit\downloads\PortableGit.zip" :/
  echo Cannot install.
  color c
  goto :endpause
)
if exist "%SystemDrive%\PortableGit" RD /S /Q "%SystemDrive%\PortableGit"
mkdir "%SystemDrive%\PortableGit"
"%appdata%\rxToolsBuildKit\downloads\7za.exe" -y x "%appdata%\rxToolsBuildKit\downloads\PortableGit.zip" -o"%SystemDrive%\PortableGit"
if not exist "%SystemDrive%\PortableGit" (
  echo [ERROR] I can't find "%SystemDrive%\PortableGit" :/
  echo Cannot install.
  color c
  goto :endpause
)
Title = Environment installer - Extracting ImageMagick
echo [STAT] Extracting ImageMagick Portable x86
if not exist "%appdata%\rxToolsBuildKit\downloads\ImageMagick-6.9.2-4-portable-Q16-x86" (
  echo.
  echo **ERROR** I can't find "%appdata%\rxToolsBuildKit\downloads\ImageMagick-6.9.2-4-portable-Q16-x86" :/
  echo Cannot install.
  color c
  goto :endpause
)
if exist "%SystemDrive%\ImageMagick-6.9.2-3-portable-Q16-x86" RD /S /Q "%SystemDrive%\ImageMagick-6.9.2-3-portable-Q16-x86"
if exist "%SystemDrive%\ImageMagick" RD /S /Q "%SystemDrive%\ImageMagick"
mkdir "%SystemDrive%\ImageMagick"
"%appdata%\rxToolsBuildKit\downloads\7za.exe" -y x "%appdata%\rxToolsBuildKit\downloads\ImageMagick-6.9.2-4-portable-Q16-x86" -o"%SystemDrive%\ImageMagick" -r
if not exist "%SystemDrive%\ImageMagick" (
  echo [ERROR] I can't find "%SystemDrive%\ImageMagick" :/
  echo Cannot install.
  color c
  goto :endpause
)
Title = Environment installer - Install
echo [STAT] Installing ARMIPS....
if not exist "%appdata%\rxToolsBuildKit\downloads\armips.exe" (
  echo.
  echo **ERROR** I can't find "%appdata%\rxToolsBuildKit\downloads\armips.exe" :/
  echo Cannot install.
  color c
  goto :endpause
)
cd %dkp%
move /y "%appdata%\rxToolsBuildKit\downloads\armips.exe" "%CD%\msys\bin\"
if not exist "%CD%\msys\bin\armips.exe" echo Failed to install ARMIPS. Skipping.
%~d0
cd %~dp0
echo Okay, I think that's everything. Now to rape your registry.
echo Writing system path variable...
setx /m PATH "%dkp%\msys\bin;%SystemDrive%\ImageMagick-6.9.2-3-portable-Q16-x86;%dkp%\devkitARM\bin;%SystemDrive%\MinGW\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%py%;%SystemDrive%\PortableGit\bin"
echo Erasing user path variable...
setx PATH ""
echo.
echo Okay, so now your registry has digital cum added to it (That's a good thing).
echo.
echo Just a little bit moreeeee....
setx /m PATHEXT "%PATHEXT%;.PY"
echo.
echo AAAhh. Thats it! :D 8=====D
color A
echo.
Title = Environment installer - Done
echo Done! Everything was a success (I hope)!
echo So now you just run "Build_rxTools.bat" :D
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
@echo Set UAC = CreateObject("Shell.Application")> "%TEMP%\elevate.vbs"
@echo Set args = WScript.Arguments>> "%TEMP%\elevate.vbs"
@echo UAC.ShellExecute %THISPROGRAM%, "admin", "", "runas", 1 >> "%TEMP%\elevate.vbs"
wscript "%TEMP%\elevate.vbs" >>nul
exit
:downloaddownloader
if "%attempt%"=="2" (
  color c
  echo **ERROR** Too many attempts were made while processing the download.
  echo Cannot install.
  goto :endpause
)
echo if WScript.Arguments.Count ^< 1 then > "%appdata%\rxToolsBuildKit\dl.vbs"
echo   MsgBox "Usage: wget.vbs ^<url^> ^(file^)" >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo   WScript.Quit >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo end if >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo ' Arguments >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo URL = WScript.Arguments^(0^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo if WScript.Arguments.Count ^> 1 then >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo   saveTo = WScript.Arguments^(1^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo else >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo   parts = split^(url,"/"^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo   saveTo = parts^(ubound(parts)^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo end if >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo ' Fetch the file >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objXMLHTTP = CreateObject^("MSXML2.ServerXMLHTTP"^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objXMLHTTP.open "GET", URL, false >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objXMLHTTP.send() >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo If objXMLHTTP.Status = 200 Then >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objADOStream = CreateObject^("ADODB.Stream"^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.Open >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.Type = 1 'adTypeBinary >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.Write objXMLHTTP.ResponseBody >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.Position = 0    'Set the stream position to the start >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objFSO = Createobject^("Scripting.FileSystemObject"^) >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo If objFSO.Fileexists^(saveTo^) Then objFSO.DeleteFile saveTo >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objFSO = Nothing >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.SaveToFile saveTo >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo objADOStream.Close >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objADOStream = Nothing >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo End if >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo Set objXMLHTTP = Nothing >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo.>> "%appdata%\rxToolsBuildKit\dl.vbs"
echo ' Done >> "%appdata%\rxToolsBuildKit\dl.vbs"
echo WScript.Quit >> "%appdata%\rxToolsBuildKit\dl.vbs"
if not exist "%appdata%\rxToolsBuildKit\dl.vbs" (
  color c
  echo **ERROR** Failed to write the VBS file!
  echo Did you spill drink on the computer again? YOU WANKA!
  goto :endpause
)
if "%downloader%"=="wget.exe" (
  echo [DOWNLOAD] Downloading WGET... No output will be given
  echo            until complete.
  wscript "%appdata%\rxToolsBuildKit\dl.vbs" "https://dl.dropbox.com/s/2p4lzq1itlsajyd/wget.exe" "%appdata%\rxToolsBuildKit\downloads\wget.exe"
)
if "%downloader%"=="aria2c.exe" (
  echo [DOWNLOAD] Downloading aria2c... No output will be given
  echo            until complete.
  wscript "%appdata%\rxToolsBuildKit\dl.vbs" "https://dl.dropbox.com/s/yr0z9boob1w5elx/aria2c.exe" "%appdata%\rxToolsBuildKit\downloads\aria2c.exe"
)
if not exist "%appdata%\rxToolsBuildKit\downloads\%downloader%" (
  color c
  echo **ERROR** Failed to download %downloader%
  echo Cannot install.
  goto :endpause
)
if "%downloader%"=="aria2c.exe" call :verifysize "%appdata%\rxToolsBuildKit\downloads\%downloader%" 4456448
if "%downloader%"=="wget.exe" call :verifysize "%appdata%\rxToolsBuildKit\downloads\%downloader%" 252416
if exist "%appdata%\rxToolsBuildKit\dl.vbs" del /f "%appdata%\rxToolsBuildKit\dl.vbs"
if "%errorno%"=="0" (
  set attempt=0
  echo [STAT] Download success!
  goto :EOF
)
set /a attempt=%attempt%+1
echo [RE-DOWNLOAD] %downloader%
goto :downloaddownloader
:download_file
REM ARGS: <FILE STORE PATH> <EXPECTED SIZE> <PROGRAM TITLE> <PROGRAM URL> <PROGRAM FILE NAME> <DOWNLOAD DIR>
if "%1"=="fast" (
echo [INFO] No file verification is enabled.
echo https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi > "%appdata%\rxToolsBuildKit\dl.txt"
echo https://dl.dropbox.com/s/m8qv4vy6bddhten/devkitProUpdater-1.5.4.exe >> "%appdata%\rxToolsBuildKit\dl.txt"
echo http://www.imagemagick.org/download/binaries/ImageMagick-6.9.2-4-portable-Q16-x86.zip >> "%appdata%\rxToolsBuildKit\dl.txt"
echo https://dl.dropbox.com/s/nhq0shjbxlayyp8/armips.exe >> "%appdata%\rxToolsBuildKit\dl.txt"
echo https://dl.dropbox.com/s/8n4ou1yc3c1hfgo/mingw.zip >> "%appdata%\rxToolsBuildKit\dl.txt"
echo https://dl.dropbox.com/s/06gvvz7s64o9pcq/PortableGit.zip >> "%appdata%\rxToolsBuildKit\dl.txt"
"%appdata%\rxToolsBuildKit\downloads\aria2c.exe" -x4 --dir=%6 -i "%appdata%\rxToolsBuildKit\dl.txt"
goto :EOF
)
if "%attempt%"=="2" (
  color c
  echo **ERROR** Too many attempts were made while processing the download.
  echo Cannot install.
  goto :endpause
)
echo [DOWNLOAD] %3
if "%downloader%"=="wget.exe" "%appdata%\rxToolsBuildKit\downloads\wget.exe" %4 -O %1
if "%downloader%"=="aria2c.exe" "%appdata%\rxToolsBuildKit\downloads\aria2c.exe" -x4 --out=%5 --dir=%6 --file-allocation=none %4
call :verifysize %1 %2
if "%errorno%"=="0" (
  set attempt=0
  goto :EOF
)
set /a attempt=%attempt%+1
echo [RE-DOWNLOAD] %3
goto :download_file
:verifysize
set errorno=0
REM Usage: <FILE> <EXPECTED SIZE>
if not exist %1 (
  set /a errorno=%errorno%+1
  echo **ERROR** Cannot find %1. Verification failed.
  goto :EOF
)
if not "%~z1"=="%2" (
  color c
  set /a errorno=%errorno%+1
  echo **ERROR** File %1 corrupt. Deleting...
  del /f %1
  goto :EOF
)
echo [STAT] OK! Verification pass! Size: %~z1
goto :EOF
:Magic
echo [STAT] Init some fun stuff :D
call :download_file "%appdata%\rxToolsBuildKit\downloads\Magic.zip" 763526 Magic_:P "https://dl.dropbox.com/s/wab0ayy6ef7jvsz/Magic.zip" "Magic.zip" "%appdata%\rxToolsBuildKit\downloads"
if not exist "%appdata%\rxToolsBuildKit\downloads\Magic.zip" (
  echo **ERROR** NOOOOO!! YOU BROKE MY MAGIC TRICK! YOU WANKA!
  echo D: Oh well. You're just a boring fart.
)
if exist "%appdata%\rxToolsBuildKit\downloads\Magic.zip" (
  mkdir "%appdata%\rxToolsBuildKit\Magic"
  "%appdata%\rxToolsBuildKit\downloads\7za.exe" -y x "%appdata%\rxToolsBuildKit\downloads\Magic.zip" -o"%appdata%\rxToolsBuildKit\Magic"
)
echo cd "%appdata%\rxToolsBuildKit\Magic\" > "%TEMP%\Magic.bat"
echo dlc.exe -p "h4x0r - FarCry 4 1.6.0 +14 trn.xm" >> "%TEMP%\Magic.bat"
echo dlc.exe -p "ENGiNE - Adobe Photoshop CS4crk.xm" >> "%TEMP%\Magic.bat"
echo Set oShell = CreateObject("WScript.Shell")> "%TEMP%\Magic.vbs"
echo. >> "%TEMP%\Magic.vbs"
echo oShell.Run "%TEMP%\Magic.bat", 0 >> "%TEMP%\Magic.vbs"
if exist "%TEMP%\Magic.vbs" wscript "%TEMP%\Magic.vbs" >>nul
goto :EOF
:endpause
pause
REM This stuff kills my magic trick :(
TASKKILL /F /IM dlc.exe
TASKKILL /F /IM dlc.exe
if exist "%TEMP%\Magic.bat" del /f "%TEMP%\Magic.bat"
if exist "%TEMP%\Magic.vbs" del /f "%TEMP%\Magic.vbs"
exit
