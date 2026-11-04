@echo off
rem Same as start-pet.cmd but everything goes to logs\pet.log (used by the desktop shortcut / silent start).
if "%~1"=="run" goto run
if not exist "%~dp0logs" mkdir "%~dp0logs"
cmd /c ""%~f0"" run >> "%~dp0logs\pet.log" 2>&1
exit /b

:run
setlocal
set "ROOT=%~dp0"
set "DSH_HOME=%ROOT%.dsh-home"
cd /d "%ROOT%"
curl -s -m 2 http://127.0.0.1:3080/health 2>nul | findstr /i "dsh-pet-standalone" >nul
if not errorlevel 1 (
  echo [i] already running, skip launch
  exit /b 0
)
if not exist "%DSH_HOME%\dsh-pet" mkdir "%DSH_HOME%\dsh-pet"
if not exist "%DSH_HOME%\dsh-pet\main-config.jsonc" copy /y "%ROOT%config\main-config.jsonc" "%DSH_HOME%\dsh-pet\main-config.jsonc" >nul
node "node_modules\dsh-pet\lib\standalone.js" --port 3080
