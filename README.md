# T2-Gentoo-Kernel

Linux Kernels for Gentoo customized to support T2 Macs

CI releases are coming soon, so keep a look out for that!

## Building manually

If you want to build a kernel yourself, then git clone this repo somewhere on your Linux install.
Make sure you have these packages installed (Gentoo should come with many development related packages in Stage 3 tarball):

```text
bc kmod libelf pahole cpio perl tar xz git curl
```

Then, run `prepare.sh`, `build.sh`, optionally `package.sh`, and `install.sh`.
