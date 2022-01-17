# This file is for anyone who does not want to package up their kernel and just want to install it

#!/bin/bash

cd linux-kern
echo "==> Installing modules..."
make modules_install

echo "==> Installing Linux Kernel..."
make install
make clean

echo "Done installing the Linux Kernel."
