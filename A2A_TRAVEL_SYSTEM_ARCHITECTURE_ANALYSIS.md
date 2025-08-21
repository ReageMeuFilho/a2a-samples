# A2A Travel Planning System: Complete Architecture Analysis

## 📋 Overview

This document captures the complete architectural analysis of the A2A (Agent-to-Agent) Travel Planning System, including protocols, agent roles, LLM integration, and workflow management. This serves as a reference for comparing with other multi-agent network designs.

## 🏗️ System Architecture

### Core Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    A2A Travel Planning System                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌───────────────┐│
│  │  MCP Server     │    │  Orchestrator   │    │  Task Agents  ││
│  │  (Directory)    │◄──►│  Agent          │◄──►│  (Execution)  ││
│  │                 │    │                 │    │               ││
│  │ • Agent Cards   │    │ • WorkflowGraph │    │ • Flight      ││
│  │ • Tool Registry │    │ • Task Mgmt     │    │ • Hotel       ││
│  │ • Discovery     │    │ • Coordination  │    │ • Car         ││
│  └─────────────────┘    └─────────────────┘    └───────────────┘│
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │  Planner Agent  │    │  A2A Protocol   │                    │
│  │  (LangGraph)    │    │  (Transport)    │                    │
│  │                 │    │                 │                    │
│  │ • Task Breakdown│    │ • HTTP/SSE      │                    │
│  │ • Reasoning     │    │ • JSON-RPC      │                    │
│  │ • Planning      │    │ • Streaming     │                    │
│  └─────────────────┘    └─────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 Agent Roles and Responsibilities

### 1. Planner Agent (LangGraph)

**Purpose**: Strategic task breakdown and planning
**Technology**: LangGraph + Gemini 2.0 Flash
**LLM Usage**: 1 call per request

**Responsibilities**:

-   Receives high-level user requests
-   Uses chain-of-thought reasoning to break down requests
-   Creates structured TaskList objects
-   Handles complex reasoning and decision-making

**Example Input/Output**:

```
Input: "Plan a trip from Sao Paulo to New York"
Output: TaskList [
  {description: "Find flights from Sao Paulo to New York"},
  {description: "Find hotels in New York for August 26, 2025"},
  {description: "Find car rental options in New York"}
]
```

### 2. Orchestrator Agent (Custom WorkflowGraph)

**Purpose**: Task execution coordination and workflow management
**Technology**: Custom NetworkX-based workflow + Gemini 2.0 Flash
**LLM Usage**: 1 call for summary generation only

**Responsibilities**:

-   Creates and manages workflow graphs
-   Coordinates task execution between agents
-   Handles state management and error recovery
-   Generates final summaries (uses LLM)
-   Manages A2A communication

**Key Insight**: 90% pure logic/coordination, 10% LLM for summaries

### 3. Specialized Task Agents (ADK)

**Purpose**: Execute specific domain tasks
**Technology**: Google ADK + LiteLLM + Gemini 2.0 Flash
**LLM Usage**: 1 call per agent per task

**Agents**:

-   **Flight Agent**: Air ticketing and booking
-   **Hotel Agent**: Hotel reservation and booking
-   **Car Agent**: Car rental and booking

**Responsibilities**:

-   Execute domain-specific tasks
-   Use chain-of-thought reasoning for task completion
-   Interact with MCP tools for data access
-   Return structured booking results

## 🔄 Communication Protocols

### A2A Protocol (Agent-to-Agent)

**Purpose**: Standardized inter-agent communication
**Transport**: HTTP with Server-Sent Events (SSE)
**Format**: JSON-RPC 2.0

**Key Features**:

-   Real-time streaming communication
-   Structured message format with messageId and parts
-   Task state management (submitted → working → completed)
-   Error handling and retry mechanisms

**Message Format**:

```json
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "message/stream",
    "params": {
        "message": {
            "messageId": "task-1",
            "role": "user",
            "parts": [{ "type": "text", "text": "Find flights..." }]
        }
    }
}
```

### MCP Protocol (Model Context Protocol)

**Purpose**: Agent discovery and tool access
**Transport**: HTTP/WebSocket
**Format**: JSON-RPC 2.0

**Key Features**:

-   Agent card registry and discovery
-   Tool definitions and access
-   Semantic agent matching using embeddings
-   Dynamic tool loading

**Agent Card Example**:

```json
{
    "name": "Hotel Booking Agent",
    "description": "Book hotels given a criteria",
    "url": "http://localhost:10104",
    "capabilities": ["book_accommodation"],
    "skills": ["hotel_search", "booking_management"]
}
```

## 🧠 LLM Integration Strategy

### LLM Call Distribution

**Total LLM Calls**: 5 per typical travel request

1. **Planner Agent**: 1 call (task breakdown)
2. **Flight Agent**: 1 call (flight booking)
3. **Hotel Agent**: 1 call (hotel booking)
4. **Car Agent**: 1 call (car rental)
5. **Orchestrator Agent**: 1 call (summary generation)

### LLM Model Usage

