#!/usr/bin/env bash
####################################
# File: build.sh
# Author: Raven Du<Raven.Du@Gmail.com>
# Created Date: 2018-01-31 20:14:16 +0800
# Copyright (c) 2018 MyrSoft Studio.
# license: MIT License (http://www.opensource.org/licenses/MIT)
####################################

# minial standard full
EDITION="standard"
VERSION="1.11.1"
SDKVERSION=`xcrun --sdk iphoneos --show-sdk-version 2> /dev/null`
MIN_SDK_VERSION_FLAG="-miphoneos-version-min=7.0"
BASEPATH=$(cd `dirname $0`; pwd)
CURRENTPATH="${BASEPATH}/tmp/poco"
ARCHS="x86_64 armv7 armv7s arm64"
LIBS="Foundation JSON Net Util XML"
DEVELOPER=`xcode-select -print-path`
# DEBUG="false"

if [ ${EDITION} == "minimal" ] ; then
  OPMITPARAM="--omit=Data/PostgreSQL,Data/ODBC,Data/MySQL,MongoDB,PDF,CppParser,Redis,Crypto"
  LIBS="Foundation JSON Net Util XML"
elif [ ${EDITION} == "standard" ] ; then
  OPMITPARAM="--omit=Data/PostgreSQL,Data/ODBC,Data/MySQL,MongoDB,PDF,CppParser,Redis"
  LIBS="Foundation JSON Net Util XML Crypto Data NetSSL Zip DataSQLite"
# elif [ ${EDITION} == "standard" ] ; then
#   LIBS="Foundation JSON Net Util XML Crypto Data NetSSL Redis Zip DataSQLite"
#   OPMITPARAM="--omit=Data/PostgreSQL,Data/ODBC,Data/MySQL,MongoDB,PDF,CppParser,Redis"
fi


mkdir -p "${CURRENTPATH}"
mkdir -p "${CURRENTPATH}/opt"


if [ -z "$POCO_FOLDER" ]
then
  if [ ! -f "archive/poco/${VERSION}/poco-${VERSION}-all.tar.gz" ]; then
    mkdir -p "archive/poco/${VERSION}/"
    curl https://pocoproject.org/releases/poco-${VERSION}/poco-${VERSION}-all.tar.gz --outpu archive/poco/${VERSION}/poco-${VERSION}-all.tar.gz
  fi

  tar -xzf "archive/poco/${VERSION}/poco-${VERSION}-all.tar.gz" -C "${CURRENTPATH}"
  cd "${CURRENTPATH}/poco-${VERSION}-all"
else
  cd "${POCO_FOLDER}"
fi

cp -RL LICENSE ${BASEPATH}/${EDITION}/LICENSE
cp -RL README ${BASEPATH}/${EDITION}/README

for ARCH in ${ARCHS}
do
    if [ "${ARCH}" == "i386" ] || [ "${ARCH}" == "i686" ] || [ "${ARCH}" == "x86_64" ] ;
    then
      PLATFORM="iPhoneSimulator"
      OSFLAGS="OSFLAGS = -arch \$(POCO_TARGET_OSARCH) -isysroot \$(IPHONE_SDK_BASE) -miphoneos-version-min=\$(IPHONE_SDK_VERSION_MIN)"
    else
      PLATFORM="iPhoneOS"
      OSFLAGS="OSFLAGS = -arch \$(POCO_TARGET_OSARCH) -isysroot \$(IPHONE_SDK_BASE) \$(THUMB) -miphoneos-version-min=\$(IPHONE_SDK_VERSION_MIN)"
    fi

    echo "Building POCO-${VERSION}-${EDITION} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
    echo "Please stand by..."

    BUILDCFG="build/config/${PLATFORM}-${ARCH}"
    echo "IPHONE_SDK_VERSION_MIN = 7.0" > ${BUILDCFG}
    echo "POCO_TARGET_OSARCH = ${ARCH}" >> ${BUILDCFG}
    echo "IPHONE_SDK         = ${PLATFORM}" >> ${BUILDCFG}
    echo "${OSFLAGS}" >> ${BUILDCFG}
    echo "" >> ${BUILDCFG}
    echo "include \$(POCO_BASE)/build/config/iPhone" >> ${BUILDCFG}

    mkdir -p "${CURRENTPATH}/opt/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"
    LOG="${CURRENTPATH}/opt/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/build-POCO-${VERSION}.log"

    echo "./configure --prefix=${CURRENTPATH}/opt/${PLATFORM}${SDKVERSION}-${ARCH}.sdk --config=${PLATFORM}-${ARCH} ${OPMITPARAM} --no-tests --no-samples --include-path=${BASEPATH}/openssl/opensslIncludes --library-path=${BASEPATH}/openssl/lib --static"
    ./configure --prefix=${CURRENTPATH}/opt/${PLATFORM}${SDKVERSION}-${ARCH}.sdk --config=${PLATFORM}-${ARCH} ${OPMITPARAM} --no-tests --no-samples --include-path=${BASEPATH}/openssl/opensslIncludes --library-path=${BASEPATH}/openssl/lib --static >> "${LOG}" 2>&1
    
    echo "Building..."
    make -s -j4 >> "${LOG}" 2>&1
    make install >> "${LOG}" 2>&1
