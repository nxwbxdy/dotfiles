#!/usr/bin/env sh

set -e

# Get calling code from argument or dmenu
if [ $# -eq 1 ]; then
    calling_code="$1"
elif [ $# -eq 0 ]; then
    calling_code=$(dmenu -p "Enter calling code:" < /dev/null)
    [ -z "$calling_code" ] && exit 1  # User cancelled dmenu
else
    echo "Usage: $0 [calling-code]" >&2
    exit 2
fi

# Validate numeric input
if ! echo "$calling_code" | grep -qE '^[0-9]+$'; then
    echo "Error: Invalid calling code - must be numeric" >&2
    exit 3
fi

# API request with timeout
api_url="https://www.apicountries.com/callingcode/$calling_code"
query_result=$(curl -s -f --max-time 10 "$api_url") || {
    status=$?
    case $status in
        22) echo "Error: Calling code not found" >&2 ;;
        28) echo "Error: Request timed out" >&2 ;;
        *) echo "Error: Failed to fetch data (curl error $status)" >&2 ;;
    esac
    exit 4
}

# Parse JSON and handle errors
country_names=$(echo "$query_result" | jq -r 'try (if . | length == 0 then "null" else .[].name end) catch "null"') || {
    echo "Error: Invalid API response" >&2
    exit 5
}

# Handle no results case
if [ "$country_names" = "null" ] || [ -z "$country_names" ]; then
    echo "Error: No country found for calling code $calling_code" >&2
    exit 6
fi

# Output results separated by newlines
echo "$country_names"
