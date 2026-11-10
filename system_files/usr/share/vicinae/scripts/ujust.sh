#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title ujust
# @vicinae.description Run a ujust recipe in a terminal (empty = list recipes)
# @vicinae.icon 🛠️
# @vicinae.mode silent
# @vicinae.argument1 {"type": "text", "placeholder": "recipe", "optional": true}
# @vicinae.keywords ["just", "recipe", "bazzite"]

# Split the argument into recipe + args, quote each for the inner shell.
read -ra words <<< "${1:-}"
cmd="ujust"
for w in "${words[@]}"; do cmd+=" $(printf '%q' "$w")"; done

ptyxis --new-window -T "${cmd}" \
    -x "bash -c $(printf '%q' "${cmd}; echo; read -rp 'Press Enter to close.'")" \
    >/dev/null 2>&1 &
