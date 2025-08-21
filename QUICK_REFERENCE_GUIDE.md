# A2A Travel System: Quick Reference Guide

## 🎯 System Overview

**Purpose**: Multi-agent travel planning system using A2A protocol
**Architecture**: 6 agents (1 MCP server + 1 orchestrator + 1 planner + 3 task agents)
**LLM Usage**: 5 calls per request (1 planning + 3 execution + 1 summary)

## 🏗️ Agent Architecture

### Core Agents

1. **MCP Server** (Port 10100): Agent discovery and tool registry
2. **Orchestrator Agent** (Port 10101): Workflow coordination (90% logic, 10% LLM)
3. **Planner Agent** (Port 10102): Task breakdown using LangGraph + Gemini
4. **Flight Agent** (Port 10103): Air ticketing using ADK + Gemini
5. **Hotel Agent** (Port 10104): Hotel booking using ADK + Gemini
6. **Car Agent** (Port 10105): Car rental using ADK + Gemini

## 🔄 Key Protocols

### A2A Protocol

-   **Transport**: HTTP with Server-Sent Events (SSE)
-   **Format**: JSON-RPC 2.0
-   **Features**: Real-time streaming, structured messages, state management

### MCP Protocol

-   **Purpose**: Agent discovery and tool access
-   **Features**: Agent cards, semantic matching, dynamic tool loading

## 🧠 LLM Integration

### Model Usage

-   **Primary**: Gemini 2.0 Flash
-   **Frameworks**: LangGraph (planner), ADK/LiteLLM (tasks), Direct API (orchestrator)

### Call Distribution

1. **Planner**: 1 call (task breakdown)
2. **Flight Agent**: 1 call (flight booking)
3. **Hotel Agent**: 1 call (hotel booking)
4. **Car Agent**: 1 call (car rental)
5. **Orchestrator**: 1 call (summary generation)

## 🔄 Workflow Management

### LangGraph vs Custom

-   **LangGraph**: Used for complex reasoning (planner agent)
-   **Custom WorkflowGraph**: Used for simple coordination (orchestrator agent)

### Execution Flow

1. User Request → Orchestrator
2. Orchestrator → Planner (LangGraph)
3. Planner → TaskList → Orchestrator
4. Orchestrator → Creates WorkflowGraph
5. Orchestrator → Executes tasks sequentially
6. Task Agents → Execute with LLM reasoning
7. Orchestrator → Aggregates results
8. Orchestrator → Generates summary (LLM)

## 📊 Performance Characteristics

### Scalability

-   **Horizontal**: Independent agent processes
-   **Load Distribution**: MCP-based discovery
-   **Resource Isolation**: Separate processes per agent

### Reliability

-   **State Management**: Task state tracking
-   **Error Recovery**: Automatic retry mechanisms
-   **Graceful Degradation**: Agent failure handling

## 🎯 Key Insights

### Architectural Decisions

1. **Protocol Separation**: A2A for communication, MCP for discovery
2. **Agent Specialization**: Planner (strategy), Orchestrator (tactics), Tasks (execution)
3. **LLM Optimization**: Complex reasoning uses LLM, simple coordination uses logic
4. **Fault Tolerance**: Real-time communication, state management, error recovery

### Why LangGraph for Planner Only

-   **Planner**: Complex reasoning needed → LangGraph
-   **Orchestrator**: Simple coordination → Custom WorkflowGraph
-   **Task Agents**: Domain expertise → ADK

## 🔍 Comparison Framework

### Key Metrics to Compare

1. **Protocol Design**: Communication standards, message formats
2. **Agent Architecture**: Role specialization, coordination mechanisms
3. **LLM Integration**: Usage patterns, model selection, reasoning frameworks
4. **Workflow Management**: Execution patterns, state tracking, error recovery
5. **Performance**: Latency, throughput, reliability, scalability
6. **Developer Experience**: Implementation ease, debugging, monitoring

## 📝 Quick Commands

### Start System

```bash
./CURSOR_A2A_AUTOMATION_SCRIPT.sh
```

### Stop System

```bash
./CURSOR_A2A_STOP_SCRIPT.sh
```

### Test System

```bash
cd samples/python/agents/a2a_mcp
source .venv/bin/activate
uv run --env-file .env src/a2a_mcp/mcp/client.py --resource "resource://agent_cards/list" --find_agent "Plan a trip to Paris"
```

## 📚 Reference Documents

-   **Complete Analysis**: `A2A_TRAVEL_SYSTEM_ARCHITECTURE_ANALYSIS.md`
-   **Comparison Template**: `MULTI_AGENT_PROTOCOL_COMPARISON_TEMPLATE.md`
-   **Setup Guide**: `CURSOR_ENVIRONMENT_SPECS.md`

---

_Quick reference for A2A Travel System architecture and comparison framework_
