#!/bin/bash

# labels
KEY_PARTITION_LABEL=cf-key
SWAP_PARTITION_LABEL=cf-swap
STORAGE_PARTITION_LABEL=cf-str

BASE_MOUNTPOINT=/mnt

# key
KEY_PARTITION=/dev/disk/by-label/${KEY_PARTITION_LABEL}
KEY_MOUNTPOINT=${BASE_MOUNTPOINT}/storage-key
KEYFILE=$KEY_MOUNTPOINT/key

# storage & swap
STORAGE_PARTITION=$(readlink -e /dev/disk/by-label/${STORAGE_PARTITION_LABEL})
STORAGE_DEVICE=${STORAGE_PARTITION:0:(-1)}
if [ -z "$STORAGE_PARTITION" ]; then
    # cf-str disappears from /dev/disk/by-label/ after it's formatted so we parse lsblk
    STORAGE_DEVICE=$(lsblk | ./get_storage_device.py)
fi
SWAP_PARTITION=${STORAGE_DEVICE}1
STORAGE_PARTITION=${STORAGE_DEVICE}2

SWAP_MAPPED_DEVICE=/dev/mapper/$SWAP_PARTITION_LABEL
STORAGE_MAPPED_DEVICE=/dev/mapper/$STORAGE_PARTITION_LABEL

STORAGE_MOUNTPOINT=${BASE_MOUNTPOINT}/storage
