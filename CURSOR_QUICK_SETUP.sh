#!/bin/bash


set -e

echo "🚀 A2A Travel Planning System - Quick Setup for Cursor IDE"
echo "=========================================================="
echo ""

if [[ ! -f "README.md" ]] || [[ ! -d "samples" ]]; then
    echo "❌ Error: Please run this script from the a2a-samples root directory"
    echo "Current directory: $(pwd)"
    echo "Expected: a2a-samples/ (with README.md and samples/ directory)"
    exit 1
fi

echo "✅ Running from correct directory: $(pwd)"
echo ""

cd samples/python/agents/a2a_mcp

echo "📁 Navigated to: $(pwd)"
echo ""

if [[ ! -d ".venv" ]]; then
    echo "🐍 Creating Python virtual environment..."
    python -m venv .venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

echo "🔧 Activating virtual environment..."
source .venv/bin/activate

if ! command -v uv &> /dev/null; then
    echo "📦 Installing UV package manager..."
    pip install uv
    echo "✅ UV installed"
else
    echo "✅ UV already installed"
fi

echo "📦 Installing project dependencies..."
uv sync
echo "✅ Dependencies installed"

echo "🔧 Fixing missing import in adk_travel_agent.py..."
if ! grep -q "import os" src/a2a_mcp/agents/adk_travel_agent.py; then
    sed -i '3i import os' src/a2a_mcp/agents/adk_travel_agent.py
    echo "✅ Added missing 'import os' statement"
else
    echo "✅ Import already fixed"
fi

if [[ ! -f ".env" ]]; then
    echo "🔑 Creating .env file template..."
    cat > .env << 'EOF'
GOOGLE_API_KEY=your_actual_google_api_key_here
OPENAI_API_KEY=your_openai_api_key_if_you_have_one
LITELLM_MODEL=openai/gpt-4o
EOF
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: You need to edit the .env file and add your actual Google API key!"
    echo "   Replace 'your_actual_google_api_key_here' with your real API key from Google AI Studio"
    echo "   File location: $(pwd)/.env"
    echo ""
    echo "🔗 Get your Google API key at: https://aistudio.google.com/"
    echo ""
    echo "After updating the .env file, run:"
    echo "   ./CURSOR_A2A_AUTOMATION_SCRIPT.sh"
    echo ""
else
    source .env
    if [[ -z "$GOOGLE_API_KEY" ]] || [[ "$GOOGLE_API_KEY" == "your_actual_google_api_key_here" ]]; then
        echo "⚠️  WARNING: GOOGLE_API_KEY not properly set in .env file"
        echo "   Please update .env with your actual Google API key"
        echo "   File location: $(pwd)/.env"
        echo ""
        echo "🔗 Get your Google API key at: https://aistudio.google.com/"
        echo ""
        echo "After updating the .env file, run:"
        echo "   ./CURSOR_A2A_AUTOMATION_SCRIPT.sh"
        echo ""
    else
        echo "✅ .env file exists and API key is configured"
        echo ""
        echo "🎉 Setup complete! Ready to start the A2A system."
        echo ""
        echo "🚀 To start all components, run:"
        echo "   ./CURSOR_A2A_AUTOMATION_SCRIPT.sh"
        echo ""
        echo "🛑 To stop all components, run:"
        echo "   ./CURSOR_A2A_STOP_SCRIPT.sh"
        echo ""
    fi
fi

echo "📋 Setup Summary:"
echo "=================="
echo "✅ Virtual environment: .venv/"
echo "✅ Dependencies: installed via UV"
echo "✅ Code fixes: applied"
echo "✅ Environment file: .env"
echo ""
echo "📁 Current directory: $(pwd)"
echo "🎯 Next step: Update .env with your Google API key, then run ./CURSOR_A2A_AUTOMATION_SCRIPT.sh"
