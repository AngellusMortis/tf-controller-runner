FROM ghcr.io/weaveworks/tf-runner:v0.15.1 

LABEL org.opencontainers.image.source=https://github.com/AngellusMortis/tf-controller-runner

USER root

ARG TARGETPLATFORM
RUN --mount=target=/var/cache/apk,type=cache,sharing=locked,id=apk-$TARGETPLATFORM \
    apk update \
    && apk add bash

USER 65532:65532
