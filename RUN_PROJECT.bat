@echo off
echo ==========================================
echo YOLO IPC Detection System
echo ==========================================
echo.
echo This script will run the YOLO detection on all images
echo through WSL (Windows Subsystem for Linux)
echo.

wsl bash -c "cd /mnt/e/4-2/embedded/IPC_Assignment/darknet && chmod +x run_all.sh && ./run_all.sh"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo SUCCESS! Check the results/ directory
    echo ==========================================
) else (
    echo.
    echo ==========================================
    echo ERROR: Please run manually in WSL:
    echo   cd /mnt/e/4-2/embedded/IPC_Assignment/darknet
    echo   chmod +x run_all.sh
    echo   ./run_all.sh
    echo ==========================================
)

pause
