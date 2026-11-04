@echo off
rem Start the desktop pet in the foreground (console shows the log). Close the window or press Ctrl+C to stop.
setlocal
set "ROOT=%~dp0"
set "DSH_HOME=%ROOT%.dsh-home"
cd /d "%ROOT%"

if not exist "node_modules\dsh-pet\lib\standalone.js" (
  echo [x] Dependencies are missing. Run setup.cmd first.
  pause
  exit /b 1
)

rem already running? (the standalone answers /health when it is up)
curl -s -m 2 http://127.0.0.1:3080/health 2>nul | findstr /i "dsh-pet-standalone" >nul
if not errorlevel 1 (
  echo [i] The pet is already running - right-click it and choose "Quit" to stop it.
  ping -n 3 127.0.0.1 >nul
  exit /b 0
)

if not exist "%DSH_HOME%\dsh-pet" mkdir "%DSH_HOME%\dsh-pet"
if not exist "%DSH_HOME%\dsh-pet\main-config.jsonc" copy /y "%ROOT%config\main-config.jsonc" "%DSH_HOME%\dsh-pet\main-config.jsonc" >nul

echo.
echo   Desktop pet starting ...  (web page: http://127.0.0.1:3080/dsh-pet-7340/)
echo   Right-click the pet to quit.
echo.
node "node_modules\dsh-pet\lib\standalone.js" --port 3080 %*
echo.
echo Pet exited.
pause
