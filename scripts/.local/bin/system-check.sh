#!/bin/bash

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}--- Server Health Report ($(hostname)) ---${NC}"

# -----------------------------------------------------------------------------
# Disk Usage
#
# Focusses on root (`/`), data drives, and `/tmp`.
#
# Highlights entries above certain thresholds.
# -----------------------------------------------------------------------------

echo -e "\n${GREEN}[ Disk Usage ]${NC}"
df -h | grep -E '^/dev/| /$| /tmp$' | awk -v YELLOW="${YELLOW}" -v RED="${RED}" -v NC="${NC}" '{
    usage = $5 + 0
    msg = $5 " usage on " $6
    if (usage >= 90) {
        print RED msg NC
    } else if (usage >= 80) {
        print YELLOW msg NC
    } else {
        print msg
    }
}'

# Memory Usage
echo -e "\n${GREEN}[ Memory Usage ]${NC}"
free -h | awk '/^Mem:/ {print "Used: "$3" / Total: "$2}'

# CPU Temperature (Requires 'lm-sensors' package)
if command -v sensors > /dev/null; then
    echo -e "\n${GREEN}[ CPU Temp ]${NC}"
    sensors | grep -E 'Package|Core 0' | awk '{print $1, $2, $3}'
fi

# Docker Container Status
if command -v docker > /dev/null; then
    echo -e "\n${GREEN}[ Docker Status ]${NC}"
    RUNNING=$(docker ps -q | wc -l)
    TOTAL=$(docker ps -a -q | wc -l)
    echo "Containers: ${RUNNING} running / ${TOTAL} total"
    if [ "${RUNNING}" -lt "${TOTAL}" ]; then
        echo -e "${RED}Warning: Some containers are stopped!${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# Pending Updates:
#
# Ignores packages in Ubuntu's phased update rollout
# -----------------------------------------------------------------------------

echo -e "\n${GREEN}[ Updates ]${NC}"

# Run the simulation once and store the output
SIM_OUTPUT=$(apt-get -s upgrade 2>/dev/null)

# Calculate counts
TOTAL_UPDATES=$(echo "${SIM_OUTPUT}" | grep -c "^Inst")
SECURITY_UPDATES=$(echo "${SIM_OUTPUT}" | grep "^Inst" | grep -i -c "security")
REGULAR_UPDATES=$((TOTAL_UPDATES - SECURITY_UPDATES))

# Display the split counts.
# Conditionally color-code the output if security updates are present.
if [ "${SECURITY_UPDATES}" -gt 0 ]; then
    echo -e "${TOTAL_UPDATES} packages can be updated (${RED}${SECURITY_UPDATES} security${NC}, ${REGULAR_UPDATES} regular)."
else
    echo "${TOTAL_UPDATES} packages can be updated (${SECURITY_UPDATES} security, ${REGULAR_UPDATES} regular)."
fi

echo -e "\n${YELLOW}----------------------------${NC}"
