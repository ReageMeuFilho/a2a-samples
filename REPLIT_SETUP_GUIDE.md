# 🚀 Complete A2A Travel Planning System Setup Guide for Replit

This guide provides step-by-step instructions to run Google's A2A (Agent-to-Agent) protocol travel planning system locally or in Replit.

## 📋 Prerequisites

### Required API Keys
- **GOOGLE_API_KEY** - Required for Google's generative AI models used by the travel agents
- **OPENAI_API_KEY** - Optional fallback (system will use Google API if available)

### System Requirements
- Python 3.12+ 
- Git
- Internet connection for package installation

## 🔧 Step 1: Repository Setup

### Clone the Repository
```bash
git clone https://github.com/ReageMeuFilho/a2a-samples.git
cd a2a-samples
```

### Navigate to Travel Planning Directory
```bash
cd samples/python/agents/a2a_mcp
```

## 🐍 Step 2: Python Environment Setup

### Create Virtual Environment
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

### Install UV Package Manager (Required)
```bash
pip install uv
```

## 📦 Step 3: Dependencies Installation

### Update pyproject.toml
The `pyproject.toml` file needs these additional dependencies:
```toml
dependencies = [
    "a2a-sdk[sql]>=0.3.0",
    "google-adk>=0.1.0",
    "google-genai>=0.3.0",
    "mcp>=1.1.0",
    "pandas>=2.2.3",
    "pydantic>=2.11.4",
    "litellm",
    "uvicorn>=0.34.2",
    "sse-starlette>=2.3.6",
    "starlette>=0.46.2",
]
```

### Install Dependencies
```bash
uv sync
```

## 🔑 Step 4: Environment Configuration

### Create .env File
Create a `.env` file in the `samples/python/agents/a2a_mcp` directory:
```bash
GOOGLE_API_KEY=your_actual_google_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
LITELLM_MODEL=openai/gpt-4o
```

**Important:** Replace `your_actual_google_api_key_here` with your real Google API key.

### Fix Import Issue
Add missing import to `src/a2a_mcp/agents/adk_travel_agent.py`:
```python
import os  # Add this line at the top with other imports
```

## 🚀 Step 5: Start All Components (6 Terminals Required)

You need to run these commands in **6 separate terminals** (or use tmux/screen):

### Terminal 1: MCP Server (Port 10100)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env a2a-mcp --run mcp-server --transport sse --port 10100
```

**Expected Output:**
```
INFO     Loading agent cards from card repo: agent_cards
INFO     Finished loading agent cards. Found 5 cards.
INFO     Agent cards MCP Server at localhost:10100 and transport stdio
```

### Terminal 2: Orchestrator Agent (Port 10101)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/orchestrator_agent.json --port 10101
```

**Expected Output:**
```
INFO     Starting A2A server on port 10101
INFO     Agent card loaded: Orchestrator Agent
```

### Terminal 3: Planner Agent (Port 10102)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/planner_agent.json --port 10102
```

### Terminal 4: Air Ticketing Agent (Port 10103)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/air_ticketing_agent.json --port 10103
```

### Terminal 5: Hotel Booking Agent (Port 10104)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/hotel_booking_agent.json --port 10104
```

### Terminal 6: Car Rental Agent (Port 10105)
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/agents/ --agent-card agent_cards/car_rental_agent.json --port 10105
```

## ✅ Step 6: Verify System is Running

### Check All Ports are Active
```bash
# Check if all agents are running
curl http://localhost:10100/.well-known/agent-card.json  # MCP Server
curl http://localhost:10101/.well-known/agent-card.json  # Orchestrator
curl http://localhost:10102/.well-known/agent-card.json  # Planner
curl http://localhost:10103/.well-known/agent-card.json  # Air Ticketing
curl http://localhost:10104/.well-known/agent-card.json  # Hotel Booking
curl http://localhost:10105/.well-known/agent-card.json  # Car Rental
```

Each should return JSON with agent card information.

## 🧪 Step 7: Test the System

### Test Agent Discovery and Semantic Matching
```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/mcp/client.py --resource "resource://agent_cards/list" --find_agent "Plan a complete 5-day trip to Paris, France for 2 adults from March 15-20, 2025. I need flights from New York, a hotel in central Paris, and a rental car for sightseeing."
```

**Expected Output:**
- System loads all 5 agent cards
- Uses Google's embedding model for semantic analysis
- Returns the most relevant agent for the travel request
- Shows complete agent capabilities and skills

### Example Successful Output
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
  }
}
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. "GOOGLE_API_KEY is not set" Error
- Ensure your `.env` file contains the real API key (not placeholder text)
- Restart all agents after updating the `.env` file

#### 2. "a2a-sdk==0.3.0 not found" Error
- Run `uv sync` to install dependencies
- Ensure you're using the virtual environment: `source .venv/bin/activate`

#### 3. Port Already in Use
- Kill existing processes: `lsof -ti:10101 | xargs kill -9`
- Or use different ports by modifying the `--port` parameter

#### 4. Import Errors
- Ensure all dependencies are installed: `uv sync`
- Check that you added `import os` to `adk_travel_agent.py`

#### 5. Agent Not Responding
- Check agent logs in the terminal where it's running
- Verify the agent card JSON files exist in `agent_cards/` directory
- Restart the specific agent

### Replit-Specific Notes

#### Environment Variables in Replit
1. Go to Replit Secrets (lock icon in sidebar)
2. Add `GOOGLE_API_KEY` with your actual API key
3. The system will automatically use it from the environment

#### Multiple Terminals in Replit
1. Use the Shell tab and open multiple shell instances
2. Or use tmux: `tmux new-session -d -s agent1 'command1'`
3. Background processes: Add `&` at the end of commands

#### Port Access in Replit
- Replit will automatically expose ports 10100-10105
- Use the "Webview" tab to access agent endpoints
- URLs will be in format: `https://your-repl-name.username.repl.co:10101`

## 🎯 Understanding the A2A Protocol Flow

### 1. Agent Discovery
- MCP Server maintains registry of all available agents
- Each agent exposes metadata via AgentCard at `/.well-known/agent-card.json`
- Semantic matching uses embeddings to find relevant agents

### 2. Multi-Agent Coordination
- Orchestrator Agent coordinates complex workflows
- Specialized agents handle specific tasks (flights, hotels, cars)
- Real-time streaming updates between agents

### 3. Communication Protocol
- JSON-RPC 2.0 over HTTP for agent-to-agent communication
- Server-Sent Events for streaming updates
- Standardized message formats and task management

## 🚀 Next Steps

Once the system is running, you can:

1. **Test Complex Workflows**: Send multi-step travel planning requests
2. **Monitor Agent Coordination**: Watch logs to see agents collaborating
3. **Explore Agent Cards**: Check each agent's capabilities and skills
4. **Build Custom Agents**: Create new agents following the A2A protocol
5. **Integrate with Other Systems**: Use A2A clients to connect external applications

## 📚 Additional Resources

- [A2A Protocol Specification](https://github.com/a2aproject/A2A)
- [Google ADK Documentation](https://developers.google.com/adk)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [A2A Python SDK](https://github.com/a2aproject/a2a-python)

---

**🎓 Professor's Note:** This setup demonstrates the power of A2A protocol for building distributed, multi-agent systems that can discover, communicate, and coordinate autonomously. The travel planning system showcases real-world application of agent-to-agent communication with semantic discovery and streaming coordination.
