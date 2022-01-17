# This file actually compiles the Linux Kernel

#!/bin/bash

NUM_JOBS=`nproc`

echo "==> Using all available cores to compile the Linux Kernel. If you want to use less, then edit this build.sh file."

echo "==> Building the Linux Kernel..."
cd linux-kern
make all -j${NUM_JOBS}

echo "==> Done. Now run package.sh and extract the archives to the according location."
