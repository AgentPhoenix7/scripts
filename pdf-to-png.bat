@echo off
setlocal

set "INPUT=%~1"
set "OUTPUT_DIR=%~2"

if "%INPUT%"=="" (
    echo Usage: pdf-to-png.bat input.pdf [output_folder]
    exit /b 1
)

:: Extract PDF filename without extension
set "PDF_NAME=%~n1"

if "%OUTPUT_DIR%"=="" set "OUTPUT_DIR=png_pages"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

gswin64c.exe ^
  -dSAFER ^
  -dBATCH ^
  -dNOPAUSE ^
  -sDEVICE=png16m ^
  -r300 ^
  -sOutputFile="%OUTPUT_DIR%\%PDF_NAME%-%%03d.png" ^
  "%INPUT%"

echo.
echo PNG pages saved to: %OUTPUT_DIR%
endlocal
