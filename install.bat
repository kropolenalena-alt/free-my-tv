@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
set ADB=%~dp0platform-tools\adb.exe
title Free My TV

echo.
echo   Free My TV: установка на телевизор
echo   ----------------------------------
echo   Телевизор и компьютер должны быть в одной сети Wi-Fi,
echo   а на телевизоре включена отладка по USB.
echo.
set /p IP=  IP-адрес телевизора (например 192.168.1.50): 
if "%IP%"=="" goto :eof

"%ADB%" disconnect >nul 2>&1
echo.
echo   Подключаюсь к %IP% ...
echo   На телевизоре появится "Разрешить отладку по USB?":
echo   поставь галочку "Всегда разрешать" и нажми OK.
echo.
"%ADB%" connect %IP%:5555

set TRIES=0
:wait
"%ADB%" -s %IP%:5555 get-state 2>nul | find "device" >nul && goto :install
set /a TRIES+=1
if %TRIES% GEQ 30 goto :fail
timeout /t 2 /nobreak >nul
"%ADB%" connect %IP%:5555 >nul 2>&1
goto :wait

:install
echo   Подключено. Ставлю Free My TV ...
"%ADB%" -s %IP%:5555 install -r FreeMyTV.apk || goto :fail
echo.
echo   Готово! Теперь на телевизоре:
echo   открой приложение Free My TV - "Главный экран" - "Free My TV"
echo   и ещё раз разреши отладку ("Всегда разрешать").
echo   Вернуть заводской экран: Free My TV - "Главный экран" - "Заводской".
echo.
pause
goto :eof

:fail
echo.
echo   Не получилось подключиться или установить.
echo   Проверь IP, что отладка включена и что ТВ и комп в одной сети.
echo.
pause
