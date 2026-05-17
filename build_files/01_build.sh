#!/bin/bash

set -ouex pipefail

### Install packages
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 install -y --refresh zsh kitty fish vicinae

# Add Incus Repo
dnf5 -y copr enable ganto/lxc4
dnf5 -y install incus
dnf5 -y copr disable ganto/lxc4
dnf5 -y install virt-viewer

systemctl enable incus.socket

# Enable the socket for on-demand start
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty
dnf5 -y copr disable scottames/ghostty
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket podman-auto-update.timer

systemctl disable cups pcscd raid-check smartd

mkdir -p /usr/share/ublue-os/additional-justs
