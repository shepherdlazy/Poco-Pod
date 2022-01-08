#!/usr/bin/env bash
####################################
# File: build-openssl.sh
# Author: Raven Du<Raven.Du@Gmail.com>
# Created Date: 2018-02-01 16:19:46 +0800
# Copyright (c) 2018 MyrSoft Studio.
# license: MIT License (http://www.opensource.org/licenses/MIT)
####################################

VERSION="1.0.2n"
SDKVERSION=`xcrun --sdk iphoneos --show-sdk-version 2> /dev/null`
MIN_SDK_VERSION_FLAG="-miphoneos-version-min=7.0"
BASEPATH=$(cd `dirname $0`; pwd)
BASEPATH="${BASEPATH}/openssl"
CURRENTPATH="${BASEPATH}/tmp/openssl"
ARCHS="x86_64 armv7 armv7s arm64"
DEVELOPER=`xcode-select -print-path`

mkdir -p "${CURRENTPATH}/bin"
cd "${CURRENTPATH}"

curl -o openssl-1.0.2n.tar.gz https://www.openssl.org/source/openssl-1.0.2n.tar.gz
tar -xzf openssl-1.0.2n.tar.gz
cd "openssl-${VERSION}"

for ARCH in ${ARCHS}
do
    CONFIGURE_FOR="iphoneos-cross"
    if [ "${ARCH}" == "i686" ] || [ "${ARCH}" == "i386" ] || [ "${ARCH}" == "x86_64" ] ;
    then
        PLATFORM="iPhoneSimulator"
        if [ "${ARCH}" == "x86_64" ] ;
        then
            CONFIGURE_FOR="darwin64-x86_64-cc"
        fi
    else
        sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c"
        PLATFORM="iPhoneOS"
    fi
    export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
    export CROSS_SDK="${PLATFORM}${SDKVERSION}.sdk"
    echo "Building openssl-${VERSION} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
    echo "Please stand by..."
    export CC="${DEVELOPER}/usr/bin/gcc -arch ${ARCH} ${MIN_SDK_VERSION_FLAG}"
    mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"
    LOG="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/build-openssl-${VERSION}.log"
    LIPO_LIBSSL="${LIPO_LIBSSL} ${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/lib/libssl.a"
    LIPO_LIBCRYPTO="${LIPO_LIBCRYPTO} ${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/lib/libcrypto.a"
    ./Configure ${CONFIGURE_FOR} --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" > "${LOG}" 2>&1
    sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} !" "Makefile"
    make >> "${LOG}" 2>&1
    make all install_sw >> "${LOG}" 2>&1
    make clean >> "${LOG}" 2>&1
done

echo "LIBSSL: ${LIPO_LIBSSL}"
echo "LIBCRYPTO: ${LIPO_LIBCRYPTO}"

echo "Build library..."
rm -rf "${BASEPATH}/lib/"
mkdir -p "${BASEPATH}/lib/"
lipo -create ${LIPO_LIBSSL}    -output "${BASEPATH}/lib/libssl.a"
lipo -create ${LIPO_LIBCRYPTO} -output "${BASEPATH}/lib/libcrypto.a"

echo "Copying headers..."
rm -rf "${BASEPATH}/opensslIncludes/"
mkdir -p "${BASEPATH}/opensslIncludes/"
cp -RL "${CURRENTPATH}/openssl-${VERSION}/include/openssl" "${BASEPATH}/opensslIncludes/"

cd "${BASEPATH}"
echo "Building done."

echo "Cleaning up..."
rm -rf "${CURRENTPATH}"

echo "Done."