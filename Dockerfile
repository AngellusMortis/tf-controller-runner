FROM ghcr.io/weaveworks/tf-runner:v0.15.1

LABEL org.opencontainers.image.source=https://github.com/AngellusMortis/tf-controller-runner

USER root

ARG BUILD_TAG=test
ARG TARGETPLATFORM
RUN --mount=target=/var/cache/apk,type=cache,sharing=locked,id=apk-$TARGETPLATFORM \
    apk update \
    && apk add curl xz bash jq shadow sudo \
    && mkdir -m 0755 /nix /nix-init /etc/nix /nix-init/user-profiles /nix/user-cache /home/runner/.cache \
    && chown 65532:65532 /nix /nix-init /nix-init/user-profiles /nix/user-cache /home/runner/.cache \
    && echo "extra-experimental-features = nix-command" > /etc/nix/nix.conf \
    && ln -s /nix/user-cache /home/runner/.cache/nix

USER 65532:65532

RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes

USER root

RUN ln -s channels-2-link /nix-init/user-profiles/channels \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/channels-1-link) /nix-init/user-profiles/channels-1-link \
    && ln -s profile-1-link /nix-init/user-profiles/profile \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/profile-1-link) /nix-init/user-profiles/profile-1-link \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-build \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-channel \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-collect-garbage \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-copy-closure \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-daemon \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-env \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-hash \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-instantiate \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-prefetch-url \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-shell \
    && ln -s /nix-init/user-profiles/profile/bin/nix /usr/local/bin/nix-store

USER 65532:65532

RUN nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware \
    && nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager \
    && nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix \
    && nix-channel --update \
    && cp -p -R /nix/store /nix-init/store \
    && mv /nix/var /nix-init/var \
    && mv /nix/user-cache /nix-init/user-cache \
    && echo "$BUILD_TAG" > /nix-init/build-version

USER root

COPY ./entrypoint.sh /entrypoint
RUN chmod +x /entrypoint \
    && ln -s $(readlink -f /home/runner/.local/state/nix/profiles/channels-2-link) /nix-init/user-profiles/channels-2-link

USER 65532:65532
ENTRYPOINT [ "/entrypoint" ]
