#!/bin/bash


echo "🛑 Stopping A2A Travel Planning System"
echo "======================================"

stop_component() {
    local name=$1
    local pid_file="logs/${name// /_}.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill -0 $pid 2>/dev/null; then
            echo "🛑 Stopping $name (PID: $pid)..."
            kill $pid
            sleep 1
            
            if kill -0 $pid 2>/dev/null; then
                echo "   Force killing $name..."
                kill -9 $pid
            fi
            
            echo "   ✅ $name stopped"
        else
            echo "   ℹ️  $name was not running"
        fi
        rm -f "$pid_file"
    else
        echo "   ℹ️  No PID file found for $name"
    fi
}

stop_component "MCP Server"
stop_component "Orchestrator Agent"
stop_component "Planner Agent"
stop_component "Air Ticketing Agent"
stop_component "Hotel Booking Agent"
stop_component "Car Rental Agent"

echo ""
echo "🧹 Cleaning up any remaining processes on ports 10100-10105..."
for port in {10100..10105}; do
    local pid=$(lsof -ti:$port 2>/dev/null)
    if [[ -n "$pid" ]]; then
        echo "   Killing process on port $port (PID: $pid)"
        kill -9 $pid 2>/dev/null || true
    fi
done

echo ""
echo "✅ All A2A components stopped successfully!"
echo "📁 Logs are preserved in the 'logs/' directory"
