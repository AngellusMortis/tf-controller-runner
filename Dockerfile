FROM ghcr.io/weaveworks/tf-runner:v0.15.1 

LABEL org.opencontainers.image.source=https://github.com/AngellusMortis/tf-controller-runner

USER root

ARG TARGETPLATFORM
RUN --mount=target=/var/cache/apk,type=cache,sharing=locked,id=apk-$TARGETPLATFORM \
    apk update \
    && apk add curl xz bash jq shadow sudo \
    && mkdir -m 0755 /nix /etc/nix /nix/user-profiles \
    && chown 65532:65532 /nix /nix/user-profiles \
    && echo "extra-experimental-features = nix-command" > /etc/nix/nix.conf

USER 65532:65532

RUN sh <(curl -L https://nixos.org/nix/install) --no-modify-profile --no-daemon --yes

USER root

RUN ln -s channels-2-link /nix/user-profiles/channels \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/channels-1-link) /nix/user-profiles/channels-1-link \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/channels-2-link) /nix/user-profiles/channels-2-link \
    && ln -s profile-1-link /nix/user-profiles/profile \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/profile-1-link) /nix/user-profiles/profile-1-link \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-build \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-channel \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-collect-garbage \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-copy-closure \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-daemon \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-env \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-hash \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-instantiate \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-prefetch-url \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-shell \
    && ln -s /nix/user-profiles/profile/bin/nix /usr/local/bin/nix-store

USER 65532:65532

RUN nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware \
    && nix-channel --update
