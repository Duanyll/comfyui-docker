#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -f "/workspace/.comfyui_installed" ]; then
    exit 1
fi

if [ -n "$DEVCONTAINER" ]; then
    exit 0
fi

curl -s -o /dev/null -w "%{http_code}" http://localhost:8188 -m 5 | grep -q "20[0-9]\|30[0-9]"