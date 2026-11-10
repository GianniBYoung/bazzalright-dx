#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Rebase Sysexts
# @vicinae.description Re-sync sysexts to the running Fedora release (ujust sysexts-rebase)
# @vicinae.icon 📦
# @vicinae.mode silent
# @vicinae.keywords ["sysext", "fedora", "upgrade", "ujust"]

# Ptyxis on purpose: the default terminal (ghostty) is itself a sysext and
# won't be loaded right after a Fedora version jump.
ptyxis --new-window -T "sysexts-rebase" \
    -x "bash -c 'ujust sysexts-rebase; echo; read -rp \"Done. Press Enter to close.\"'" \
    >/dev/null 2>&1 &
