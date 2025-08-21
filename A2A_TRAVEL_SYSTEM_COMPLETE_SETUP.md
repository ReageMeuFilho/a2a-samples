# 🚀 Complete A2A Travel Planning System Setup Guide

**For Cursor IDE - Local Development**

This comprehensive guide will help you run Google's A2A (Agent-to-Agent) protocol travel planning system with 6 coordinated agents that can handle complex travel requests through semantic discovery and multi-agent orchestration.

## 🎯 What You'll Build

A distributed multi-agent system with:
- **🖥️ MCP Server** - Agent discovery and registry
- **🎯 Orchestrator Agent** - Multi-agent coordination  
- **📋 Planner Agent** - Trip planning and task breakdown
- **✈️ Air Ticketing Agent** - Flight booking
- **🏨 Hotel Booking Agent** - Accommodation booking
- **🚗 Car Rental Agent** - Vehicle rental

## 📋 Prerequisites

### Required API Keys
You **MUST** have a Google API key to run this system:

1. Go to [Google AI Studio](https://aistudio.google.com/)
2. Create a new API key
3. Copy the key (starts with `AIza...`)

### System Requirements
- Python 3.12+ 
- Git
- 6 terminal windows/tabs (or tmux/screen)
- Internet connection

## 🚀 Quick Start for Cursor IDE

### Step 1: Repository Setup in Cursor
```bash
# Open Cursor IDE and clone the repository
# File > Clone Repository > https://github.com/ReageMeuFilho/a2a-samples.git

# Or use terminal in Cursor:
git clone https://github.com/ReageMeuFilho/a2a-samples.git
cd a2a-samples

# Open the project in Cursor
# File > Open Folder > select a2a-samples folder

# Navigate to the travel planning directory
cd samples/python/agents/a2a_mcp

# Create virtual environment
python -m venv .venv

# Activate virtual environment
# On macOS/Linux:
source .venv/bin/activate
# On Windows:
.venv\Scripts\activate

# Install UV package manager
pip install uv
```

### Step 2: Fix Dependencies and Code
```bash
# Install dependencies
uv sync

# Fix missing import (critical step!)
echo 'import os' | cat - src/a2a_mcp/agents/adk_travel_agent.py > temp && mv temp src/a2a_mcp/agents/adk_travel_agent.py
```

### Step 3: Environment Configuration
Create `.env` file with your Google API key:
```bash
cat > .env << 'EOF'
GOOGLE_API_KEY=your_actual_google_api_key_here
OPENAI_API_KEY=your_openai_api_key_if_you_have_one
LITELLM_MODEL=openai/gpt-4o
EOF
```

**⚠️ CRITICAL:** Replace `your_actual_google_api_key_here` with your real Google API key!

## 🔧 Step 4: Start All Components in Cursor

You need **6 separate terminals** in Cursor. Here's how to manage multiple terminals in Cursor IDE:

### Setting Up Multiple Terminals in Cursor:
1. **Open Terminal Panel**: `Ctrl+`` (backtick) or `View > Terminal`
2. **Create New Terminal**: Click the `+` icon in terminal panel or `Ctrl+Shift+`` 
3. **Split Terminal**: Click the split icon or `Ctrl+Shift+5`
4. **Switch Between Terminals**: Click on terminal tabs or use `Ctrl+PageUp/PageDown`

### Alternative: Use Terminal Multiplexer (Recommended)
If you prefer, you can use tmux or screen to manage all processes in one terminal:

```bash
# Install tmux (if not already installed)
# macOS: brew install tmux
# Ubuntu/Debian: sudo apt install tmux
# Windows: Use WSL or Git Bash

# Start tmux session
tmux new-session -d -s a2a-travel

# Create windows for each component
tmux new-window -t a2a-travel:1 -n mcp
tmux new-window -t a2a-travel:2 -n orchestrator  
tmux new-window -t a2a-travel:3 -n planner
tmux new-window -t a2a-travel:4 -n air
tmux new-window -t a2a-travel:5 -n hotel
tmux new-window -t a2a-travel:6 -n car

# Attach to session
tmux attach-session -t a2a-travel
```

### Copy each command block into a separate terminal:

### Terminal 1: MCP Server
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env a2a-mcp --run mcp-server --transport sse --port 10100
```
**Wait for:** `INFO Agent cards MCP Server at localhost:10100`

### Terminal 2: Orchestrator Agent
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/orchestrator_agent.json --port 10101
```
**Wait for:** `INFO Starting A2A server on port 10101`

### Terminal 3: Planner Agent
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/planner_agent.json --port 10102
```

### Terminal 4: Air Ticketing Agent
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/air_ticketing_agent.json --port 10103
```

### Terminal 5: Hotel Booking Agent
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/hotel_booking_agent.json --port 10104
```

### Terminal 6: Car Rental Agent
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/car_rental_agent.json --port 10105
```

## ✅ Step 5: Verify System is Working

### Quick Health Check
```bash
# In a new terminal, check all agents are responding
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate

# Test each agent endpoint
curl -s http://localhost:10101/.well-known/agent-card.json | jq .name
curl -s http://localhost:10102/.well-known/agent-card.json | jq .name
curl -s http://localhost:10103/.well-known/agent-card.json | jq .name
curl -s http://localhost:10104/.well-known/agent-card.json | jq .name
curl -s http://localhost:10105/.well-known/agent-card.json | jq .name
```

**Expected Output:**
```
"Orchestrator Agent"
"Planner Agent"
"Air Ticketing Agent"
"Hotel Booking Agent"
"Car Rental Agent"
```

## 🧪 Step 6: Test the A2A System

### Test Agent Discovery and Semantic Matching
```bash
cd a2a-samples/samples/python/agents/a2a_mcp
source .venv/bin/activate

# Test with a complex travel request
uv run --env-file .env src/a2a_mcp/mcp/client.py \
  --resource "resource://agent_cards/list" \
  --find_agent "Plan a complete 5-day trip to Paris, France for 2 adults from March 15-20, 2025. I need flights from New York JFK, a 4-star hotel in central Paris near the Louvre, and a rental car for sightseeing around the city and day trips to Versailles."
```

### Expected Successful Output
```
INFO     Loading agent cards from card repo: agent_cards
INFO     Finished loading agent cards. Found 5 cards.
INFO     Generating Embeddings for agent cards
INFO     Calling 'find_agent' tool with query: 'Plan a complete 5-day trip...'
{
  "name": "Car Rental Agent",
  "description": "Helps book car rental",
  "url": "http://localhost:10105/",
  "capabilities": {
    "streaming": true,
    "pushNotifications": true
  },
  "skills": [
    {
      "id": "book_cars",
      "name": "Book Car Rental",
      "description": "Helps with booking car rental given a criteria"
    }
  ]
}
```

## 🎉 Success! Your A2A System is Running

If you see the agent discovery working and returning agent information, congratulations! You now have a fully functional A2A multi-agent system running.

## 🔧 Troubleshooting Guide

### Problem: "GOOGLE_API_KEY is not set"
**Solution:**
```bash
# Check your .env file
cat .env
# Should show: GOOGLE_API_KEY=AIza...your_actual_key

# If not, recreate it:
echo "GOOGLE_API_KEY=your_actual_google_api_key_here" > .env
echo "LITELLM_MODEL=openai/gpt-4o" >> .env
```

### Problem: "a2a-sdk not found" or Import Errors
**Solution:**
```bash
# Reinstall dependencies
source .venv/bin/activate
uv sync
```

### Problem: "Port already in use"
**Solution:**
```bash
# Kill processes on specific ports
lsof -ti:10101 | xargs kill -9
lsof -ti:10102 | xargs kill -9
# Repeat for ports 10100-10105
```

### Problem: Agent not responding
**Solution:**
1. Check the terminal where the agent is running for error messages
2. Restart that specific agent
3. Verify the agent card JSON file exists

### Problem: Missing import error in adk_travel_agent.py
**Solution:**
```bash
# Add the missing import
sed -i '3i import os' src/a2a_mcp/agents/adk_travel_agent.py
```

## 🖥️ Cursor IDE-Specific Tips

### Managing Multiple Terminals in Cursor

1. **Terminal Panel Management:**
   - Use `Ctrl+`` to toggle terminal panel
   - Use `Ctrl+Shift+`` to create new terminal
   - Right-click terminal tabs to rename them (e.g., "MCP Server", "Orchestrator", etc.)

2. **Workspace Organization:**
   - Create a `.vscode/tasks.json` file for easy task management:
   ```json
   {
     "version": "2.0.0",
     "tasks": [
       {
         "label": "Start MCP Server",
         "type": "shell",
         "command": "source .venv/bin/activate && uv run --env-file .env a2a-mcp --run mcp-server --transport sse --port 10100",
         "group": "build",
         "presentation": {
           "echo": true,
           "reveal": "always",
           "panel": "new"
         },
         "options": {
           "cwd": "${workspaceFolder}/samples/python/agents/a2a_mcp"
         }
       }
     ]
   }
   ```

3. **Environment Variables in Cursor:**
   - Create `.env` file in the project root
   - Cursor will automatically load environment variables
   - Use the integrated terminal which inherits the environment

4. **Port Management:**
   - Cursor will show port forwarding notifications
   - Access agents at `http://localhost:10100-10105`
   - Use Cursor's built-in port forwarding for remote access

### Cursor Extensions for A2A Development

Recommended extensions for better A2A development experience:
- **Python** - Official Python extension
- **Python Debugger** - For debugging agents
- **REST Client** - For testing agent endpoints
- **JSON** - Better JSON editing for agent cards
- **Terminal** - Enhanced terminal features

### Debugging in Cursor

1. **Set Breakpoints** in agent code
2. **Use Debug Console** to inspect agent state
3. **Monitor Network Requests** between agents
4. **View Logs** in integrated terminal

## 🎓 Understanding What You Built

### A2A Protocol Features Demonstrated

1. **🔍 Dynamic Agent Discovery**
   - MCP server maintains registry of available agents
   - Semantic matching using Google's embedding models
   - Automatic agent capability detection

2. **🤝 Multi-Agent Coordination**
   - Orchestrator coordinates complex workflows
   - Specialized agents handle specific domains
   - Real-time streaming communication

3. **📡 Standardized Communication**
   - JSON-RPC 2.0 over HTTP protocol
   - AgentCard metadata for capability discovery
   - Server-Sent Events for streaming updates

### Travel Planning Workflow

When you send a travel request:
1. **MCP Server** analyzes the request semantically
2. **Agent Discovery** finds the most relevant agents
3. **Orchestrator** coordinates the workflow
4. **Specialized Agents** handle specific tasks (flights, hotels, cars)
5. **Real-time Updates** stream back to the user

## 🚀 Next Steps

### Experiment with Different Requests
```bash
# Test different types of requests to see which agents are selected:

# Hotel-focused request
uv run --env-file .env src/a2a_mcp/mcp/client.py \
  --resource "resource://agent_cards/list" \
  --find_agent "I need a luxury hotel in downtown Tokyo for my business trip"

# Flight-focused request  
uv run --env-file .env src/a2a_mcp/mcp/client.py \
  --resource "resource://agent_cards/list" \
  --find_agent "Book me a round-trip flight from Los Angeles to London"

# Complex multi-agent request
uv run --env-file .env src/a2a_mcp/mcp/client.py \
  --resource "resource://agent_cards/list" \
  --find_agent "Plan a complete business trip to Singapore with flights, hotel, and ground transportation"
```

### Monitor Agent Interactions
- Watch the terminal logs to see agents communicating
- Observe how the orchestrator coordinates different agents
- See real-time streaming updates between agents

### Build Custom Agents in Cursor
- Use Cursor's **AI-powered code completion** to help write agent code
- Study the agent card JSON files in `agent_cards/` (Cursor will provide JSON schema validation)
- Look at agent implementations in `src/a2a_mcp/agents/` with Cursor's **Go to Definition** feature
- Use Cursor's **AI Chat** to ask questions about A2A protocol patterns
- Create new agents following the A2A protocol patterns with **intelligent code suggestions**

## 📚 Additional Resources

- **[A2A Protocol Specification](https://github.com/a2aproject/A2A)** - Complete protocol documentation
- **[Google ADK Documentation](https://developers.google.com/adk)** - Agent Development Kit
- **[MCP Protocol](https://modelcontextprotocol.io/)** - Model Context Protocol used for discovery
- **[A2A Python SDK](https://github.com/a2aproject/a2a-python)** - Official Python implementation

## 🎯 Key Takeaways

You've successfully built a **distributed multi-agent system** that demonstrates:

- ✅ **Agent-to-Agent Communication** using standardized protocols
- ✅ **Semantic Agent Discovery** with AI-powered matching
- ✅ **Real-time Coordination** between specialized agents
- ✅ **Framework Agnostic Design** supporting multiple AI frameworks
- ✅ **Enterprise-grade Architecture** with streaming and push notifications

This system showcases the future of AI agent collaboration - where specialized agents can discover, communicate, and coordinate autonomously to handle complex, multi-step tasks like travel planning.

---

**🎓 Professor's Final Note:** You've just experienced the power of Google's A2A protocol firsthand! This travel planning system demonstrates how the "agent internet" enables seamless collaboration between independent AI systems, paving the way for more sophisticated multi-agent applications.

**🚀 Happy Agent Building!**
