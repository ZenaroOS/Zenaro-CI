ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="$SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD build /tmp/build
ADD packages.json /tmp/packages.json
ADD post-build.sh /tmp/post-build.sh
ADD repos.json /tmp/repos.json
ADD scripts.json /tmp/scripts.json

COPY scripts /tmp/scripts
COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms

RUN /tmp/build/script.sh
RUN /tmp/build/add_rpm.sh
RUN /tmp/build/install_rpm.sh
RUN /tmp/build/repo.sh
RUN /tmp/build/rpm-ostree.sh
RUN /tmp/post-build.sh
RUN rm -rf /tmp/* /var/* /boot/* 
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 177 /var/tmp
