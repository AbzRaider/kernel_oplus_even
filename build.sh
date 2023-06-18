#!/bin/bash

function compile() 
{
rm -rf AnyKernel
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=MARK•DEVS
export KBUILD_BUILD_USER="AbzRaider"
git clone --depth=1  https://github.com/rama982/clang  clang 
 if ! [ -d "out" ]; then
echo "Kernel OUT Directory Not Found . Making Again"
mkdir out
fi

make O=out ARCH=arm64 even_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
 make -j "$(nproc --all)" O="out" CC="clang" \
    LD=ld.lld AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip \
    CROSS_COMPILE="aarch64-linux-gnu-" \
CROSS_COMPILE_ARM32="${PWD}/clang/bin/arm-linux-gnueabi-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee error.log 
}


function zupload()
{
git clone --depth=1 https://github.com/AbzRaider/AnyKernel_RMX2001 -b RMX2151 AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 AbzRaiderXD-OSS-RUI3-KERNEL-EVEN.zip *
curl --upload-file "AbzRaiderXD-OSS-RUI3-KERNEL-EVEN.zip" https://free.keep.sh
}

compile
zupload
