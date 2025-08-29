@echo off
REM Magic 8-Ball Development Startup Script for Windows

echo 🔮 Starting Magic 8-Ball Development Environment...

REM Start the Rust server
echo 🦀 Starting Rust server...
cd server
start /B cargo run
cd ..

REM Wait for server to start
timeout /t 3 /nobreak > nul

REM Test server connection
echo 🔍 Testing server connection...
curl -s http://localhost:3030/health > nul
if %errorlevel% == 0 (
    echo ✅ Server is running at http://localhost:3030
) else (
    echo ❌ Server failed to start
    exit /b 1
)

REM Start Flutter app
echo 🚀 Starting Flutter app...
flutter run -d chrome

echo.
echo 🎉 Development environment started!
echo 📍 Server: http://localhost:3030
echo 🌐 Flutter app: Running in Chrome
pause
