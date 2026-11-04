@echo off
rem First run: install dependencies, apply patches, create shortcuts.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
pause
