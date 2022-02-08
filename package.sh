#!/usr/bin/env bash

set -euo pipefail

# This file packages up the build artifacts from the Linux Kernel
# This is mostly used for the CI, but can also be used by the user

source INFO

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

echo "==> Preparing the packaging process..."
mkdir -p $SCRIPT_DIR/boot
#mkdir -p $SCRIPT_DIR/lib/modules/linux-t2
mkdir -p $SCRIPT_DIR/usr/src/${KERNEL_DIR}

echo "==> Creating linux-${KERNEL_VERSION}-t2-img.tar.xz..."
cd $SCRIPT_DIR/${KERNEL_DIR}
INSTALL_MOD_PATH=$SCRIPT_DIR make modules_install
INSTALL_PATH=$SCRIPT_DIR/boot make install
tar -cz $SCRIPT_DIR/boot $SCRIPT_DIR/lib > $SCRIPT_DIR/linux-${KERNEL_VERSION}-t2-img.tar.xz

echo "==> Creating linux-${KERNEL_VERSION}-t2-src.tar.xz..."
cp -r $SCRIPT_DIR/${KERNEL_DIR}/* $SCRIPT_DIR/usr/src/${KERNEL_DIR}/
cd $SCRIPT_DIR/usr/src/${KERNEL_DIR}
make clean
tar -cz $SCRIPT_DIR/usr > $SCRIPT_DIR/linux-${KERNEL_VERSION}-t2-src.tar.xz

echo "==> Cleaning up..."
rm -rf $SCRIPT_DIR/boot $SCRIPT_DIR/lib $SCRIPT_DIR/usr

echo "Finished packing everything up."