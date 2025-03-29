#!/bin/bash

ask_ollama() {
    local server_url=$1
    local question=$2
    local prompt=$3
    local model=$4

    # send a POST to reuquest Ollama API System.
    response=$(curl -s ${server_url} -d "{
    \"model\": \"${model}\",
    \"messages\": [
    {\"role\": \"system\", \"content\": \"${prompt}\"},
    {\"role\": \"user\", \"content\": \"${question}\"}
    ],
    \"stream\": false
    }")

    # Show, result.
    answer=$(echo $response | jq -r '.message.content')
    echo "Answser: $answer"
}

# Test function
server="http://10.31.1.7:11434/api/chat"
question="為什麼天空是藍色的？"
prompt="It's an simple anwser system."
model="llama3.2"

# 呼叫函數
ask_ollama "$server" "$question" "$prompt" "$model"

