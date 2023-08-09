#!/bin/bash

# Set API URL
API_URL="https://ipv64.net/api"

# Set your API key/token
API_KEY=""

# Set Blocker ID
BLOCKER_ID=""

# Function to validate IP address
function validate_ip() {
    local ip="$1"
    local IFS='.'
    ip=($ip)
    local octet_count=${#ip[@]}
    
    if [[ $octet_count -eq 4 ]]; then
        for octet in "${ip[@]}"; do
            if ! [[ "$octet" =~ ^[0-9]+$ ]] || ! ((octet >= 0 && octet <= 255)); then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Input IP
while true; do
    read -p "Enter the poisoned IP: " REPORT_IP
    if validate_ip "$REPORT_IP"; then
        break
    else
        echo "Invalid input. Please try again."
    fi
done

# Input port
while true; do
    read -p "Enter the destination port (1-65535): " PORT
    # Validate port input
    if [[ "$PORT" =~ ^[0-9]+$ && "$PORT" -ge 1 && "$PORT" -le 65535 ]]; then
        break
    else
        echo "Invalid port number. Please enter a valid port between 1 and 65535."
    fi
done

# Input category
echo "Select a category:"
echo "1: SSH, 2: HTTPs, 3: Mail, 4: FTP, 5: ICMP, 6: DoS"
echo "7: DDoS, 8: Flooding, 9: Web, 10: Malware, 11: Bots"
echo "12: TCP, 13: UDP"
while true; do
    read -p "Enter the category number: " CATEGORY
    # Validate category input
    if [[ "$CATEGORY" =~ ^[0-9]+$ && "$CATEGORY" -ge 1 && "$CATEGORY" -le 13 ]]; then
        break
    else
        echo "Invalid category number. Please enter a valid category number between 1 and 13."
    fi
done

# Input additional info
read -p "Enter additional information (optional): " INFO

# Send API request
response=$(curl -X POST "$API_URL" \
     -H "Authorization: Bearer $API_KEY" \
     -d "blocker_id=$BLOCKER_ID" \
     -d "report_ip=$REPORT_IP" \
     -d "port=$PORT" \
     -d "category=$CATEGORY" \
     -d "info=$INFO" 2>&1)

if [[ "$response" == *"Unauthorized"* ]]; then
    echo "Unauthorized. Please check your API key."
    exit 1
elif [[ "$response" == *"error"* ]]; then
    echo "An error occurred while sending the report."
    echo "Response: $response"
    exit 1
fi

echo "Report sent successfully!"
