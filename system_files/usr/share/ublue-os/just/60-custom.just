g-init:
    #!/usr/bin/env bash
    export SSH_AUTH_SOCK=/home/gianni/.bitwarden-ssh-agent.sock
    export SSH_AUTH_SOCK=/home/gianni/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
    brew install chezmoi
    chezmoi init git@github.com:GianniBYoung/frenchfiles.git
    chezmoi apply
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)

g-post:
    sudo systemctl enable --now tailscaled.service
    sudo tailscale set --operator=$USER
    tailscale configure systray --enable-startup=systemd
    ujust toggle-user-motd
    ujust yazi-auto-update
    rm -rf ~/{Music,Templates,Videos,Public,Desktop}
    mkdir ~/pg || echo 'playground already exists'

yazi-auto-update:
    #!/usr/bin/env bash
    mkdir -p $HOME/.config/systemd/user
    wget https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/main/build_files/yapack-update.service -O ~/.config/systemd/user/yapack-update.service
    wget https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/main/build_files/yapack-update.timer -O ~/.config/systemd/user/yapack-update.timer
    systemctl --user daemon-reload
    systemctl --user enable yapack-update.timer

# Setup Incus permissions and initialization
setup-incus:
    #!/usr/bin/env bash
    sudo usermod -aG incus-admin $USER
    sudo systemctl enable --now incus.socket
    # Add ranges for your user
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER

    # Add ranges for the incus group/user
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 root
    @echo "Please log out and back in for group changes to take effect, then run 'incus admin init'"

# Create and enable the ydotool user service for Handy speech-to-text
setup-ydotool:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Creating systemd user unit for ydotool..."
    mkdir -p ~/.config/systemd/user
    cat << 'EOF' > ~/.config/systemd/user/ydotool.service
    [Unit]
    Description=ydotool virtual input daemon for Handy
    After=default.target

    [Service]
    Type=simple
    ExecStart=/usr/bin/ydotoold
    Restart=always
    RestartSec=3

    [Install]
    WantedBy=default.target
    EOF
    echo "Reloading systemd daemon and starting service..."
    systemctl --user daemon-reload
    systemctl --user enable --now ydotool.service
    echo "Done! ydotoold is now running and set to autostart on login."

# Re-sync sysexts to the running Fedora release (run after a major version jump)
sysexts-rebase:
    #!/usr/bin/env bash
    set -euo pipefail
    source /etc/os-release
    ARCH="$(uname -m | tr _ -)"
    echo "Host is Fedora ${VERSION_ID} (${ARCH})"
    URL=$(curl -fsSL https://api.github.com/repos/travier/sysexts-manager/releases/tags/sysexts-manager \
        | grep -oE "\"browser_download_url\": *\"[^\"]*-${VERSION_ID}-${ARCH}\.raw\"" \
        | cut -d'"' -f4 | sort -V | tail -1)
    if [[ -z "${URL}" ]]; then
        echo "No sysexts-manager build for Fedora ${VERSION_ID} yet" >&2
        exit 1
    fi
    NAME="${URL##*/}"
    echo "Installing ${NAME}"
    sudo install -d -m 0755 /var/lib/extensions /var/lib/extensions.d
    sudo curl -fL -o "/var/lib/extensions.d/${NAME}" "${URL}"
    sudo ln -snf "/var/lib/extensions.d/${NAME}" /var/lib/extensions/sysexts-manager.raw
    sudo restorecon -RF /var/lib/extensions /var/lib/extensions.d
    sudo systemctl restart systemd-sysext.service
    sudo sysexts-manager update
    sudo sysexts-manager refresh
    systemd-sysext status
