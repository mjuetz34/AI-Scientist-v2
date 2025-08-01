#!/bin/bash

# AI Scientist-v2 API-Schlüssel Setup
# Führen Sie dieses Skript aus, um die API-Schlüssel zu setzen

echo "Setting up API keys for AI Scientist-v2..."

# OpenAI API Key (versucht aus macOS Keychain zu lesen, falls verfügbar)
export OPENAI_API_KEY="$(security find-generic-password -s openai_api_key -w 2>/dev/null || echo '')"

# Gemini API Key
export GEMINI_API_KEY="AIzaSyDxvoQHXMe6YeLNYA95AbT6yJSq-ayCtr4"

# Anthropic API Key
export ANTHROPIC_API_KEY="sk-ant-api03-kfXDrH9o86N5Tuy6bjmQtOaJAlOgCxA7nQX8zS13"

# Optional: Semantic Scholar API Key (falls verfügbar)
# export S2_API_KEY="your_s2_api_key_here"

echo "API keys have been set:"
echo "OPENAI_API_KEY: ${OPENAI_API_KEY:0:10}..."
echo "GEMINI_API_KEY: ${GEMINI_API_KEY:0:10}..."
echo "ANTHROPIC_API_KEY: ${ANTHROPIC_API_KEY:0:10}..."

echo ""
echo "To make these permanent, add them to your ~/.bashrc or ~/.zshrc:"
echo ""
echo "export OPENAI_API_KEY=\"\$(security find-generic-password -s openai_api_key -w 2>/dev/null || echo '')\""
echo "export GEMINI_API_KEY=\"AIzaSyDxvoQHXMe6YeLNYA95AbT6yJSq-ayCtr4\""
echo "export ANTHROPIC_API_KEY=\"sk-ant-api03-kfXDrH9o86N5Tuy6bjmQtOaJAlOgCxA7nQX8zS13\""
echo ""
echo "Then run: source ~/.bashrc (or source ~/.zshrc)"