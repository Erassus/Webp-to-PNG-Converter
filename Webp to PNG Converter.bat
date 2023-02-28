@ECHO OFF

:: Set the title of the window.

TITLE Webp to PNG Converter

:: Check OS architecture

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==64BIT (
  GOTO BEGIN
) ELSE (
  ECHO Webp to PNG Converter can't run in 32bit Operating System.
  EXIT
)

:BEGIN

:: Set the variable of the URL to download. Using Version 1.3.0 from https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html

SET "URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0-windows-x64.zip"

:: Set the variable of the file name with extension.

SET "FILE=libwebp-1.3.0-windows-x64.zip"

:: Set the variable of the folder name.

SET "FOLDER=libwebp-1.3.0-windows-x64"

:: Set the variable of the full path file with extension.

SET "FULLPATH=%TEMP%\%FILE%"

:: Set the variable of dwebp binary file.

SET "DWEBP=%APPDATA%\libwebp\bin\dwebp.exe"

:: Checks if dwebp was unzipped before.

IF EXIST %DWEBP% (
  GOTO INIT
) ELSE (
  GOTO DOWNLOAD
)

:: If already downloaded before, then skip.

:DOWNLOAD

IF EXIST %FULLPATH% (
  TITLE Extracting binary files
  PowerShell -Command "& {Expand-Archive "%FULLPATH%" -DestinationPath %APPDATA%}"
) ELSE (
  TITLE Downloading libwebp 1.3.0 x64 binary files
  PowerShell -Command "& {Invoke-WebRequest -Uri "%URL%" -OutFile "%FULLPATH%"}"
  TITLE Extracting binary files
  PowerShell -Command "& {Expand-Archive "%FULLPATH%" -DestinationPath %APPDATA%}"
)

TITLE Webp to PNG Converter

REN %APPDATA%\%FOLDER% libwebp

:INIT

:: Checks if libwebp temp folder exists, if not, it will be created.

IF EXIST %TEMP%\libwebp\ (
  GOTO INPUT
) ELSE (
  MKDIR %TEMP%\libwebp
)

:INPUT

:: Checks if input folder exists, if not, it will be created.

IF EXIST %TEMP%\libwebp\input\ (
  DEL %TEMP%\libwebp\input\*.* /f /s /q
  CLS
  GOTO CONFIRM
) ELSE (
  MKDIR %TEMP%\libwebp\input
)

:CONFIRM

:: Confirmation and advise section to put the .webp files inside input folder.

SET "HELP=Please put .webp files here for conversion.txt"
ECHO.>"%TEMP%\libwebp\input\%HELP%" 0
SET "ADVISE=Please put .webp files in the input folder"
ECHO %ADVISE%
EXPLORER %TEMP%\libwebp\input
ECHO.
PAUSE
CLS

:: Checks if output folder exist, if not, will be created.

IF EXIST %TEMP%\libwebp\output\ (
  GOTO CONVERSION
) ELSE (
  MKDIR %TEMP%\libwebp\output
)

:: Call dwebp.exe for conversion

:CONVERSION

for %%f in (%TEMP%\libwebp\input\*.webp) do %DWEBP% -o "%TEMP%\libwebp\output\%%~nf.png" "%%f"


:: Open Output folder.

EXPLORER %TEMP%\libwebp\output

ECHO.

PAUSE