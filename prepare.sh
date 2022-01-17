# This file prepares for compiling the kernel.
# It first fetches the latest Linux Kernel (that is both supported by gentoo-sources and the t2-linux patches)
# Then downloads all patches needed and applies them.

#!/bin/bash

KERNEL_VERSION=5.16.1

echo "==> Downloading Linux Kernel version ${KERNEL_VERSION}..."
curl -o linux.tar.xz https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VERSION//.*}.x/linux-${KERNEL_VERSION}.tar.xz

echo "==> Unpacking Linux Kernel..."
tar xf linux.tar.xz
mv linux-${KERNEL_VERSION} linux-kern

echo "==> Grabbing patches..."
mkdir all-patches
git clone https://anongit.gentoo.org/git/proj/linux-patches.git gentoo-patches
mv gentoo-patches/*.patch all-patches/
rm -r gentoo-patches
git clone https://github.com/Redecorating/mbp-16.1-linux-wifi t2-patches
mv t2-patches/*.patch all-patches/
rm -r t2-patches

echo "==> Grabbing apple-bce and apple-ibridge..."
git clone https://github.com/t2linux/apple-bce-drv apple-bce
git clone https://github.com/t2linux/apple-ib-drv apple-ibridge
for i in apple-bce apple-ibridge; do
  echo "==> Copying $i to drivers/staging..."
  mkdir linux-kern/drivers/staging/$i
  cp -r $i/* linux-kern/drivers/staging/$i/
 done
 
echo "==> Applying patches..."
cd linux-kern
for i in all-patches/*.patch; do
  echo "==> Applying patch $i..."
  patch -Np1 < "../$i"
done

echo "==> Setting config..."
cp ../config .config
make olddefconfig

echo "Finished preparing. You may now run build.sh and package.sh."
