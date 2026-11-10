#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title ujust
# @vicinae.description Run a ujust recipe in a terminal (empty = list recipes)
# @vicinae.icon 🛠️
# @vicinae.mode silent
# @vicinae.argument1 {"type": "text", "placeholder": "recipe", "optional": true}
# @vicinae.keywords ["just", "recipe", "bazzite"]

# Split the argument into recipe + args; ghostty -e passes argv straight
# through, so no shell re-quoting is needed.
read -ra words <<< "${1:-}"

ghostty --title="ujust ${words[*]}" -e bash -c \
    'ujust "$@"; echo; read -rp "Press Enter to close."' _ "${words[@]}" \
    >/dev/null 2>&1 &
