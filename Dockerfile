FROM ghcr.io/weaveworks/tf-runner:v0.15.1 

LABEL org.opencontainers.image.source=https://github.com/AngellusMortis/tf-controller-runner

USER root

ARG TARGETPLATFORM
RUN --mount=target=/var/cache/apk,type=cache,sharing=locked,id=apk-$TARGETPLATFORM \
    apk update \
    && apk add curl xz bash jq shadow sudo \
    && mkdir -m 0755 /nix /etc/nix \
    && chown 65532:65532 /nix \
    && ln -s /home/runner/.config/nix.conf /etc/nix/nix.conf \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-build \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-channel \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-collect-garbage \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-copy-closure \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-daemon \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-env \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-hash \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-instantiate \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-prefetch-url \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-shell \
    && ln -s /home/runner/.nix-profile/bin/nix /usr/bin/nix-store

USER 65532:65532

RUN sh <(curl -L https://nixos.org/nix/install) --yes \
    && mkdir -p $HOME/.config \
    && echo "extra-experimental-features = nix-command" > $HOME/.config/nix.conf \
    && nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware \
    && nix-channel --update
