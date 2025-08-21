# 🖥️ Environment Specifications for A2A Travel Planning System

**Tested and Verified Environment for Cursor IDE**

## 🐧 Operating System
- **OS**: Ubuntu 22.04.5 LTS (Jammy Jellyfish)
- **Kernel**: Linux 5.10.223 x86_64
- **Architecture**: x86_64

## 🐍 Python Environment
- **Python Version**: 3.13.3 (also compatible with 3.12+)
- **Package Manager**: pip 24.3.1
- **Virtual Environment**: venv (built-in Python module)
- **UV Package Manager**: Required for A2A SDK installation

## 📦 Node.js Environment (Optional)
- **Node.js**: v22.12.0
- **npm**: 10.8.3
- **Note**: Only needed if running JavaScript/TypeScript A2A agents

## 🔧 System Tools
- **Git**: 2.34.1
- **Curl**: 7.81.0
- **Shell**: Bash

## 💾 System Resources
- **CPU**: AMD EPYC
- **Memory**: 31GB RAM available
- **Storage**: 122GB total, 104GB available
- **Network**: Full internet access required

## 🎯 Cursor IDE Requirements

### Minimum System Requirements
- **OS**: Windows 10+, macOS 10.15+, or Linux (Ubuntu 18.04+)
- **Memory**: 4GB RAM minimum, 8GB recommended
- **Storage**: 2GB free space
- **Python**: 3.12+ (3.13.3 tested and working)
- **Internet**: Required for package installation and API calls

### Required Tools for Local Setup
```bash
# Check if you have these tools installed:
python --version    # Should be 3.12+
git --version       # Any recent version
curl --version      # For testing agent endpoints
```

### Python Package Dependencies
The A2A system requires these key packages (automatically installed via UV):
- `a2a-sdk[sql]>=0.3.0` - Core A2A protocol implementation
- `google-adk>=0.1.0` - Google Agent Development Kit
- `google-genai>=0.3.0` - Google Generative AI models
- `mcp>=1.1.0` - Model Context Protocol
- `litellm` - LLM abstraction layer
- `uvicorn>=0.34.2` - ASGI server for agents
- `sse-starlette>=2.3.6` - Server-Sent Events support
- `starlette>=0.46.2` - Web framework

## 🔑 API Requirements
- **Google API Key**: Required from Google AI Studio (https://aistudio.google.com/)
- **OpenAI API Key**: Optional fallback

## 🌐 Network Ports
The system uses these local ports:
- **10100**: MCP Server (agent discovery)
- **10101**: Orchestrator Agent
- **10102**: Planner Agent  
- **10103**: Air Ticketing Agent
- **10104**: Hotel Booking Agent
- **10105**: Car Rental Agent

## 🎯 Cursor IDE Specific Setup

### Terminal Configuration
- **Integrated Terminal**: Use Cursor's built-in terminal (`Ctrl+``)
- **Multiple Terminals**: Create 6 terminals for each component
- **Shell**: Bash (default on Linux/macOS), PowerShell/Git Bash on Windows

### Recommended Cursor Extensions
- **Python** - Official Python language support
- **Python Debugger** - For debugging A2A agents
- **REST Client** - For testing agent HTTP endpoints
- **JSON** - Better JSON editing for agent cards
- **GitLens** - Enhanced Git integration

### Environment Variable Handling
- Create `.env` file in `samples/python/agents/a2a_mcp/`
- Cursor automatically loads .env files in the workspace
- Use integrated terminal which inherits environment variables

## ✅ Compatibility Notes

### Tested Configurations
- ✅ **Ubuntu 22.04.5 LTS** with Python 3.13.3
- ✅ **Virtual Environment** using venv
- ✅ **UV Package Manager** for dependency management
- ✅ **Google API Key** authentication
- ✅ **6 concurrent agents** running simultaneously

### Known Working Versions
- **Python**: 3.12.8, 3.13.3
- **UV**: Latest version via pip
- **A2A SDK**: 0.3.2 (auto-installed)
- **Google ADK**: 0.1.0+
- **MCP**: 1.1.0+

## 🚀 Quick Environment Check

Run this in your Cursor terminal to verify compatibility:

```bash
# Check Python version
python --version  # Should show 3.12+ 

# Check if pip is available
pip --version

# Check if git is available  
git --version

# Check if curl is available (for testing)
curl --version

# Check available memory
free -h  # Linux/macOS
# or
systeminfo | findstr "Total Physical Memory"  # Windows

# Check available disk space
df -h  # Linux/macOS  
# or
dir C:\ /-c  # Windows
```

## 🎯 Performance Expectations

### Startup Times
- **MCP Server**: ~3-5 seconds
- **Each Agent**: ~2-3 seconds  
- **Total System**: ~15-20 seconds for all components

### Resource Usage
- **Memory**: ~200-300MB per agent (1.5-2GB total)
- **CPU**: Low usage during idle, moderate during AI processing
- **Network**: Outbound HTTPS for Google API calls

### Expected Behavior
- All agents should start without errors
- Agent cards should load successfully (5 cards found)
- Semantic matching should work with Google embeddings
- HTTP endpoints should respond at localhost:10100-10105

---

**🎓 Professor's Environment Note:** This exact environment has been tested and verified to run the complete A2A travel planning system successfully. The specifications above ensure you can replicate the same setup in Cursor IDE on your local machine.
