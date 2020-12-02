#! /usr/bin/env bash

#----------
# modify for your build tool

FF_ALL_ARCHS="x86_64"

#----------
UNI_BUILD_ROOT=`pwd`
UNI_TMP="$UNI_BUILD_ROOT/tmp"
UNI_TMP_LLVM_VER_FILE="$UNI_TMP/llvm.ver.txt"
FF_TARGET=$1
FF_TARGET_EXTRA=$2
set -e

#----------
echo_archs() {
    echo "===================="
    echo "[*] check xcode version"
    echo "===================="
    echo "FF_ALL_ARCHS = $FF_ALL_ARCHS"
}

FF_LIBS="libcompat libavcodec libavfilter libavformat libavutil libswscale libswresample"



#----------
if [ "$FF_TARGET" = "x86_64" ]; then
    echo_archs
    sh tools/do-compile-ffmpeg.sh $FF_TARGET $FF_TARGET_EXTRA
elif [ "$FF_TARGET" = "all" ]; then
    echo_archs
    for ARCH in $FF_ALL_ARCHS
    do
        sh tools/do-compile-ffmpeg.sh $ARCH $FF_TARGET_EXTRA
    done
elif [ "$FF_TARGET" = "check" ]; then
    echo_archs
elif [ "$FF_TARGET" = "clean" ]; then
    echo_archs
    echo "=================="
    for ARCH in $FF_ALL_ARCHS
    do
        echo "clean ffmpeg-$ARCH"
        echo "=================="
        cd contrib/ffmpeg-$ARCH && git clean -xdf && cd -
    done
    echo "clean build cache"
    echo "================="
    rm -rf contrib/build/ffmpeg-*
    rm -rf contrib/build/openssl-*
    rm -rf contrib/build/universal/include
    rm -rf contrib/build/universal/lib
    echo "clean success"
else
    echo "Usage:"
    echo "  compile-ffmpeg.sh x86_64"
    echo "  compile-ffmpeg.sh all"
    echo "  compile-ffmpeg.sh clean"
    echo "  compile-ffmpeg.sh check"
    exit 1
fi
