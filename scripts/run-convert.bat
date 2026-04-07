@echo off
setlocal
echo ============================================================
echo   Skills Library - Full Platform Conversion
echo ============================================================
echo.

set "PYTHONIOENCODING=utf-8"
set "SCRIPT_DIR=%~dp0"

echo [1/4] Converting to Gemini Gems...
python "%SCRIPT_DIR%convert-to-gems.py"
if errorlevel 1 echo   WARNING: Gemini conversion had errors
echo.

echo [2/4] Converting to OpenAI Codex Responses...
python "%SCRIPT_DIR%convert-to-codex-responses.py"
if errorlevel 1 echo   WARNING: Codex conversion had errors
echo.

echo [3/4] Converting to GitHub Copilot formats...
node "%SCRIPT_DIR%convert-to-copilot.js"
if errorlevel 1 echo   WARNING: Copilot conversion had errors
echo.

echo [4/4] Converting to CLI skill formats...
python "%SCRIPT_DIR%convert-to-cli-skills.py" --platforms all
if errorlevel 1 echo   WARNING: CLI conversion had errors
echo.

echo ============================================================
echo   All conversions complete.
echo ============================================================
endlocal
