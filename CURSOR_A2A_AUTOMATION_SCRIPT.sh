#!/bin/bash


set -e

echo "🚀 Starting A2A Travel Planning System for Cursor IDE"
echo "======================================================"

if [[ ! -f "pyproject.toml" ]] || [[ ! -d "agent_cards" ]]; then
    echo "❌ Error: Please run this script from the samples/python/agents/a2a_mcp directory"
    echo "Current directory: $(pwd)"
    echo "Expected files: pyproject.toml, agent_cards/"
    exit 1
fi

if [[ ! -d ".venv" ]]; then
    echo "❌ Error: Virtual environment not found. Please run:"
    echo "python -m venv .venv"
    echo "source .venv/bin/activate"
    echo "pip install uv && uv sync"
    exit 1
fi

if [[ ! -f ".env" ]]; then
    echo "❌ Error: .env file not found. Please create it with:"
    echo "GOOGLE_API_KEY=your_actual_google_api_key_here"
    echo "LITELLM_MODEL=openai/gpt-4o"
    exit 1
fi

source .env
if [[ -z "$GOOGLE_API_KEY" ]] || [[ "$GOOGLE_API_KEY" == "your_actual_google_api_key_here" ]]; then
    echo "❌ Error: GOOGLE_API_KEY not properly set in .env file"
    echo "Please update .env with your actual Google API key"
    exit 1
fi

echo "✅ Environment checks passed"
echo ""

start_component() {
    local name=$1
    local port=$2
    local agent_card=$3
    local log_file="logs/${name}.log"
    
    mkdir -p logs
    
    echo "🚀 Starting $name on port $port..."
    
    if [[ "$name" == "MCP Server" ]]; then
        nohup bash -c "source .venv/bin/activate && uv run --env-file .env a2a-mcp --run mcp-server --transport sse --port $port" > "$log_file" 2>&1 &
    else
        nohup bash -c "source .venv/bin/activate && uv run --env-file .env src/a2a_mcp/agents/ --agent-card $agent_card --port $port" > "$log_file" 2>&1 &
    fi
    
    local pid=$!
    echo "$pid" > "logs/${name// /_}.pid"
    echo "   PID: $pid, Log: $log_file"
    
    sleep 2
    
    if kill -0 $pid 2>/dev/null; then
        echo "   ✅ $name started successfully"
    else
        echo "   ❌ $name failed to start. Check $log_file for details."
        return 1
    fi
}

echo "Starting all A2A components..."
echo ""

start_component "MCP Server" 10100 ""
start_component "Orchestrator Agent" 10101 "agent_cards/orchestrator_agent.json"
start_component "Planner Agent" 10102 "agent_cards/planner_agent.json"
start_component "Air Ticketing Agent" 10103 "agent_cards/air_ticketing_agent.json"
start_component "Hotel Booking Agent" 10104 "agent_cards/hotel_booking_agent.json"
start_component "Car Rental Agent" 10105 "agent_cards/car_rental_agent.json"

echo ""
echo "🎉 All components started successfully!"
echo ""
echo "📋 System Status:"
echo "=================="
echo "🖥️  MCP Server:           http://localhost:10100"
echo "🎯  Orchestrator Agent:   http://localhost:10101"
echo "📋  Planner Agent:        http://localhost:10102"
echo "✈️  Air Ticketing Agent:  http://localhost:10103"
echo "🏨  Hotel Booking Agent:  http://localhost:10104"
echo "🚗  Car Rental Agent:     http://localhost:10105"
echo ""
echo "📁 Logs are available in the 'logs/' directory"
echo "🔧 PIDs are stored in logs/*.pid files"
echo ""
echo "🧪 Test the system with:"
echo "source .venv/bin/activate"
echo "uv run --env-file .env src/a2a_mcp/mcp/client.py --resource \"resource://agent_cards/list\" --find_agent \"Plan a trip to Paris\""
echo ""
echo "🛑 To stop all components, run:"
echo "./stop_a2a_system.sh"
