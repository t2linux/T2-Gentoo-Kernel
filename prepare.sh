#!/usr/bin/env bash

set -euo pipefail

# This file prepares for compiling the kernel.
# It first fetches the latest Linux Kernel (that is both supported by gentoo-sources and the t2-linux patches)
# Then downloads all patches needed and applies them.

source INFO

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

echo "==> Downloading Linux Kernel version ${KERNEL_VERSION}..."
curl -o $SCRIPT_DIR/linux.tar.xz https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VERSION//.*}.x/linux-${KERNEL_VERSION}.tar.xz

echo "==> Unpacking Linux Kernel..."
tar xf $SCRIPT_DIR/linux.tar.xz
mv $SCRIPT_DIR/linux-${KERNEL_VERSION} $SCRIPT_DIR/${KERNEL_DIR}

echo "==> Grabbing patches..."
mkdir $SCRIPT_DIR/all-patches
git clone https://anongit.gentoo.org/git/proj/linux-patches.git $SCRIPT_DIR/gentoo-patches
mv $SCRIPT_DIR/gentoo-patches/*.patch $SCRIPT_DIR/all-patches/
rm -rf $SCRIPT_DIR/gentoo-patches
git clone https://github.com/Redecorating/mbp-16.1-linux-wifi $SCRIPT_DIR/t2-patches
mv $SCRIPT_DIR/t2-patches/*.patch $SCRIPT_DIR/all-patches/
rm -rf $SCRIPT_DIR/t2-patches

echo "==> Grabbing apple-bce and apple-ibridge..."
git clone https://github.com/t2linux/apple-bce-drv $SCRIPT_DIR/apple-bce
git clone https://github.com/t2linux/apple-ib-drv $SCRIPT_DIR/apple-ibridge
for i in apple-bce apple-ibridge; do
  echo "==> Copying $i to drivers/staging..."
  mkdir $SCRIPT_DIR/${KERNEL_DIR}/drivers/staging/$i
  cp -r $SCRIPT_DIR/$i/* $SCRIPT_DIR/${KERNEL_DIR}/drivers/staging/$i/
 done
 
echo "==> Applying patches..."
cd $SCRIPT_DIR/${KERNEL_DIR}
for i in $SCRIPT_DIR/all-patches/*.patch; do
  echo "==> Applying patch $i..."
  patch -Np1 < "$i"
done

echo "==> Setting config..."
cp `git -C "${SCRIPT_DIR}" rev-parse --show-toplevel`/config $SCRIPT_DIR/${KERNEL_DIR}/.config
make olddefconfig
#make mod2yesconfig # uncomment this line to convert everything that would've been built as a module to be built-in (not recommended because of bloat)

echo "Finished preparing. You may now run build.sh"
