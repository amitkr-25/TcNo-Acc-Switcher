REM Move is currently only for build, as moving the files seems to prevent the program from running properly...

REM Get current directory:
echo Current directory: %cd%
set origDir=%cd%

REM Move updater files in Debug folder (for Visual Studio):
IF not exist bin\x64\Debug\net5.0-windows\ GOTO vsRel
IF EXIST bin\x64\Debug\net5.0-windows\updater GOTO vsRel
cd %origDir%\bin\x64\Debug\net5.0-windows\
ECHO -----------------------------------
ECHO Moving files for x64 Debug in Visual Studio
ECHO -----------------------------------
mkdir updater
mkdir updater\x64
mkdir updater\x86
mkdir updater\ref
copy /B /Y "VCDiff.dll" "updater\VCDiff.dll"
copy /B /Y "YamlDotNet.dll" "updater\YamlDotNet.dll"
move /Y "TcNo_Acc_Switcher_Updater.runtimeconfig.json" "updater\TcNo_Acc_Switcher_Updater.runtimeconfig.json"
move /Y "TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json" "updater\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json"
move /Y "TcNo_Acc_Switcher_Updater.pdb" "updater\TcNo_Acc_Switcher_Updater.pdb"
move /Y "TcNo_Acc_Switcher_Updater.exe" "updater\TcNo_Acc_Switcher_Updater.exe"
copy /B /Y "TcNo_Acc_Switcher_Updater.dll" "updater\TcNo_Acc_Switcher_Updater.dll"
move /Y "TcNo_Acc_Switcher_Updater.deps.json" "updater\TcNo_Acc_Switcher_Updater.deps.json"
copy /B /Y "SevenZipExtractor.dll" "updater\SevenZipExtractor.dll"
move /Y "x86\7z.dll" "updater\x86\7z.dll"
move /Y "x64\7z.dll" "updater\x64\7z.dll"
copy /B /Y "ref\TcNo_Acc_Switcher_Updater.dll" "updater\ref\TcNo_Acc_Switcher_Updater.dll"
copy /B /Y "Newtonsoft.Json.dll" "updater\Newtonsoft.Json.dll"
RMDIR /Q/S "runtimes\linux-musl-x64"
RMDIR /Q/S "runtimes\linux-x64"
RMDIR /Q/S "runtimes\osx"
RMDIR /Q/S "runtimes\osx-x64"
RMDIR /Q/S "runtimes\unix"
RMDIR /Q/S "runtimes\win-arm64"
RMDIR /Q x64
RMDIR /Q x86
copy /B /Y "..\..\..\Installer\_First_Run_Installer.exe" "_First_Run_Installer.exe"
REN "wwwroot" "originalwwwroot"
cd %origDir%
GOTO end

REM Move updater files in Release folder (for Visual Studio):
:vsRel
REM SET VARIABLES
REM If SIGNTOOL environment variable is not set then try setting it to a known location
if "%SIGNTOOL%"=="" set SIGNTOOL=%ProgramFiles(x86)%\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe
REM Check to see if the signtool utility is missing
if exist "%SIGNTOOL%" goto ST
    REM Give error that SIGNTOOL environment variable needs to be set
    echo "Must set environment variable SIGNTOOL to full path for signtool.exe code signing utility"
    echo Location is of the form "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\bin\signtool.exe"
    exit -1
:ST

REM Set NSIS path for building the installer
if "%NSIS%"=="" set NSIS=%ProgramFiles(x86)%\NSIS\makensis.exe
if exist "%NSIS%" goto NS
    REM Give error that NSIS environment variable needs to be set
    echo "Must set environment variable NSIS to full path for makensis.exe"
    echo Location is of the form "C:\Program Files (x86)\NSIS\makensis.exe"
    exit -1
:NS


REM Set 7-Zip path for compressing built files
if "%zip%"=="" set zip=C:\Program Files\7-Zip\7z.exe
if exist "%zip%" goto ZJ
    REM Give error that NSIS environment variable needs to be set
    echo "Must set environment variable 7-Zip to full path for 7z.exe"
    echo Location is of the form "C:\Program Files\7-Zip\7z.exe"
    exit -1
:ZJ

IF NOT EXIST bin\x64\Release\net5.0-windows\ GOTO ghDebug
IF EXIST bin\x64\Release\net5.0-windows\updater GOTO end
cd %origDir%\bin\x64\Release\net5.0-windows\
ECHO -----------------------------------
ECHO Moving files for x64 Release in Visual Studio
ECHO -----------------------------------
mkdir updater
mkdir updater\x64
mkdir updater\x86
mkdir updater\ref
copy /B /Y "..\..\..\Installer\_First_Run_Installer.exe" "_First_Run_Installer.exe"
REM Signing
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a _First_Run_Installer.exe
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher.exe
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher.dll
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Server.exe
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Server.dll
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Tray.exe
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Tray.dll
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Globals.dll
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Updater.exe
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a TcNo_Acc_Switcher_Updater.dll
copy /B /Y "VCDiff.dll" "updater\VCDiff.dll"
copy /B /Y "YamlDotNet.dll" "updater\YamlDotNet.dll"
move /Y "TcNo_Acc_Switcher_Updater.runtimeconfig.json" "updater\TcNo_Acc_Switcher_Updater.runtimeconfig.json"
move /Y "TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json" "updater\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json"
move /Y "TcNo_Acc_Switcher_Updater.pdb" "updater\TcNo_Acc_Switcher_Updater.pdb"
move /Y "TcNo_Acc_Switcher_Updater.exe" "updater\TcNo_Acc_Switcher_Updater.exe"
copy /B /Y "TcNo_Acc_Switcher_Updater.dll" "updater\TcNo_Acc_Switcher_Updater.dll"
move /Y "TcNo_Acc_Switcher_Updater.deps.json" "updater\TcNo_Acc_Switcher_Updater.deps.json"
copy /B /Y "SevenZipExtractor.dll" "updater\SevenZipExtractor.dll"
move /Y "x86\7z.dll" "updater\x86\7z.dll"
move /Y "x64\7z.dll" "updater\x64\7z.dll"
copy /B /Y "ref\TcNo_Acc_Switcher_Updater.dll" "updater\ref\TcNo_Acc_Switcher_Updater.dll"
copy /B /Y "Newtonsoft.Json.dll" "updater\Newtonsoft.Json.dll"
RMDIR /Q/S "runtimes\linux-musl-x64"
RMDIR /Q/S "runtimes\linux-x64"
RMDIR /Q/S "runtimes\osx"
RMDIR /Q/S "runtimes\osx-x64"
RMDIR /Q/S "runtimes\unix"
RMDIR /Q/S "runtimes\win-arm64"
RMDIR /Q x64
RMDIR /Q x86
REN "wwwroot" "originalwwwroot"
cd ..\
RMDIR /Q/S %origDir%\bin\x64\Release\TcNo_Acc_Switcher
REN "net5.0-windows" "TcNo_Acc_Switcher"

REM Copy out updater for update creation
xcopy TcNo_Acc_Switcher\updater updater /E /H /C /I /Y

REM Compress files
echo Creating .7z archive
"%zip%" a -t7z -mmt24 -mx9  "TcNo_Acc_Switcher.7z" "TcNo_Acc_Switcher"
echo Done!

REM Create installer
echo Creating installer
"%NSIS%" "%origDir%\..\other\NSIS\nsis-build-x64.nsi"
echo Done. Moving...
move /Y "..\..\..\..\other\NSIS\TcNo Account Switcher - Installer.exe" "TcNo Account Switcher - Installer.exe"
"%SIGNTOOL%" sign /tr http://timestamp.sectigo.com?td=sha256 /td SHA256 /fd SHA256 /a "TcNo Account Switcher - Installer.exe"

cd %origDir%
GOTO end



