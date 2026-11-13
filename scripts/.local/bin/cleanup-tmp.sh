#! /usr/bin/env bash

set -euo pipefail

# ----------------------------------------------------------------------------
# Prunes stale development tool files in /tmp with dry-run and space reporting
# ----------------------------------------------------------------------------

# Colors for better readability
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check for dry-run flag
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
    DRY_RUN=true
fi

# Check /tmp usage percentage
TMP_USAGE=$(df /tmp | awk 'NR==2 {print $5}' | tr -d '%')

# Run if usage is >= 80%, or if dry-run mode was explicitly requested
if [ "${TMP_USAGE}" -ge 80 ] || [ "${DRY_RUN}" = true ]; then
    if [ "${DRY_RUN}" = true ]; then
        echo -e "${YELLOW}[ Dry-Run ] Simulating cleanup on /tmp (Current usage: ${TMP_USAGE}%)...${NC}"
    else
        echo -e "${YELLOW}[ Warning ] /tmp usage is at ${TMP_USAGE}%. Pruning stale development caches...${NC}"
    fi

    # Record available space in bytes before cleanup
    BYTES_BEFORE=$(df -B1 /tmp | awk 'NR==2 {print $4}')

    if [ "${DRY_RUN}" = true ]; then
        echo "Files/directories that match cleanup criteria:"
        find /tmp/node-compile-cache -mindepth 1 -mtime +3 -print 2>/dev/null || true
        find /tmp -mindepth 1 -maxdepth 1 \( \
            -name "pyright-*" -o \
            -name "pytest-of-marvey" -o \
            -name "python-languageserver-cancellation" -o \
            -name "vscode-typescript1000" \
        \) -mtime +3 -print 2>/dev/null || true
        echo "Dry-run complete. No files were removed."
    else
        # Prune stale files *inside* persistent cache folders
        find /tmp/node-compile-cache -mindepth 1 -mtime +3 -exec rm -rf {} + 2>/dev/null || true

        # Remove entire stale session/cache directories matching patterns
        find /tmp -mindepth 1 -maxdepth 1 \( \
            -name "pyright-*" -o \
            -name "pytest-of-marvey" -o \
            -name "python-languageserver-cancellation" -o \
            -name "vscode-typescript1000" \
        \) -mtime +3 -exec rm -rf {} + 2>/dev/null || true

        # Record available space after cleanup and calculate difference
        BYTES_AFTER=$(df -B1 /tmp | awk 'NR==2 {print $4}')
        FREED_BYTES=$((BYTES_AFTER - BYTES_BEFORE))

        if [ "${FREED_BYTES}" -gt 0 ]; then
            FREED_MB=$((FREED_BYTES / 1024 / 1024))
            echo -e "${GREEN}[ Success ] Cleaned up successfully. Freed approximately ${FREED_MB} MB of disk space.${NC}"
        else
            echo -e "${GREEN}[ Info ] Cleanup ran, but no stale files older than 3 days were found to remove.${NC}"
        fi
    fi
else
    echo -e "${GREEN}[ OK ] /tmp usage is at ${TMP_USAGE}%. No cleanup needed.${NC}"
fi
