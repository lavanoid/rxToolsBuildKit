echo off
set INS_DATA=%appdata%\rxToolsBuildKit
if not exist "%INS_DATA%\stuff\aria2c.exe" call "%INS_DATA%\stuff\download_aria2.bat"
if not exist "%INS_DATA%\stuff\aria2c.exe" (
  echo **ERROR** Could not find "%INS_DATA%\stuff\aria2c.exe"!
  color c
  set error=true
  goto :EOF
)
if not exist "%INS_DATA%\downloads" mkdir "%INS_DATA%\downloads"
"%INS_DATA%\stuff\aria2c.exe" -x4 --out="python-2.7.10.msi" --dir="%INS_DATA%\downloads" --file-allocation=none "https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi"
if not exist "%INS_DATA%\stuff\verify_file.bat" (
  echo **ERROR* Could not verify the file! "%INS_DATA%\stuff\verify_file.bat" is missing!
  color c
  goto :EOF
)
"%INS_DATA%\stuff\verify_file.bat" "%INS_DATA%\downloads\python-2.7.10.msi" 18423808
if "%error%"=="true" (
  echo **ERROR** File has failed verification. Cannot continue.
  color c
  goto :EOF
)
explorer "%INS_DATA%\downloads\python-2.7.10.msi"
