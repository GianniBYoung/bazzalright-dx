# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/projectbluefin/common:latest AS common

# Base Image
FROM ghcr.io/ublue-os/bazzite-gnome:latest

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/01_build.sh && \
    ostree container commit

COPY --from=common /system_files/shared/usr/share/ublue-os/just/apps.just /usr/share/ublue-os/additional-justs
COPY --from=common /system_files/shared/usr/share/ublue-os/homebrew /usr/share/ublue-os/homebrew
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/02_additional-justs.sh && \
    ostree container commit

## Verify final image and contents are correct.
RUN bootc container lint
