echo off
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