#!/bin/bash

cp -p -R /nix-init/store /nix/store
cp -p -R /nix-init/var /nix/var

if [[ "$@" == "ash" ]]; then
    exec "$@"
else
    /sbin/tini -- tf-runner $@
fi
