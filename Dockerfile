FROM ghcr.io/weaveworks/tf-runner:v0.15.1 

LABEL org.opencontainers.image.source=https://github.com/AngellusMortis/tf-controller-runner

USER root

ARG TARGETPLATFORM
RUN --mount=target=/var/cache/apk,type=cache,sharing=locked,id=apk-$TARGETPLATFORM \
    apk update \
    && apk add curl xz bash jq shadow sudo \
    && mkdir -m 0755 /nix \
    && chown 65532:65532 /nix

USER 65532:65532

ENV PATH=/home/runner/.nix-profile/bin:$PATH
ENV NIX_CONF_DIR=/home/runner/.local/nix
RUN sh <(curl -L https://nixos.org/nix/install) --yes \
    && mkdir -p $NIX_CONF_DIR \
    && echo "extra-experimental-features = nix-command" > $NIX_CONF_DIR/nix.conf \
    && nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware \
    && nix-channel --update
