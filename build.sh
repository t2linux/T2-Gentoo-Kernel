#!/usr/bin/env bash

set -euo pipefail

# This file actually compiles the Linux Kernel

source INFO

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
NUM_JOBS=`nproc`

echo "==> Using all available cores to compile the Linux Kernel. If you want to use less, then edit this build.sh file."

echo "==> Building the Linux Kernel..."
cd $SCRIPT_DIR/${KERNEL_DIR}
make all -j${NUM_JOBS}

echo "==> Done."
