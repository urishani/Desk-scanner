@echo off
setlocal EnableExtensions
cd /d "%~dp0"

where git >nul 2>&1
if errorlevel 1 (
  echo Git is not on PATH.
  exit /b 1
)

echo.
echo === git status ===
git status
echo.

set "HAS_CHANGES="
for /f "delims=" %%i in ('git status --porcelain') do set "HAS_CHANGES=1"
if not defined HAS_CHANGES (
  echo No changes to commit.
  exit /b 0
)

set "MSG="
set /p "MSG=Commit comment: "
if not defined MSG (
  echo Empty comment. Commit cancelled.
  exit /b 1
)

if not exist version.txt (
  >version.txt echo 1
)

set /p VER=<version.txt
set /a NEXT=VER+1

echo.
echo Bumping version %VER% -^> %NEXT%

set "REL_VER=%NEXT%"
set "REL_MSG=%MSG%"
set "REL_ROOT=%CD%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = $env:REL_ROOT; $v = $env:REL_VER.Trim(); $utf8 = New-Object System.Text.UTF8Encoding $false; [IO.File]::WriteAllText((Join-Path $root 'version.txt'), $v + [Environment]::NewLine, $utf8); $htmlPath = Join-Path $root 'index.html'; $html = [IO.File]::ReadAllText($htmlPath); $html = [regex]::Replace($html, '<!--APP_VERSION-->v?\d+<!--/APP_VERSION-->', ('<!--APP_VERSION-->v' + $v + '<!--/APP_VERSION-->')); [IO.File]::WriteAllText($htmlPath, $html, $utf8); $swPath = Join-Path $root 'sw.js'; $sw = [IO.File]::ReadAllText($swPath); $sw = [regex]::Replace($sw, 'desk-scanner-v\d+', ('desk-scanner-v' + $v)); [IO.File]::WriteAllText($swPath, $sw, $utf8); Write-Host ('App ribbon and cache set to v' + $v)"
if errorlevel 1 (
  echo Failed to write version into the app files.
  exit /b 1
)

echo.
echo === staging ===
git add -A
git status --short
echo.

echo Committing v%NEXT%: %MSG%
powershell -NoProfile -ExecutionPolicy Bypass -Command "git commit -m ('v' + $env:REL_VER.Trim() + ': ' + $env:REL_MSG)"
if errorlevel 1 (
  echo Commit failed.
  exit /b 1
)

echo.
echo === pushing to GitHub ===
git push origin HEAD
if errorlevel 1 (
  echo Push failed. The commit exists locally as v%NEXT%.
  exit /b 1
)

echo.
echo Released v%NEXT% to GitHub.
git status
exit /b 0
