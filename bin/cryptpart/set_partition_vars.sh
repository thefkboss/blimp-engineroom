#!/bin/bash

# key
KEY_DEVICE=/dev/disk/by-label/cf-key
KEY_MOUNTPOINT=/storage-key
KEYFILE=$KEY_MOUNTPOINT/key

# TODO - find where the usb drive is via lsblk, label or something.
STORAGE_DEVICE=/dev/sda

SWAP_PARTITION=${STORAGE_DEVICE}1
STORAGE_PARTITION=${STORAGE_DEVICE}2

SWAP_PARTITION_LABEL=cloudfleet-swap
STORAGE_PARTITION_LABEL=cloudfleet-storage

SWAP_MAPPED_DEVICE=/dev/mapper/$SWAP_PARTITION_LABEL
STORAGE_MAPPED_DEVICE=/dev/mapper/$STORAGE_PARTITION_LABEL

STORAGE_MOUNTPOINT=/storage
