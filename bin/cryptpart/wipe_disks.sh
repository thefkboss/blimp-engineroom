#!/bin/bash

# Wipe key and storage devices and label them for encrypt_device.sh
#
# usage:
#    ./wipe_disks.sh <key device> <storage device>
#
# (default: key=/dev/sdb, storage=/dev/sda)
#
# You will maybe be prompted to press 'y'.
# Interactivity with -F might be possible, but is unsafe:
#   - https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/1379902

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. $DIR/set_partition_vars.sh

$DIR/close_partition.sh

# delete btrfs subvolumes
btrfs subvolume delete ${STORAGE_MOUNTPOINT}/data
btrfs subvolume delete ${STORAGE_MOUNTPOINT}/docker

if [ -z "$1" ]; then
    KEY_DEVICE="/dev/sdb"
else
    KEY_DEVICE=$1
fi
echo "key device is ${KEY_DEVICE}"

if [ -z "$2" ]; then
    STORAGE_DEVICE="/dev/sda"
else
    STORAGE_DEVICE=$2
fi
echo "storage device is ${STORAGE_DEVICE}"

# unmount all partitions on the devices
for n in $STORAGE_DEVICE* ; do umount $n ; done
for n in $KEY_DEVICE* ; do umount $n ; done

function wipe_drives(){
    hdd="$STORAGE_DEVICE $KEY_DEVICE"
    for i in $hdd; do
	echo "d
1
d
2
d
3
n
p
1


w
" | fdisk $i; done

    # alternatively, if using FAT32 (for speed/Win debugging):
    
    # unmount all partitions on the devices - necessary again for some reason
    for n in $STORAGE_DEVICE* ; do umount $n ; done
    swapoff -a
    cryptsetup luksClose /dev/mapper/$SWAP_PARTITION_LABEL
    $DIR/close_partition.sh
    mkfs.ext4 ${STORAGE_DEVICE}1 -L ${STORAGE_PARTITION_LABEL}
    # mkfs.vfat ${STORAGE_DEVICE}1 -n ${STORAGE_PARTITION_LABEL}
    
    for n in $KEY_DEVICE* ; do umount $n ; done
    $DIR/close_partition.sh
    mkfs.ext4 ${KEY_DEVICE}1 -L ${KEY_PARTITION_LABEL}
    # mkfs.vfat ${KEY_DEVICE}1 -n ${KEY_PARTITION_LABEL}
}

wipe_drives

# revert fstab, crypttab

if [ -f /etc/fstab.original ]
then
    # we already made a copy of the first fstab, bring it back
    mv /etc/fstab /etc/fstab.backup
    cp /etc/fstab.original /etc/fstab    
else
    # zZZ
    :
fi

if [ -f /etc/crypttab ]; then
    mv /etc/crypttab /etc/crypttab.backup
fi

