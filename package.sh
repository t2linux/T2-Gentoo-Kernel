#!/usr/bin/env bash

set -euo pipefail

# This file packages up the build artifacts from the Linux Kernel
# This is mostly used for the CI, but can also be used by the user

KERNEL_VERSION=5.16.1
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

echo "==> Preparing the packaging process..."
mkdir -p $SCRIPT_DIR/boot
mkdir -p $SCRIPT_DIR/lib/modules/linux-t2
mkdir -p $SCRIPT_DIR/usr/src/linux-t2

echo "==> Creating linux-t2-${KERNEL_VERSION}.tar.xz..."
cp $SCRIPT_DIR/linux-t2/.config $SCRIPT_DIR/boot/config-${KERNEL_VERSION}
cp $SCRIPT_DIR/linux-t2/System.map-${KERNEL_VERSION} $SCRIPT_DIR/boot/
cp $SCRIPT_DIR/linux-t2/vmlinuz-${KERNEL_VERSION} $SCRIPT_DIR/boot/
cd $SCRIPT_DIR/linux-t2
INSTALL_MOD_PATH=$SCRIPT_DIR/lib make modules_install
tar -cz $SCRIPT_DIR/boot $SCRIPT_DIR/lib > $SCRIPT_DIR/linux-t2-${KERNEL_VERSION}.tar.xz

echo "==> Creating linux-t2-src-${KERNEL_VERSION}.tar.xz..."
cp $SCRIPT_DIR/linux-t2/* $SCRIPT_DIR/usr/src/linux-t2/
cd $SCRIPT_DIR/usr/src/linux-t2
make clean
tar -cz $SCRIPT_DIR/usr > $SCRIPT_DIR/linux-t2-src-${KERNEL_VERSION}.tar.xz

echo "==> Cleaning up..."
rm -rf $SCRIPT_DIR/boot $SCRIPT_DIR/lib $SCRIPT_DIR/usr

echo "Finished packing everything up."