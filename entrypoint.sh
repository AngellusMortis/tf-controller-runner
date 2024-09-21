#!/bin/bash

cp -p -R /nix-init/store /nix/store
mv /nix-init/var /nix/var

if [[ -z "$@" ]]; then
    /sbin/tini -- tf-runner
else
    exec "$@"
fi
