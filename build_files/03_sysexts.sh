#!/bin/bash

# sysext prereqs
install -d -m 0755 -o 0 -g 0 "/var/lib/extensions" "/var/lib/extensions.d"
restorecon -RFv "/var/lib/extensions" "/var/lib/extensions.d"

systemctl enable --now systemd-sysext.service

# ghostty sysext installation
SYSEXT=ghostty
FCOS_COMMUNITY_URL=https://extensions.fcos.fr/community
install -d -m 0755 -o 0 -g 0 "/etc/sysupdate.${SYSEXT}.d"
restorecon -RFv "/etc/sysupdate.${SYSEXT}.d"
curl --silent --fail --location "${FCOS_COMMUNITY_URL}/${SYSEXT}.conf" \
| tee "/etc/sysupdate.${SYSEXT}.d/${SYSEXT}.conf"
/usr/lib/systemd/systemd-sysupdate update --component $SYSEXT

# # Helper function for fedora-coreos community sysext installation
# install_sysext() {
#   SYSEXT="${1}"
#   URL="https://extensions.fcos.fr/community"
#   sudo install -d -m 0755 -o 0 -g 0 "/etc/sysupdate.${SYSEXT}.d"
#   sudo restorecon -RFv "/etc/sysupdate.${SYSEXT}.d"
#   curl --silent --fail --location "${URL}/${SYSEXT}.conf" \
#     | sudo tee "/etc/sysupdate.${SYSEXT}.d/${SYSEXT}.conf"
#   sudo /usr/lib/systemd/systemd-sysupdate update --component "${SYSEXT}"
# }
