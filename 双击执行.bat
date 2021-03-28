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
echo ***************************************************
echo *                                                 *
echo *                  免责声明                       *
echo *                                                 *
echo *  使用本脚本修改bios导致损坏的，需自行承担后果。 *
echo *                                                 *
echo *               转载请注明出处                    *
echo *                                                 *
echo ***************************************************
pause
goto selectcpu

:selectcpu
cls
title 请选择处理器型号
echo.
echo  1、i5-8300H/i7-8750H
echo.
echo  2、i5-9300H/i5-9300HF/i7-9750H/i7-9750HF
echo.
echo  3、i5-10200H/i5-10300H/i7-10750H/i7-10875H
echo.
:sel
set sel=
set /p sel= 请选择:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="1" goto 8th
if /i "%sel%"=="2" goto 9th
if /i "%sel%"=="3" goto 10th
echo.
echo 选择无效，请重新输入
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
echo 备份BIOS完成，请妥善保管！！！
echo.
pause
goto start

:FalshBIOS
echo.
echo 请将需要刷写的BIOS文件放在 FalshBIOS 文件夹下并重命名为"NewBios.bin"
echo.
echo 警告：确保已经成功执行了一键修改BIOS脚本中的 "关闭 BIOS Lock" 步骤并重启，否则会刷写失败。
echo.
pause
if not exist "..\..\Backup\11mb.fd" (
	.\fptw64.exe -bios -d ..\Backup\11mb.fd
)
if not exist "..\..\Backup\16mb.fd" (
	.\fptw64.exe -d ..\..\Backup\16mb.fd
)
if exist "..\..\FalshBIOS\NewBios.bin" (
	echo 开始写入，耐心等待，请勿关闭窗口！！！
	.\fptw64.exe -f ..\..\FalshBIOS\NewBios.bin -bios
) else (
	echo 没有找到 NewBios.bin 文件，请确认文件存在。
)
echo.
pause
goto start

:ReplaceBiosLogo
echo.
echo 警告：确保已经成功执行了一键修改BIOS脚本中的 "关闭 BIOS Lock" 步骤并重启，否则会刷写失败。
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
			echo 请将需要替换的 logo 文件添加到 Logo 文件夹中，并重命名为 apple_logo_2.jpg
		)
	) else (
		echo 请将需要替换的 logo 文件添加到 Logo 文件夹中，并重命名为 apple_logo_1.jpg
	)
) else (
	echo 请先执行备份BIOS操作！！！
)
echo.
pause
goto start

:start
cls
title 联想拯救者 Y7000 系列一键刷 BIOS 脚本
:menu
echo.
echo =============================================================
echo.
echo                   请选择要进行的操作
echo.
echo            拯救者Y7000系列黑苹果群：780936290
echo.
echo =============================================================
echo.
echo  1、备份当前 BIOS
echo.
echo  2、刷写自制 BIOS
echo.
echo  3、替换 BIOS OEM LOGO
echo.
echo  0、退出
echo.
:sel
set sel=
set /p sel= 请选择:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="0" goto ex
if /i "%sel%"=="1" goto BuckupBIOS
if /i "%sel%"=="2" goto FalshBIOS
if /i "%sel%"=="3" goto ReplaceBiosLogo
echo 选择无效，请重新输入
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
