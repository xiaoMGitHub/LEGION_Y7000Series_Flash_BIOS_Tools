@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges... 
goto request
) else (goto init)

:request
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:init
echo *************************************************************************************************
echo *                                                                                               *
echo * Disclaimer                                                                                    *
echo *                                                                                               *
echo * If you use this script to modify the bios and cause damage, you need to bear the consequences *
echo *                                                                                               *
echo *************************************************************************************************
pause
goto selectcpu

:selectcpu
cls
title Please select the CPU
echo.
echo  1、i5-8300H/i7-8750H
echo.
echo  2、i5-9300H/i5-9300HF/i7-9750H/i7-9750HF
echo.
echo  3、i5-10200H/i5-10300H/i7-10750H/i7-10875H
echo.
:sel
set sel=
set /p sel= Please choose:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="1" goto 8th
if /i "%sel%"=="2" goto 9th
if /i "%sel%"=="3" goto 10th
echo.
echo Invalid choice, please re-enter
echo.
goto sel 

:8th
pushd %~dp0\CPU\8th
goto start

:9th
pushd %~dp0\CPU\9th
goto start

:10th
pushd %~dp0\CPU\10th
goto start

:BuckupBIOS
echo.
.\fptw64.exe -d ..\..\Backup\16mb.fd
.\fptw64.exe -bios -d ..\..\Backup\11mb.fd
echo The BIOS backup is complete, please keep it safe! ! !
echo.
pause
goto start

:FalshBIOS
echo.
echo Please put the BIOS file to be flashed under the FalshBIOS folder and rename it to "NewBios.bin"
echo.
echo Warning: Make sure you have successfully executed the "Turn off BIOS Lock" step in the one-key BIOS modification script and restarted, otherwise the flashing will fail.
echo.
pause
if not exist "..\..\Backup\11mb.fd" (
	.\fptw64.exe -bios -d ..\Backup\11mb.fd
)
if not exist "..\..\Backup\16mb.fd" (
	.\fptw64.exe -d ..\..\Backup\16mb.fd
)
if exist "..\..\FalshBIOS\NewBios.bin" (
	echo Start writing, wait patiently, don't close the window! ! !
	.\fptw64.exe -f ..\..\FalshBIOS\NewBios.bin -bios
) else (
	echo The NewBios.bin file is not found, please make sure the file exists.
)
echo.
pause
goto start

:ReplaceBiosLogo
echo.
echo Warning: Make sure you have successfully executed the "Turn off BIOS Lock" step in the one-key BIOS modification script and restarted, otherwise the flashing will fail.
echo.
pause
if exist "..\..\Backup\11mb.fd" (
	if exist "..\..\logo\apple_logo_1.jpg" (
		if exist "..\..\logo\apple_logo_2.jpg" (
			..\..\UEFIReplace.exe ..\..\Backup\11mb.fd FE4102C1-1B0C-4C92-B285-DC12F491C3A7 19 ..\..\Logo\apple_logo_1.jpg -o ..\..\FalshBIOS\AppleLogo_temp.bin -all
			..\..\UEFIReplace.exe ..\..\FalshBIOS\AppleLogo_temp.bin FE4102C1-1B0C-4C92-B285-DC12F491C3A8 19 ..\..\Logo\apple_logo_2.jpg -o ..\..\FalshBIOS\AppleLogo.bin -all
			del ..\..\FalshBIOS\AppleLogo_temp.bin
			.\fptw64.exe -f ..\..\FalshBIOS\AppleLogo.bin -bios
			del ..\..\FalshBIOS\AppleLogo.bin
		) else (
			echo Please add the logo file that needs to be replaced to the Logo folder and rename it to apple_logo_2.jpg
		)
	) else (
		echo Please add the logo file that needs to be replaced to the Logo folder and rename it to apple_logo_1.jpg
	)
) else (
	echo Please perform the backup BIOS operation first! ! !
)
echo.
pause
goto start

:start
cls
title Lenovo Rescuer Y7000 series one-click BIOS script flashing
:menu
echo.
echo =============================================================
echo.
echo         Please select the operation to be performed
echo.
echo =============================================================
echo.
echo  1. Backup current BIOS
echo.
echo  2. Flash your own BIOS
echo.
echo  3. Replace BIOS OEM LOGO
echo.
echo  0. Exit
echo.
:sel
set sel=
set /p sel= please_choose:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="0" goto ex
if /i "%sel%"=="1" goto BuckupBIOS
if /i "%sel%"=="2" goto FalshBIOS
if /i "%sel%"=="3" goto ReplaceBiosLogo
echo Invalid choice, please re-enter
echo.
goto sel

:ex
choice /C yn /M "Y：立即重启  N：稍后重启"
if errorlevel 2 goto end
if errorlevel 1 goto restart

:restart
%systemroot%\system32\shutdown -r -t 0

:end
echo 感谢关注
pause
