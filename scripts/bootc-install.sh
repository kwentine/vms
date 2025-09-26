#!/bin/bash

BOOTC_IMAGE=registry.gitlab.com/fedora/bootc/base-images/fedora-bootc-minimal:40-amd64
DISK_FILE="$(pwd)/disks/disk.raw"

echo "Installing ${BOOTC_IMAGE##*/} to disk ${DISK_FILE/$(pwd)/.}"

# -P flag is necessary
LOOP_DEV=$(sudo losetup --show -P ${DISK_FILE})

[[ "${LOOP_DEV}" == /dev/loop* ]] || { echo "Invalid loop device: ${LOOP_DEV}"; exit 1; }

# --generic-image prevents host system firmware boot entries to be updated
sudo podman run --rm --privileged --pid=host --security-opt label=type:unconfined_t \
       -v /var/lib/containers:/var/lib/containers \
       -v /dev:/dev \
       "${BOOTC_IMAGE}" bootc install to-disk \
       --generic-image \
       --filesystem ext4 --karg="loglevel=3" "${LOOP_DEV}"
