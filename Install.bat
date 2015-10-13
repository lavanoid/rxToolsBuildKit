echo off
Title = Environment installer
set INS_DATA=%appdata%\rxToolsBuildKit
set INS_MUSIC=yepyep
%~d0
cd %~dp0
if not exist "%INS_DATA%\scripts" mkdir "%INS_DATA%\scripts"
if not exist "%INS_DATA%\scripts" (
  echo **ERROR** Failed to create the scripts directory!
  color c
  pause >nul
  goto :EOF
)
echo [STAT] Getting install scripts.
REM ############### DOWNLOAD STUFF ###############
REM Usage: call :download <LINK> <SAVE AS>
if "%1"=="no_music" set INS_MUSIC=nopenopenope
if "%2"=="no_music" set INS_MUSIC=nopenopenope
if "%INS_MUSIC%"=="yepyep" (
  echo [DOWNLOAD] Music
  call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/playmahmusic.bat" "%INS_DATA%\scripts\playmahmusic.bat"
)
echo [DOWNLOAD] DownloadAria2
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/download_aria2.bat" "%INS_DATA%\scripts\download_aria2.bat"
echo [DOWNLOAD] DownloadVBS
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/download_vbs.bat" "%INS_DATA%\scripts\download_vbs.bat"
echo [DOWNLOAD] Install Python2
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/install_python.bat" "%INS_DATA%\scripts\install_python.bat"
echo [DOWNLOAD] Install DevkitPro
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/install_devkitpro.bat" "%INS_DATA%\scripts\install_devkitpro.bat"
echo [DOWNLOAD] Install MinGW
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/install_minGW.bat" "%INS_DATA%\scripts\install_minGW.bat"
echo [DOWNLOAD] Install Git
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/install_git.bat" "%INS_DATA%\scripts\install_git.bat"
echo [DOWNLOAD] Install Armips
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/install_armips.bat" "%INS_DATA%\scripts\install_armips.bat"
echo [DOWNLOAD] System Backup
call :download "https://raw.githubusercontent.com/lavanoid/rxToolsBuildKit/master/stuff/system_backup.bat" "%INS_DATA%\scripts\system_backup.bat"
if "%1"=="no_install" goto :EOF
if "%2"=="no_install" goto :EOF
REM ############### INSTALL STUFF ###############
if "%INS_MUSIC%"=="yepyep" call "%INS_DATA%\scripts\playmahmusic.bat"
call "%INS_DATA%\scripts\system_backup.bat"
call "%INS_DATA%\scripts\install_python.bat"
call "%INS_DATA%\scripts\install_devkitpro.bat"
call "%INS_DATA%\scripts\install_minGW.bat"
call "%INS_DATA%\scripts\install_git.bat"
call "%INS_DATA%\scripts\install_armips.bat"
goto :EOF
:download
REM Usage: <DOWNLOAD_LINK> <SAVE AS> <EXPECTED SIZE>
REM Expected size DOES NOT have to be specified.
echo if WScript.Arguments.Count ^< 1 then > "%INS_DATA%\dl.vbs"
echo   MsgBox "Usage: wget.vbs ^<url^> ^(file^)" >> "%INS_DATA%\dl.vbs"
echo   WScript.Quit >> "%INS_DATA%\dl.vbs"
echo end if >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo ' Arguments >> "%INS_DATA%\dl.vbs"
echo URL = WScript.Arguments^(0^) >> "%INS_DATA%\dl.vbs"
echo if WScript.Arguments.Count ^> 1 then >> "%INS_DATA%\dl.vbs"
echo   saveTo = WScript.Arguments^(1^) >> "%INS_DATA%\dl.vbs"
echo else >> "%INS_DATA%\dl.vbs"
echo   parts = split^(url,"/"^) >> "%INS_DATA%\dl.vbs"
echo   saveTo = parts^(ubound(parts)^) >> "%INS_DATA%\dl.vbs"
echo end if >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo ' Fetch the file >> "%INS_DATA%\dl.vbs"
echo Set objXMLHTTP = CreateObject^("MSXML2.ServerXMLHTTP"^) >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo objXMLHTTP.open "GET", URL, false >> "%INS_DATA%\dl.vbs"
echo objXMLHTTP.send() >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo If objXMLHTTP.Status = 200 Then >> "%INS_DATA%\dl.vbs"
echo Set objADOStream = CreateObject^("ADODB.Stream"^) >> "%INS_DATA%\dl.vbs"
echo objADOStream.Open >> "%INS_DATA%\dl.vbs"
echo objADOStream.Type = 1 'adTypeBinary >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo objADOStream.Write objXMLHTTP.ResponseBody >> "%INS_DATA%\dl.vbs"
echo objADOStream.Position = 0    'Set the stream position to the start >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo Set objFSO = Createobject^("Scripting.FileSystemObject"^) >> "%INS_DATA%\dl.vbs"
echo If objFSO.Fileexists^(saveTo^) Then objFSO.DeleteFile saveTo >> "%INS_DATA%\dl.vbs"
echo Set objFSO = Nothing >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo objADOStream.SaveToFile saveTo >> "%INS_DATA%\dl.vbs"
echo objADOStream.Close >> "%INS_DATA%\dl.vbs"
echo Set objADOStream = Nothing >> "%INS_DATA%\dl.vbs"
echo End if >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo Set objXMLHTTP = Nothing >> "%INS_DATA%\dl.vbs"
echo.>> "%INS_DATA%\dl.vbs"
echo ' Done >> "%INS_DATA%\dl.vbs"
echo WScript.Quit >> "%INS_DATA%\dl.vbs"
if not exist "%INS_DATA%\dl.vbs" (
  color c
  echo **ERROR** Failed to write the VBS file!
  echo Did you spill drink on the computer again? YOU WANKA!
  goto :endpause
)
wscript "%INS_DATA%\dl.vbs" %1 %2
if not [%3] EQU [] call :verify %2 %3
goto :EOF
:verify
REM Usage: <FILE> <EXPECTED SIZE>
set errorno=0
if not exist %1 (
  set /a errorno=%errorno%+1
  echo **ERROR** Cannot find %1. Verification failed.
  goto :EOF
)
if not "%~z1"=="%2" (
  color c
  set /a errorno=%errorno%+1
  echo **ERROR** File %1 corrupt.
)
echo [STAT] OK! Verification pass! Size: %~z1
goto :EOF