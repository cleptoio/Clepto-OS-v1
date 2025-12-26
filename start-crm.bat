@echo off
echo.
echo ==========================================
echo   Clepto CRM - Quick Start
echo ==========================================
echo.

cd apps\clepto-crm\public

echo Starting local web server on http://localhost:8000
echo.
echo Press Ctrl+C to stop the server
echo.

python -m http.server 8000
