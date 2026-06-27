@echo off
cd /d "%~dp0"
echo Starting GameHub Codespace Launcher...
powershell -ExecutionPolicy Bypass -File "start-codespace.ps1"
pause
