echo off
set INS_DATA=%appdata%\rxToolsBuildKit
echo [DOWNLOAD] Aria2.exe
if not exist "%INS_DATA%\stuff\download_vbs.bat" (
  echo **ERROR** Could not find "%INS_DATA%\stuff\download_vbs.bat"!
  color c
  goto :EOF
)
call "%INS_DATA%\stuff\download_vbs.bat" "https://dl.dropbox.com/s/yr0z9boob1w5elx/aria2c.exe" "%INS_DATA%\stuff\aria2c.exe"
if not exist "%INS_DATA%\stuff\aria2c.exe" (
  echo Failed to download aria2c!
  set error=true
)
if not exist "%INS_DATA%\stuff\verify_file.bat" (
  echo **ERROR* Could not verify the file! "%INS_DATA%\stuff\verify_file.bat" is missing!
  color c
  goto :EOF
)
"%INS_DATA%\stuff\verify_file.bat" "%INS_DATA%\stuff\aria2c.exe" 4456448
if "%error%"=="true" (
  echo **ERROR** File has failed verification. Cannot continue.
  color c
  goto :EOF
)