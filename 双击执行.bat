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
echo *                  ��������                       *
echo *                                                 *
echo *  ʹ�ñ��ű��޸�bios�����𻵵ģ������ге������ *
echo *                                                 *
echo *               ת����ע������                    *
echo *                                                 *
echo ***************************************************
pause
goto selectcpu

:selectcpu
cls
title ��ѡ�������ͺ�
echo.
echo  1��i5-8300H/i7-8750H
echo.
echo  2��i5-9300H/i5-9300HF/i7-9750H/i7-9750HF
echo.
echo  3��i5-10200H/i5-10300H/i7-10750H/i7-10875H
echo.
:sel
set sel=
set /p sel= ��ѡ��:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="1" goto 8th
if /i "%sel%"=="2" goto 9th
if /i "%sel%"=="3" goto 10th
echo.
echo ѡ����Ч������������
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
echo ����BIOS��ɣ������Ʊ��ܣ�����
echo.
pause
goto start

:FalshBIOS
echo.
echo �뽫��Ҫˢд��BIOS�ļ����� FalshBIOS �ļ����²�������Ϊ"NewBios.bin"
echo.
echo ���棺ȷ���Ѿ��ɹ�ִ����һ���޸�BIOS�ű��е� "�ر� BIOS Lock" ���貢�����������ˢдʧ�ܡ�
echo.
pause
if not exist "..\..\Backup\11mb.fd" (
	.\fptw64.exe -bios -d ..\Backup\11mb.fd
)
if not exist "..\..\Backup\16mb.fd" (
	.\fptw64.exe -d ..\..\Backup\16mb.fd
)
if exist "..\..\FalshBIOS\NewBios.bin" (
	echo ��ʼд�룬���ĵȴ�������رմ��ڣ�����
	.\fptw64.exe -f ..\..\FalshBIOS\NewBios.bin -bios
) else (
	echo û���ҵ� NewBios.bin �ļ�����ȷ���ļ����ڡ�
)
echo.
pause
goto start

:ReplaceBiosLogo
echo.
echo ���棺ȷ���Ѿ��ɹ�ִ����һ���޸�BIOS�ű��е� "�ر� BIOS Lock" ���貢�����������ˢдʧ�ܡ�
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
			echo �뽫��Ҫ�滻�� logo �ļ���ӵ� Logo �ļ����У���������Ϊ apple_logo_2.jpg
		)
	) else (
		echo �뽫��Ҫ�滻�� logo �ļ���ӵ� Logo �ļ����У���������Ϊ apple_logo_1.jpg
	)
) else (
	echo ����ִ�б���BIOS����������
)
echo.
pause
goto start

:start
cls
title ���������� Y7000 ϵ��һ��ˢ BIOS �ű�
:menu
echo.
echo =============================================================
echo.
echo                   ��ѡ��Ҫ���еĲ���
echo.
echo            ������Y7000ϵ�к�ƻ��Ⱥ��477839538
echo.
echo =============================================================
echo.
echo  1�����ݵ�ǰ BIOS
echo.
echo  2��ˢд���� BIOS
echo.
echo  3���滻 BIOS OEM LOGO
echo.
echo  0���˳�
echo.
:sel
set sel=
set /p sel= ��ѡ��:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="0" goto ex
if /i "%sel%"=="1" goto BuckupBIOS
if /i "%sel%"=="2" goto FalshBIOS
if /i "%sel%"=="3" goto ReplaceBiosLogo
echo ѡ����Ч������������
echo.
goto sel

:ex
choice /C yn /M "Y����������  N���Ժ�����"
if errorlevel 2 goto end
if errorlevel 1 goto restart

:restart
%systemroot%\system32\shutdown -r -t 0

:end
echo ��л��ע
pause