-   **Primary Model**: Gemini 2.0 Flash
-   **Framework Integration**:
    -   LangGraph (Planner)
    -   ADK/LiteLLM (Task Agents)
    -   Direct API (Orchestrator)

### Chain-of-Thought (CoT) Implementation

All agents use structured CoT reasoning:

```python
AIRFARE_COT_INSTRUCTIONS = """
Always use chain-of-thought reasoning before responding to track where you are
in the decision tree and determine the next appropriate question.

CHAIN-OF-THOUGHT PROCESS:
1. What information do I already have?
2. What is the next unknown information?
3. How should I naturally ask for this information?
4. What context should I include?
5. If I have all information, proceed to search
"""
```

## 🔄 Workflow Management

### LangGraph vs Custom WorkflowGraph

#### LangGraph (Planner Agent)

**Why Used**: Complex reasoning and planning
**Features**:

-   ReAct pattern (Reasoning + Acting)
-   Chain-of-thought reasoning
-   Structured output generation
-   Memory and state management

#### Custom WorkflowGraph (Orchestrator Agent)

**Why Used**: Simple, deterministic coordination
**Features**:

-   NetworkX-based directed graphs
-   Topological sorting for task execution
-   State management (INITIALIZED → RUNNING → COMPLETED)
-   Error handling and recovery

### Workflow Execution Flow

```
1. User Request → Orchestrator Agent
2. Orchestrator → Planner Agent (LangGraph)
3. Planner → TaskList → Orchestrator
4. Orchestrator → Creates WorkflowGraph
5. Orchestrator → Executes tasks sequentially
6. Task Agents → Execute with LLM reasoning
7. Orchestrator → Aggregates results
8. Orchestrator → Generates summary (LLM)
```

## 🎯 Key Architectural Decisions

### 1. Protocol Separation

-   **A2A**: Agent communication and coordination
-   **MCP**: Agent discovery and tool access
-   **Decoupled**: Content/template separate from transport

### 2. Agent Specialization

-   **Planner**: Strategic thinking (LangGraph)
-   **Orchestrator**: Tactical execution (Custom)
-   **Task Agents**: Domain expertise (ADK)

### 3. LLM Usage Optimization

-   **Complex reasoning**: Use LLM (planning, task execution)
-   **Simple coordination**: Use pure logic (workflow management)
-   **Summary generation**: Use LLM (final output)

### 4. Fault Tolerance

-   **Real-time communication**: HTTP/SSE for streaming
-   **State management**: Task state tracking
-   **Error handling**: Retry mechanisms and error recovery
-   **Agent isolation**: Independent agent processes

## 📊 Performance Characteristics

### Scalability

-   **Horizontal scaling**: Independent agent processes
-   **Load distribution**: MCP-based agent discovery
-   **Resource isolation**: Separate processes per agent

### Reliability

-   **State persistence**: Task state management
-   **Error recovery**: Automatic retry mechanisms
-   **Graceful degradation**: Agent failure handling

### Latency

-   **Real-time streaming**: Immediate status updates
-   **Parallel execution**: Independent agent processing
-   **Optimized LLM usage**: Minimal LLM calls

## 🔍 Comparison Framework

### For Future Protocol Comparisons, Consider:

1. **Protocol Design**

    - Communication standards
    - Message formats
    - Error handling

2. **Agent Architecture**

    - Role specialization
    - Coordination mechanisms
    - State management

3. **LLM Integration**

    - Usage patterns
    - Model selection
    - Reasoning frameworks

4. **Workflow Management**

    - Execution patterns
    - State tracking
    - Error recovery

5. **Performance Metrics**

    - Latency
    - Throughput
    - Reliability
    - Scalability

6. **Developer Experience**
    - Ease of implementation
    - Debugging capabilities
    - Monitoring and observability

## 📝 Implementation Notes

### Environment Setup

-   **Python 3.12+** required
-   **UV package manager** for dependencies
-   **Google API Key** for Gemini models
-   **OpenAI API Key** (optional fallback)

### Key Dependencies

-   **LangGraph**: For planner agent
-   **Google ADK**: For task agents
-   **A2A SDK**: For agent communication
-   **MCP SDK**: For agent discovery
-   **NetworkX**: For workflow graphs

### Configuration

-   **Agent ports**: 10101-10105
-   **MCP server**: Localhost:10100
-   **Environment variables**: API keys and model settings

## 🎯 Conclusion

The A2A Travel Planning System demonstrates a sophisticated multi-agent architecture that:

1. **Separates concerns** between planning, coordination, and execution
2. **Optimizes LLM usage** for complex reasoning while using pure logic for coordination
3. **Provides fault tolerance** through state management and error recovery
4. **Enables scalability** through independent agent processes
5. **Maintains flexibility** through protocol-based communication

This architecture serves as a robust baseline for comparing other multi-agent protocols and frameworks.

---

_Document created for architectural comparison and reference purposes._
_Date: [Current Date]_
_System: A2A Travel Planning System_
_Version: [Current Version]_