done

echo "Build library..."
rm -rf "${BASEPATH}/${EDITION}/lib/"
mkdir -p "${BASEPATH}/${EDITION}/lib/"
# mkdir -p "${BASEPATH}/lib/debug"
for LIB in ${LIBS}
do
  LIPO_LIB=""
  # LIPO_LIBD=""
  for ARCH in ${ARCHS}
  do
    if [ "${ARCH}" == "i386" ] || [ "${ARCH}" == "i686" ] || [ "${ARCH}" == "x86_64" ] ;
    then
      LIPO_LIB="${LIPO_LIB} ${CURRENTPATH}/opt/iPhoneSimulator${SDKVERSION}-${ARCH}.sdk/lib/libPoco${LIB}.a"
      # LIPO_LIBD="${LIPO_LIBD} ${CURRENTPATH}/opt/iPhoneSimulator${SDKVERSION}-${ARCH}.sdk/lib/libPoco${LIB}d.a"
    else
      LIPO_LIB="${LIPO_LIB} ${CURRENTPATH}/opt/iPhoneOS${SDKVERSION}-${ARCH}.sdk/lib/libPoco${LIB}.a"
      # LIPO_LIBD="${LIPO_LIBD} ${CURRENTPATH}/opt/iPhoneOS${SDKVERSION}-${ARCH}.sdk/lib/libPoco${LIB}d.a"
    fi
  done
  lipo -create ${LIPO_LIB} -output "${BASEPATH}/${EDITION}/lib/libPoco${LIB}.a"
  # if [ ${DEBUG} == "true" ] ;
  # then
  #   lipo -create ${LIPO_LIBD} -output "${BASEPATH}/lib/debug/libPoco${LIB}d.a"
  # fi
done

echo "Copying headers..."
rm -rf "${BASEPATH}/${EDITION}/PocoIncludes/"
mkdir -p "${BASEPATH}/${EDITION}/PocoIncludes/"
cp -RL "${CURRENTPATH}/opt/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/include/Poco" "${BASEPATH}/${EDITION}/PocoIncludes/"

echo "Building done."

cd "${BASEPATH}/${EDITION}"
rm -rf poco-${VERSION}-${EDITION}-sdk${SDKVERSION}.tar.gz
tar czf poco-${VERSION}-${EDITION}-sdk${SDKVERSION}.tar.gz PocoIncludes lib LICENSE README

cd "${BASEPATH}"
if [ ! -f "archive/poco/${VERSION}/poco-${VERSION}-all.tar.gz" ]; then
  mkdir -p archive/poco/${VERSION}
  mv ${EDITION}/poco-${VERSION}-${EDITION}-sdk${SDKVERSION}.tar.gz archive/poco/${VERSION}
  shasum -a 256 archive/poco/${VERSION}/poco* > archive/poco/${VERSION}/sha256sum.txt
  echo "Compress archive done."
else
  echo "warning: The file archive/poco/${VERSION}/poco-${VERSION}-all.tar.gz already exists."
  echo "Please move the file manually "
fi

echo "Cleaning up..."
rm -rf "${CURRENTPATH}"
rm -rf "${EDITION}/LICENSE"
rm -rf "${EDITION}/README"
rm -rf "${EDITION}/PocoIncludes"
rm -rf "${EDITION}/lib"
echo "Done."