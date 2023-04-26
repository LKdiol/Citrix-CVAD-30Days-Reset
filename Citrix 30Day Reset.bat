@echo off
::경로지정
:: cd "C:\Citrix Broker Reset"
set location=%~dp0
cd %location%

echo Citrix 30Day Trial License 초기화
title 시트릭스 30일 License 초기화 툴

echo 구성 준비중...
set loweruuid=80ef19ea-bc65-4daa-b241-f6a68c702a94
powershell "Get-wmiobject -class win32_product | where name -eq """Citrix Broker Service"""" |findstr IdentifyingNumber > "%TEMP%\Identifying.log"
powershell "(Get-Content '%TEMP%\Identifying.log').ToLower()" > "%TEMP%\Identifying2.log"
set /p brokeruuid=<"%TEMP%\Identifying.log"
set /p loweruuid=<"%TEMP%\Identifying2.log"
del /f /s /q "%TEMP%\Identifying*" >nul
cls

:: HighAvailability 서비스 구성파일 컴파일
IF EXIST "HighAvailability Service\HighAvailabilityService.exe" (
goto install
) ELSE (
 goto package
)
pause

:install
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                □□□□□□□□□□□□□□□□□□□□□□□□ [000%%.] 
echo. 
:: Citrix 브로커 및 HA 서비스 종료 구간
net stop "Citrix High Availability Service" /Y >nul
timeout -nobreak 2 >nul
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ###□□□□□□□□□□□□□□□□□□□□□ [005%%.] 
net stop "Citrix Broker Service" /Y >nul
net stop "Citrix Broker Service" /Y >nul
cls
:: Citrix 브로커 서비스 제거 구간
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ######□□□□□□□□□□□□□□□□□□ [015%%.] 
echo. 
msiexec /x Broker_Service_x64.msi /quiet 
timeout -nobreak 3 >nul
cls
:: Citrix 브로커 서비스 7 1912 버전 설치 구간
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ##########□□□□□□□□□□□□□□ [030%%.] 
echo.
msiexec /i 1912Broker_Service_x64.msi /quiet 
:: Citrix High Availability 서비스 재구성 구간
copy /y "1912HighAvailability Service\*.*" "C:\Program Files\Citrix\Broker\Service" >nul
sc create "CitrixHighAvailabilityService" DisplayName="Citrix High Availability Service" binPath="C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Type" /t REG_DWORD /d 16 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Start" /t REG_DWORD /d 2 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ErrorControl" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ImagePath" /t REG_EXPAND_SZ /d "C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "DisplayName" /t REG_SZ /d "Citrix High Availability Service" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ObjectName" /t REG_SZ /d "NT AUTHORITY\NetworkService" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Description" /t REG_SZ /d "The Citrix High Availability service provides continuity of service during outage of central site." >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "FailureActions" /t REG_BINARY /d 80510100010000000100000003000000140000000100000060EA00000100000060EA00000100000060EA0000 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ServiceSidType" /t REG_DWORD /d 1 >nul
:: Citrix 브로커 및 HA 서비스 시작 구간
net start "Citrix Broker Service" >nul
net start "Citrix High Availability Service" >nul

timeout -nobreak 3 >nul
cls
:: Citrix 브로커 및 HA 서비스 종료 구간
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ############□□□□□□□□□□□□ [040%%.] 
echo.
net stop "Citrix High Availability Service" /Y >nul
net stop "Citrix Broker Service" /Y >nul
net stop "Citrix Broker Service" /Y >nul
cls
:: Citrix 브로커 서비스 제거 구간
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ##############□□□□□□□□□□ [050%%.] 
echo.
msiexec /x 1912Broker_Service_x64.msi /quiet 
timeout -nobreak 3 >nul
cls
:: Citrix 브로커 서비스 7 2203 버전 설치 구간
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ###############□□□□□□□□□ [055%%.] 
echo.
msiexec /i Broker_Service_x64.msi /quiet 
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ##################□□□□□□ [070%%.] 
echo.
:: Citrix High Availability 서비스 재구성 구간
copy /y "HighAvailability Service\*.*" "C:\Program Files\Citrix\Broker\Service" >nul
sc create "CitrixHighAvailabilityService" DisplayName="Citrix High Availability Service" binPath="C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Type" /t REG_DWORD /d 16 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Start" /t REG_DWORD /d 2 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ErrorControl" /t REG_DWORD /d 1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ImagePath" /t REG_EXPAND_SZ /d "C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "DisplayName" /t REG_SZ /d "Citrix High Availability Service" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ObjectName" /t REG_SZ /d "NT AUTHORITY\NetworkService" >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "Description" /t REG_SZ /d "The Citrix High Availability service provides continuity of service during outage of central site." >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "FailureActions" /t REG_BINARY /d 80510100010000000100000003000000140000000100000060EA00000100000060EA00000100000060EA0000 >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CitrixHighAvailabilityService" /f /v "ServiceSidType" /t REG_DWORD /d 1 >nul
:: Citrix 브로커 및 HA 서비스 시작 구간
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ###################□□□□□ [075%%.] 
echo.
net start "Citrix Broker Service" >nul
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                ######################□□ [085%%.] 
echo.
net start "Citrix High Availability Service" >nul
cls
echo Citrix 30Day Trial License 초기화
echo 진행 중...
echo                #######################□ [095%%.] 
echo.
:: Citrix 브로커 서비스 설치 파일 숨기기
if %loweruuid:~0,8%==80ef19ea goto skip
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%brokeruuid:~20,38%" /f /v "SystemComponent" /t REG_DWORD /d 1 > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%loweruuid:~21,36%_" /f /v "SystemComponent" /t REG_DWORD /d 1 > nul

:skip
cls
echo Citrix 30Day Trial License 초기화
echo 진행완료!!
echo                ######################## [100%%.] 
echo.
timeout 5
exit

:package
:: HA 패키지라인 
mkdir "HighAvailability Service"
msiexec /a Broker_Service_x64.msi targetdir="%TEMP%" /qn
timeout -nobreak 3 >nul
copy /y "%TEMP%\Citrix\Broker\Service\HighAvailability*" "HighAvailability Service" >nul

:: HA 패키지 TEMP파일 제거
del /f /s /q "%TEMP%\Broker_Service_x64.msi"
rmdir /s /q "%TEMP%\Citrix"

goto install
