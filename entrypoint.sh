#!/bin/bash

cp -p -R /nix-init/store /nix/store
cp -p -R /nix-init/var /nix/var

rm -rf /home/runner/.local/state/nix/ || true
mkdir -p /home/runner/.local/state/nix/
ln -s /nix-init/user-profiles /home/runner/.local/state/nix/profiles

if [[ -f "/home/runner/dev/mortis-k8s/iac/wl/dns/builder-key" ]]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    cp /home/runner/dev/mortis-k8s/iac/wl/dns/builder-key ~/.ssh/id_ed25519
fi

if [[ "$@" == "ash" ]]; then
    exec "$@"
else
    /sbin/tini -- tf-runner $@
fi
