#!/bin/bash

# sysext prereqs
# install -d -m 0755 -o 0 -g 0 "/var/lib/extensions" "/var/lib/extensions.d"
# restorecon -RFv "/var/lib/extensions" "/var/lib/extensions.d"

FCOS_SYSEXT_URL=https://extensions.fcos.fr/fedora
COMMUNITY_SYSEXT_URL=https://extensions.fcos.fr/community

# sysexts-manager
VERSION="0.3.3"
VERSION_ID="44" # Fedora release
ARCH="x86-64"
URL="https://github.com/travier/sysexts-manager/releases/download/sysexts-manager/"
NAME="sysexts-manager-${VERSION}-${VERSION_ID}-${ARCH}.raw"
install -d -m 0755 -o 0 -g 0 "/var/lib/extensions"{,.d} "/run/extensions"
curl --silent --fail --location "${URL}/${NAME}" \
    | bash -c "cat > /var/lib/extensions.d/${NAME}"
ln -snf "/var/lib/extensions.d/${NAME}" "/var/lib/extensions/sysexts-manager.raw"
restorecon -RFv "/var/lib/extensions"{,.d} "/run/extensions"
systemctl enable systemd-sysext.service
systemctl restart systemd-sysext.service

sysexts-manager add ghostty $COMMUNITY_SYSEXT_URL
sysexts-manager add nvim $FCOS_SYSEXT_URL

sysexts-manager enable ghostty
sysexts-manager enable nvim
