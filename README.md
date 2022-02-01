# T2-Gentoo-Kernel

Linux Kernels for Gentoo customized to support T2 Macs

## Installing from CI packages

Download the files from the latest release. You should have two tar files called `linux-t2-[VERSION].tar.xz` and `linux-t2-src-[VERSION].tar.xz`.

Extract both tar archives and go into the build folder from those tar archives. \
Copy the files from the `boot` folder to `/boot`. \
Copy the files from the `lib/lib/modules` folder to `/lib`. \
Copy the files from the `usr` folder to `/usr`.

You can now delete the build folders and the tar archives.

## Building manually

Before we start, these scripts are intended to be run in a chroot environment where the user is signed in as root. If you cannot log in as root but you have access to sudo, then run the commands in `sudo -s` shell or use the prefix `sudo bash` before running each script.

If you want to build a kernel yourself, then git clone this repo somewhere on your Linux install.
Make sure you have these packages installed:

```text
bc kmod pahole cpio perl git curl
```

**MAKE SURE TO EMERGE `kmod` WITH THE `zstd` USE FLAG**

First make sure that you can run all of the programs by running `chmod +x prepare.sh build.sh install.sh package.sh`.

Now run `prepare.sh` and let the script run. If you stopped the script, then you'll have to delete all of the files the script made before and try again.

If you would like to configure the Linux kernel to your liking, then run the following commands:

```bash
cd linux-t2
make menuconfig
```

You're now ready to build the kernel. Run `build.sh` and let the script run. If you stopped the script, then you can run it again and it will continue where it left off.

If you would like to install the kernel, run `install.sh`. If you want to instead package up the kernel for someone else, then run `package.sh`.

If you installed the kernel instead of packaging it, then some programs you install might require the Linux Kernel source code. Run this to fix that issue:

```bash
cp linux-t2 /usr/src/linux-[INSERT KERNEL VERSION HERE]
eselect kernel list # you should see your kernel version pop up, note down the index number
eselect kernel set [INDEX]
```
