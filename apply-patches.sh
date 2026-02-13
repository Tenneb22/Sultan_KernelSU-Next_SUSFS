#!/bin/bash

set -e

#env:
#           #CODENAME: "shiba"
# KERNEL_REPO: "android_kernel_google_tensynos"
# ANDROID_VERSION: "android14" # the kernel android version from lmk or so idk
# KERNEL_VERSION: "6.1"
#           # ROOT: ${{ github.workspace }} $GITHUB_WORKSPACE already exists and is the default working directory.
# SUSFS_BRANCH: "sultan-shiba-susfs-minimal"
# ANYKERNEL_BRANCH: "sultan-zuma" # For the AnyKernel Repo from WildKernels

echo "Applying Patches..."

# ------------------------------
# Base off from https://gitlab.com/simonpunk/susfs4ksu/-/blob/sultan-shiba-susfs-minimal/README.md?ref_type=heads
#echo "Applying SUSFS Patches..."

# -------
cd "$GITHUB_WORKSPACE"/susfs4ksu/

cp ./kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch "$GITHUB_WORKSPACE/$KERNEL_REPO"/KernelSU-Next/
#cp ./kernel_patches/50_add_susfs_in_kernel-${KERNEL_VERSION}.patch $KERNEL_REPO/ # wrong path?
cp ./kernel_patches/50_add_susfs_in_gki-"${ANDROID_VERSION}"-"${KERNEL_VERSION}".patch "$GITHUB_WORKSPACE"/"$KERNEL_REPO"/
cp -r ./kernel_patches/fs/* "$GITHUB_WORKSPACE/$KERNEL_REPO"/fs/
cp -r ./kernel_patches/include/linux/* "$GITHUB_WORKSPACE/$KERNEL_REPO"/include/linux/

# -------
cd "$GITHUB_WORKSPACE/$KERNEL_REPO/KernelSU-Next"
patch -p1 < 10_enable_susfs_for_ksu.patch

cd "$GITHUB_WORKSPACE/$KERNEL_REPO"
#patch -p1 < 50_add_susfs_in_kernel.patch
patch -p1 < 50_add_susfs_in_gki-"${ANDROID_VERSION}"-"${KERNEL_VERSION}".patch


# Patches from WildKernels/kernel_patches
# ------------------------------

#echo "Applying Common Patches..."
#
#cd "$GITHUB_WORKSPACE/kernel_patches"
#cp "./common/*.patch" "$KERNEL_REPO/"
#
#cd "$KERNEL_REPO"
#for patch in *.patch; do
#    echo "Applying $patch..."
#    patch -p1 < "$patch"
#done


# ------------------------------

#echo "Applying KernelSU Next Patches..."



# ------------------------------

echo "Applying Sultan Kernel Patches..."

cd "$GITHUB_WORKSPACE/kernel_patches"
cp "./sultan/sys.c_fix.patch" "$GITHUB_WORKSPACE/$KERNEL_REPO/"

cd "$GITHUB_WORKSPACE/$KERNEL_REPO"
patch -p1 < sys.c_fix.patch
