#!/bin/bash

set -ouex pipefail

### Install packages
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/terra.repo
dnf5 install -y --refresh  vicinae
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/terra.repo

# Add Incus Repo
dnf5 -y copr enable ganto/lxc4
dnf5 -y install incus
dnf5 -y copr disable ganto/lxc4
dnf5 -y install virt-viewer erofs-utils

systemctl enable incus.socket

# Enable the socket for on-demand start
# dnf5 -y copr enable scottames/ghostty
# dnf5 -y install ghostty
# dnf5 -y copr disable scottames/ghostty
# Use a COPR Example:

systemctl enable podman.socket podman-auto-update.timer

systemctl disable cups pcscd raid-check smartd

mkdir -p /usr/share/ublue-os/additional-justs

# Install Handy and its dependencies
dnf5 -y install gtk-layer-shell

# Dynamically fetch the .rpm matching the build architecture (ignoring .sig files)
# ARCH=$(uname -m)
# DOWNLOAD_URL=$(curl -s https://api.github.com/repos/cjpais/handy/releases/latest | grep -E "browser_download_url.*${ARCH}\.rpm\"" | cut -d '"' -f 4)

# curl -Lo /tmp/handy.rpm "$DOWNLOAD_URL"
# dnf5 -y install /tmp/handy.rpm
# rm -f /tmp/handy.rpm

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/AprilNEA/OpenLogi/releases/latest| grep -E "browser_download_url.*amd64\.rpm\"" | cut -d '"' -f 4)

curl -Lo /tmp/openlogi.rpm "$DOWNLOAD_URL"
dnf5 -y --setopt=tsflags=noscripts install /tmp/openlogi.rpm
rm -f /tmp/openlogi.rpm