REM Move updater files in Debug folder (for GitHub Actions):
:ghDebug
IF NOT EXIST bin\Debug\net5.0-windows\ GOTO ghRel
IF EXIST bin\Debug\net5.0-windows\updater GOTO ghRel
cd %origDir%
ECHO -----------------------------------
ECHO Moving files for x64 Debug in GitHub
ECHO -----------------------------------
mkdir bin\Debug\net5.0-windows\updater
mkdir bin\Debug\net5.0-windows\updater\x64
mkdir bin\Debug\net5.0-windows\updater\x86
mkdir bin\Debug\net5.0-windows\updater\ref
copy /B /Y "bin\Debug\net5.0-windows\VCDiff.dll" "bin\Debug\net5.0-windows\updater\VCDiff.dll"
copy /B /Y "bin\Debug\net5.0-windows\YamlDotNet.dll" "bin\Debug\net5.0-windows\updater\YamlDotNet.dll"
move /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.runtimeconfig.json" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.runtimeconfig.json"
move /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json"
move /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.pdb" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.pdb"
move /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.exe" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.exe"
copy /B /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.dll" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.dll"
move /Y "bin\Debug\net5.0-windows\TcNo_Acc_Switcher_Updater.deps.json" "bin\Debug\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.deps.json"
copy /B /Y "bin\Debug\net5.0-windows\SevenZipExtractor.dll" "bin\Debug\net5.0-windows\updater\SevenZipExtractor.dll"
move /Y "bin\Debug\net5.0-windows\x86\7z.dll" "bin\Debug\net5.0-windows\updater\x86\7z.dll"
move /Y "bin\Debug\net5.0-windows\x64\7z.dll" "bin\Debug\net5.0-windows\updater\x64\7z.dll"
copy /B /Y "bin\Debug\net5.0-windows\ref\TcNo_Acc_Switcher_Updater.dll" "bin\Debug\net5.0-windows\updater\ref\TcNo_Acc_Switcher_Updater.dll"
copy /B /Y "bin\Debug\net5.0-windows\Newtonsoft.Json.dll" "bin\Debug\net5.0-windows\updater\Newtonsoft.Json.dll"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\linux-musl-x64"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\linux-x64"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\osx"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\osx-x64"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\unix"
RMDIR /Q/S "bin\Debug\net5.0-windows\runtimes\win-arm64"
RMDIR /Q "bin\Release\net5.0-windows\x64"
RMDIR /Q "bin\Release\net5.0-windows\x86"
copy /B /Y "..\..\Installer\_First_Run_Installer.exe" "_First_Run_Installer.exe"
REN "wwwroot" "originalwwwroot"
cd %origDir%
GOTO end

REM Move updater files in Release folder (for GitHub Actions):
:ghRel
IF NOT EXIST bin\Release\net5.0-windows\ GOTO end
IF EXIST bin\Release\net5.0-windows\updater GOTO end
cd %origDir%
ECHO -----------------------------------
ECHO Moving files for x64 Release in GitHub
ECHO -----------------------------------
mkdir bin\Release\net5.0-windows\updater
mkdir bin\Release\net5.0-windows\updater\x64
mkdir bin\Release\net5.0-windows\updater\x86
mkdir bin\Release\net5.0-windows\updater\ref
copy /B /Y "bin\Release\net5.0-windows\VCDiff.dll" "bin\Release\net5.0-windows\updater\VCDiff.dll"
copy /B /Y "bin\Debug\net5.0-windows\YamlDotNet.dll" "bin\Debug\net5.0-windows\updater\YamlDotNet.dll"
move /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.runtimeconfig.json" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.runtimeconfig.json"
move /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.runtimeconfig.dev.json"
move /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.pdb" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.pdb"
move /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.exe" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.exe"
copy /B /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.dll" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.dll"
move /Y "bin\Release\net5.0-windows\TcNo_Acc_Switcher_Updater.deps.json" "bin\Release\net5.0-windows\updater\TcNo_Acc_Switcher_Updater.deps.json"
copy /B /Y "bin\Release\net5.0-windows\SevenZipExtractor.dll" "bin\Release\net5.0-windows\updater\SevenZipExtractor.dll"
move /Y "bin\Release\net5.0-windows\x86\7z.dll" "bin\Release\net5.0-windows\updater\x86\7z.dll"
move /Y "bin\Release\net5.0-windows\x64\7z.dll" "bin\Release\net5.0-windows\updater\x64\7z.dll"
copy /B /Y "bin\Release\net5.0-windows\ref\TcNo_Acc_Switcher_Updater.dll" "bin\Release\net5.0-windows\updater\ref\TcNo_Acc_Switcher_Updater.dll"
copy /B /Y "bin\Release\net5.0-windows\Newtonsoft.Json.dll" "bin\Release\net5.0-windows\updater\Newtonsoft.Json.dll"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\linux-musl-x64"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\linux-x64"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\osx"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\osx-x64"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\unix"
RMDIR /Q/S "bin\Release\net5.0-windows\runtimes\win-arm64"
RMDIR /Q "bin\Release\net5.0-windows\x64"
RMDIR /Q "bin\Release\net5.0-windows\x86"
copy /B /Y "..\..\Installer\_First_Run_Installer.exe" "_First_Run_Installer.exe"
REN "wwwroot" "originalwwwroot"
cd %origDir%
GOTO end

:end