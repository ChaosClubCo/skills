@echo off
REM ============================================================
REM  Skills Library Pipeline
REM  Double-click this file or run it from any terminal.
REM ============================================================
REM
REM  What it does:
REM    Runs the full update pipeline (quality fixes, platform sync,
REM    bundle population) in order. Takes ~2-5 minutes.
REM
REM  Options (pass as arguments):
REM    --dry-run              Preview without changing files
REM    --skip quality         Skip quality fixes
REM    --skip populate        Skip bundle population
REM    --only sync            Run only the sync step
REM
REM  Examples:
REM    run-pipeline.bat
REM    run-pipeline.bat --dry-run
REM    run-pipeline.bat --only sync
REM
REM ============================================================

title Skills Library Pipeline

REM Move to the project root (where this .bat file lives)
cd /d "%~dp0"

REM Set encoding to avoid Windows character errors
set PYTHONIOENCODING=utf-8

REM Check Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Python not found. Install Python 3.10+ from https://python.org
    echo.
    pause
    exit /b 1
)

echo.
echo Starting Skills Library Pipeline...
echo.

python scripts/pipeline.py %*

if errorlevel 1 (
    echo.
    echo Pipeline failed. See errors above.
    echo.
    pause
    exit /b 1
)

echo.
echo Pipeline complete!
echo.
pause
