#!/bin/bash

# Set API URL
API_URL="https://ipv64.net/api"

# Set your API key/token
API_KEY=""

# Set Blocker ID
BLOCKER_ID=""

# Function to report IPs with retry on API limit failure
report_ip_list_with_retry() {
    local JSON_DATA="$1"
    local MAX_RETRY_ATTEMPTS=3
    local RETRY_COUNT=0

    while [ "$RETRY_COUNT" -lt "$MAX_RETRY_ATTEMPTS" ]; do
        RESPONSE=$(curl -X POST -H "Authorization: Bearer $API_KEY" \
             -d "blocker_id=$BLOCKER_ID" \
             -d "report_ip_list=$JSON_DATA" \
             "$API_URL")

        if [ "$?" -eq 0 ] && echo "$RESPONSE" | grep -q '"info":"success"'; then
            echo "IPs reported successfully."
            break
        else
            echo "Reporting IPs failed. Retrying in 10 seconds..."
            sleep 10
            RETRY_COUNT=$((RETRY_COUNT + 1))
        fi
    done
}

# Input IP addresses separated by commas
read -p "Enter the poisoned IP addresses separated by commas: " IP_LIST
IFS=',' read -ra IP_ARRAY <<< "$IP_LIST"

# Input port
read -p "Enter the destination port (1-65535): " PORT

# Input category
echo "Select a category:"
echo "1: SSH, 2: HTTPs, 3: Mail, 4: FTP, 5: ICMP, 6: DoS"
echo "7: DDoS, 8: Flooding, 9: Web, 10: Malware, 11: Bots"
echo "12: TCP, 13: UDP"
read -p "Enter the category number: " CATEGORY

# Input additional info
read -p "Enter additional information (optional): " INFO

# Construct the JSON payload
declare -a REPORT_DATA
for ip in "${IP_ARRAY[@]}"; do
    REPORT_DATA+=("{\"ip\":\"$ip\",\"category\":\"$CATEGORY\",\"info\":\"$INFO\",\"port\":\"$PORT\"}")
done
JSON_PAYLOAD="{\"ip_list\":[$(IFS=,; echo "${REPORT_DATA[*]}")]}"

# Send API request
response=$(curl -X POST "$API_URL" \
     -H "Authorization: Bearer $API_KEY" \
     -d "blocker_id=$BLOCKER_ID" \
     -d "report_ip_list=$JSON_PAYLOAD" 2>&1)

if [[ "$response" == *"Unauthorized"* ]]; then
    echo "Unauthorized. Please check your API key."
    exit 1
elif [[ "$response" == *"error"* ]]; then
    echo "An error occurred while sending the report."
    echo "Response: $response"
    exit 1
fi

echo "Report(s) sent successfully!"
