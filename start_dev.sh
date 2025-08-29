#!/bin/bash

# Magic 8-Ball Development Startup Script
# This script starts both the Rust server and Flutter app

echo "🔮 Starting Magic 8-Ball Development Environment..."

# Function to cleanup background processes on exit
cleanup() {
    echo "🧹 Cleaning up processes..."
    kill $SERVER_PID 2>/dev/null
    kill $FLUTTER_PID 2>/dev/null
    exit
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

# Start the Rust server in background
echo "🦀 Starting Rust server..."
cd server
cargo run &
SERVER_PID=$!
cd ..

# Wait a moment for server to start
sleep 3

# Test server connection
echo "🔍 Testing server connection..."
if curl -s http://localhost:3030/health > /dev/null; then
    echo "✅ Server is running at http://localhost:3030"
else
    echo "❌ Server failed to start"
    exit 1
fi

# Start Flutter app
echo "🚀 Starting Flutter app..."
flutter run -d chrome &
FLUTTER_PID=$!

echo ""
echo "🎉 Development environment is ready!"
echo "📍 Server: http://localhost:3030"
echo "🌐 Flutter app: Running in Chrome"
echo ""
echo "Press Ctrl+C to stop both services"

# Wait for processes to finish
wait
