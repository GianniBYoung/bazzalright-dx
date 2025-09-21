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
    xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/GianniBYoung/bazzalright-dx/refs/heads/main/build_files/flatpak.list ) flatpak --system -y install
    echo "Flatpaks installation complete."

g-chezmoi:
    #!/usr/bin/env bash
    brew install chezmoi
    chezmoi init git@github.com:GianniBYoung/frenchfiles.git
