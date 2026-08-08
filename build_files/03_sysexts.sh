#!/bin/bash
install -d -m 0755 -o 0 -g 0 "/var/lib/extensions" "/var/lib/extensions.d"
restorecon -RFv "/var/lib/extensions" "/var/lib/extensions.d"

systemctl enable --now systemd-sysext.service
