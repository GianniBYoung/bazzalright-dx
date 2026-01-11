#!/bin/bash

for f in /usr/share/ublue-os/additional-justs/*.just; do
    if grep -iqE "^import\?? \"$f\"" /usr/share/ublue-os/just/60-custom.just; then
        continue
    fi
    echo "import? \"$f\"" >> /usr/share/ublue-os/just/60-custom.just
done
