@echo off
setlocal
cd /d %~dp0
echo Minecraft Java Edition Server Installer 0.1.0
echo

if %1%="" (goto FullAuto) else (echo Argument Still Not Supported.) 

:FullAuto
echo Running Full Auto Mode.
if exist .\MCJEServer\server.jar (goto RunServer) else (goto CreateFiles)

:CreateFiles
mkdir .\MCJEServer\ &cd .\MCJEServer\
set url = https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_windows-x64_bin.zip
set file = .\jdk17.zip
certutil -urlcache -split -f %url% %file%
certutil -urlcache -split -f https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar server18.1.jar
Call :UnZipFile ".\" ".\jdk17.zip"
.\jdk-17\bin\java.exe -jar server18.1.jar
if exist eula.txt del /f /q eula.txt
echo eula=true > eula.txt
goto RunServer

:RunServer
.\jdk-17\bin\java.exe -jar server18.1.jar

exit /b

:UnZipFile <ExtractTo> <newzipfile>
set vbs="_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%