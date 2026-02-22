#!/bin/bash

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- Server Health Report ---${NC}"

# 1. Disk Usage (Focus on root and data drives)
echo -e "\n${GREEN}[ Disk Usage ]${NC}"
df -h | grep -E '^/dev/| /$' | awk '{ print $5 " usage on " $6 }'

# 2. Memory Usage
echo -e "\n${GREEN}[ Memory Usage ]${NC}"
free -h | awk '/^Mem:/ {print "Used: "$3" / Total: "$2}'

# 3. CPU Temperature (Requires 'lm-sensors' package)
if command -v sensors > /dev/null; then
    echo -e "\n${GREEN}[ CPU Temp ]${NC}"
    sensors | grep -E 'Package|Core 0' | awk '{print $1, $2, $3}'
fi

# 4. Docker Container Status
if command -v docker > /dev/null; then
    echo -e "\n${GREEN}[ Docker Status ]${NC}"
    RUNNING=$(docker ps -q | wc -l)
    TOTAL=$(docker ps -a -q | wc -l)
    echo "Containers: $RUNNING running / $TOTAL total"
    if [ "$RUNNING" -lt "$TOTAL" ]; then
        echo -e "${RED}Warning: Some containers are stopped!${NC}"
    fi
fi

# 5. Pending Updates
echo -e "\n${GREEN}[ Updates ]${NC}"
UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing" | wc -l)
echo "$UPDATES packages can be updated."

echo -e "\n${YELLOW}----------------------------${NC}"
