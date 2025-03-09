#!/usr/bin/env bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
UBUNTU_MIRROR=${UBUNTU_MIRROR:-"http://archive.ubuntu.com/ubuntu"}
UBUNTU_SECURITY_MIRROR=${UBUNTU_SECURITY_MIRROR:-"http://security.ubuntu.com/ubuntu"}
USER_NAME=${USER_NAME:-"comfy"}
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

replace_apt_sources() {
    echo "Replacing apt source $1 with $2"
    # If we have /etc/apt/sources.list
    if [ -f /etc/apt/sources.list ]; then
        sed -i "s%$1%$2%g" /etc/apt/sources.list
    fi
    # If we have /etc/apt/sources.list.d/*
    if [ -d /etc/apt/sources.list.d ]; then
        if [ "$(ls -A /etc/apt/sources.list.d)" ]; then
            for file in /etc/apt/sources.list.d/*; do
                sed -i "s%$1%$2%g" $file
            done
        else
            echo "No files found in /etc/apt/sources.list.d/"
        fi
    else
        echo "/etc/apt/sources.list.d/ directory does not exist"
    fi
}

replace_apt_sources "http://archive.ubuntu.com/ubuntu" ${UBUNTU_MIRROR:-"http://archive.ubuntu.com/ubuntu"}
replace_apt_sources "http://security.ubuntu.com/ubuntu" ${UBUNTU_SECURITY_MIRROR:-"http://security.ubuntu.com/ubuntu"}

apt_retry_conf=$(cat <<EOF
Acquire::Retries "100";
Acquire::https::Timeout "240";
Acquire::http::Timeout "240";
APT::Get::Assume-Yes "true";
APT::Install-Recommends "false";
APT::Install-Suggests "false";
Debug::Acquire::https "true";
EOF
)
echo "$apt_retry_conf" > /etc/apt/apt.conf.d/99retry

apt_packages="curl tree wget ca-certificates unzip bzip2 xz-utils zip nano vim-tiny less jq lsb-release apt-transport-https sudo tmux ffmpeg libsm6 libxext6 libxrender-dev libssl3 git"

rm -rf /var/lib/apt/lists/*
apt-get update -y
apt-get -y install --no-install-recommends ${apt_packages}
apt-get -y clean
rm -rf /var/lib/apt/lists/*

addgroup --gid $USER_GID $USER_NAME
adduser --disabled-password --gecos "" --uid $USER_UID --gid $USER_GID $USER_NAME
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME