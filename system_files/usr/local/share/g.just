g-install-brews:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Homebrews..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/refs/heads/main/build_files/Brewfile) brew install
    echo "Homebrews installation complete."

g-install-flatpaks:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Installing Flatpaks..."
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/refs/heads/main/build_files/flatpaks.list ) flatpak --system -y install
    echo "Flatpaks installation complete."

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
  ujust toggle-user-motd
  ujust yazi-auto-update

yazi-auto-update:
    #!/usr/bin/env bash
    mkdir -p $HOME/.config/systemd/user
    wget https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/main/build_files/yapack-update.service -O ~/.config/systemd/user/yapack-update.service
    wget https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/main/build_files/yapack-update.timer -O ~/.config/systemd/user/yapack-update.timer
    systemctl --user daemon-reload
    systemctl --user enable yapack-update.timer
