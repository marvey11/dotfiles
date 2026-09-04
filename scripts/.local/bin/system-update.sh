#!/usr/bin/env bash

set -euo pipefail

# Check if running as root (EUID 0)
if [[ ${EUID} -ne 0 ]]; then
    echo "Error: This script must be run with elevated privileges (e.g., using sudo)." >&2
    exit 1
fi

echo "Updating package lists..."
apt update

echo "Upgrading system packages..."
apt dist-upgrade -y
