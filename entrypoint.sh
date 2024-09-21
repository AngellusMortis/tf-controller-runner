#!/bin/bash

cp -p -R /nix-init/store /nix/store
cp -p -R /nix-init/var /nix/var

rm -rf /home/runner/.local/state/nix /home/runner/.nix-defexpr /home/runner/.nix-profile || true
mkdir -p /home/runner/.local/state/nix /home/runner/.nix-defexpr
ln -s /nix-init/user-profiles /home/runner/.local/state/nix/profiles
ln -s /home/runner/.local/state/nix/profiles/channels /home/runner/.nix-defexpr/channels
ln -s /nix/var/nix/profiles/per-user/root/channels /home/runner/.nix-defexpr/channels_root
ln -s /home/runner/.local/state/nix/profiles/profile /home/runner/.nix-profile

cat > /home/runner/.nix-channels << EOF
https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
https://nixos.org/channels/nixpkgs-unstable nixpkgs
EOF

if [[ -f "/home/runner/dev/mortis-k8s/iac/wl/dns/builder-key" ]]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    cp /home/runner/dev/mortis-k8s/iac/wl/dns/builder-key ~/.ssh/id_ed25519
fi

if [[ "$@" == "ash" ]]; then
    exec "$@"
else
    /sbin/tini -s -- tf-runner $@
fi
