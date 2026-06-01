#!/bin/bash

# Start Ollama in the background
ollama serve &

# Wait for Ollama server to be ready
echo "Waiting for Ollama server to start..."
while ! ollama list > /dev/null 2>&1; do
  sleep 2
done

# Create the MzansiAI model if it doesn't exist
echo "Creating MzansiAI model..."
ollama create mzansiai -f /root/.ollama/Modelfile

# Keep the container running
wait
