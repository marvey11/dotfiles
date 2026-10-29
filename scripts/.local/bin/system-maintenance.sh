#!/usr/bin/env bash

set -euo pipefail

# Check if running as root (EUID 0)
if [[ ${EUID} -ne 0 ]]; then
    echo "Error: This script must be run with elevated privileges (e.g., using sudo)." >&2
    exit 1
fi

echo "==> Cleaning outdated local package archives..."
apt-get autoclean

echo "==> Removing orphaned packages and their config files..."
apt-get autopurge -y

echo "==> Cleaning up residual package configuration files..."
# Purges packages left in a 'rc' (remove/config-leftover) state
if dpkg -l | grep -q '^rc'; then
    dpkg --purge "$(dpkg -l | awk '/^rc/ {print $2}')"
else
    echo "No leftover configurations found."
fi

echo "==> APT maintenance complete!"
