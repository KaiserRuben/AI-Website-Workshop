#!/usr/bin/env python3
"""Minimal test script for Azure OpenAI API connection"""

import os
from openai import AzureOpenAI
from azure.core.credentials import AzureKeyCredential
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get credentials from environment
api_key = os.getenv("AZURE_OPENAI_API_KEY")
endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
deployment = os.getenv("AZURE_OPENAI_DEPLOYMENT", "gpt-4.1")

print(f"Testing Azure OpenAI connection...")
print(f"Endpoint: {endpoint}")
print(f"Deployment: {deployment}")
print(f"API Key: {'***' + api_key[-4:] if api_key else 'NOT SET'}")

# Test 1: Using the example code pattern
print("\n--- Test 1: Using example pattern ---")
try:
    client = AzureOpenAI(
        api_version="2024-12-01-preview",
        azure_endpoint=endpoint,
        credential=AzureKeyCredential(api_key)
    )
    
    response = client.chat.completions.create(
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Say hello in one word"}
        ],
        model=deployment,
        max_tokens=10
    )
    
    print(f"Success! Response: {response.choices[0].message.content}")
    
except Exception as e:
    print(f"Error: {type(e).__name__}: {e}")

# Test 2: Using api_key parameter
print("\n--- Test 2: Using api_key parameter ---")
try:
    client2 = AzureOpenAI(
        api_version="2024-12-01-preview",
        azure_endpoint=endpoint,
        api_key=api_key
    )
    
    response2 = client2.chat.completions.create(
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Say hello in one word"}
        ],
        model=deployment,
        max_tokens=10
    )
    
    print(f"Success! Response: {response2.choices[0].message.content}")
    
except Exception as e:
    print(f"Error: {type(e).__name__}: {e}")

# Test 3: List available deployments (if possible)
print("\n--- Test 3: Checking deployment ---")
print(f"Deployment name being used: '{deployment}'")
print("Note: Make sure this matches your actual deployment name in Azure OpenAI Studio")