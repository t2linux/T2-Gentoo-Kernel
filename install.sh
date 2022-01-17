#!/usr/bin/env bash

set -euo pipefail

# This file is for anyone who does not want to package up their kernel and just want to install it

SCRIPT_DIR = "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

cd $SCRIPT_DIR/linux-kern
echo "==> Installing modules..."
make modules_install

echo "==> Installing Linux Kernel..."
make install
make clean

echo "Done installing the Linux Kernel."
