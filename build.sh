#!/bin/bash

export NDK=/home/xueqi/Android/android-ndk-r22b
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

function build_android
{
    ./configure \
    --prefix=$PREFIX \
    --enable-neon  \
    --enable-hwaccels  \
    --enable-gpl   \
    --disable-debug \
    --enable-small \
    --enable-jni \
    --enable-mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-static \
    --enable-shared \
    --disable-doc \
    --enable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC \
    --cxx=$CXX \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS"

    make clean
    make -j16
    make install

    # ---> 添加成功/失败判断
    if [ $? -eq 0 ]; then
        echo "============================ build android $ARCH success =========================="
    else
        echo "============================ build android $ARCH FAILED =========================="
        exit 1
    fi
}

##############################################
# 1️⃣ arm64-v8a
##############################################
ARCH=arm64
CPU=armv8-a
API=21
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"

build_android


##############################################
# 2️⃣ armeabi-v7a（32 位）
##############################################
ARCH=arm
CPU=armv7-a
API=21
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"

build_android
