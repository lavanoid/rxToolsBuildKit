echo off
if [%1] EQU [] (
  echo No argument specified!
)
if [%2] EQU [] (
  echo No file size specified!
)
if not "%~z1"=="%2" (
  color c
  echo **ERROR** File %1 corrupt.
  set error=true
)
echo [STAT] OK! Verification pass! Size: %~z1
