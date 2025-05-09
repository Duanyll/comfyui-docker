#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
USER_NAME=$(whoami)

fix_permission() {
    sudo chown -R $USER_NAME:$USER_NAME $1
}

install_comfyui() {
    echo "Installing ComfyUI"
    cd /workspace
    pip install comfy-cli
    if [ -d "/workspace/ComfyUI" ]; then
        comfy --here --skip-prompt install --nvidia --restore
    else
        comfy --here --skip-prompt install --nvidia
    fi
    echo "ComfyUI installed"
}

fix_permission ~/.local
fix_permission ~/.cache
fix_permission ~/.cache/huggingface
fix_permission /workspace

# Make sure ~/.local/bin is in PATH. If not, mkdir and add to PATH
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# If /workspace/ComfyUI not exists, install ComfyUI
if [ ! -f "/workspace/.comfyui_installed" ]; then
    install_comfyui
    touch /workspace/.comfyui_installed
fi

if [ -n "$DEVCONTAINER" ]; then
    echo "Running in DEVCONTAINER mode"
    # Copy launch.json if not exists
    if [ ! -f "/workspace/ComfyUI/.vscode/launch.json" ]; then
        mkdir -p /workspace/ComfyUI/.vscode
        cp /scripts/launch.json /workspace/ComfyUI/.vscode/launch.json
    fi
    # Just sleep forever
    tail -f /dev/null
else
    echo "Starting ComfyUI"
    cd /workspace/ComfyUI
    python main.py --listen 0.0.0.0 --port 8188
fi