#!/usr/bin/env python3

import asyncio
import httpx
import json

async def test_orchestrator():
    """Test the orchestrator agent with a complex travel planning request."""
    async with httpx.AsyncClient(timeout=30.0) as client:
        print("🚀 Testing A2A Multi-Agent Orchestration...")
        print("📍 Sending complex travel request to Orchestrator Agent (port 10101)")
        
        try:
            response = await client.post(
                'http://localhost:10101/tasks',
                json={
                    'message': {
                        'parts': [{
                            'type': 'text',
                            'text': 'Plan a complete 5-day trip to Paris, France for 2 adults from March 15-20, 2025. I need flights from New York, a hotel in central Paris, and a rental car for sightseeing.'
                        }]
                    }
                },
                headers={'Content-Type': 'application/json'}
            )
            
            print(f"✅ Response Status: {response.status_code}")
            print("📋 Response Content:")
            print(json.dumps(response.json(), indent=2))
            
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(test_orchestrator())
