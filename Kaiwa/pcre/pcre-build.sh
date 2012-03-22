#!/bin/bash
OPATH=$PATH

TARGET=pcre-8.12
SDK_VERSION=4.3

CONFIG="--disable-shared --enable-utf8"

# This script will compile a PCRE static lib for the device and simulator

build_pcre() {

    LIBNAME=$1
    PLATFORM=$2
	ARCH=$3
	
    DISTDIR=`pwd`/dist-$LIBNAME-$ARCH

    echo "Building binary for iPhone $LIBNAME $ARCH $PLATFORM to $DISTDIR"

    echo Removing ${TARGET}
    /bin/rm -rf ${TARGET}
    echo Extracting ${TARGET}
    tar zxf ${TARGET}.tar.gz

	case $ARCH in
		armv6)  HOST="--host=arm-apple-darwin";;
		armv7)  HOST="--host=arm-apple-darwin";;
		*)       HOST="";;
	esac
	

#    case $LIBNAME in
#	device)  ARCH="armv7"; HOST="--host=arm-apple-darwin";;
#	*)       ARCH="i386"; HOST="";;
#    esac

# Compile a version for the device...

    cd ${TARGET}

    SDKPATH="/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDK_VERSION}.sdk"

    PATH=/Developer/Platforms/${PLATFORM}.platform/Developer/usr/bin:$OPATH
    export PATH

    case $LIBNAME in
	simulator)
	    ln -s ${SDKPATH}/usr/lib/crt1.10.5.o crt1.10.6.o;
	    ;;
    esac

    ./configure ${CONFIG} ${HOST} \
	CFLAGS="-arch ${ARCH} -isysroot ${SDKPATH}" \
	CXXFLAGS="-arch ${ARCH} -isysroot ${SDKPATH}" \
	LDFLAGS="-L." \
	CC="/Developer/Platforms/${PLATFORM}.platform/Developer/usr/bin/gcc" \
	CXX="/Developer/Platforms/${PLATFORM}.platform/Developer/usr/bin/g++"

    # Eliminate test unit entry 
    perl -pi.bak \
	    -e 'if (/^all-am:/) { s/\$\(PROGRAMS\) //; }' \
            Makefile

    make

	##read -p "Continue ..."

	echo "DESTINATION DIR: $DISTDIR"
    mkdir ${DISTDIR}
    mkdir ${DISTDIR}/lib
    mkdir ${DISTDIR}/include

    cp -p .libs/libpcre.a ${DISTDIR}/lib
    cp -p .libs/libpcrecpp.a ${DISTDIR}/lib
    cp -p .libs/libpcreposix.a ${DISTDIR}/lib
    cp -p pcre*h ${DISTDIR}/include

    cd ..

    echo Clean-up ${TARGET}
   ## /bin/rm -rf ${TARGET}
}



build_pcre "device" "iPhoneOS" "armv6" "--host=arm-apple-darwin"
build_pcre "device" "iPhoneOS" "armv7" "--host=arm-apple-darwin"
build_pcre "simulator" "iPhoneSimulator" "i386" ""

### Then, combine them into one..

echo "Creating combined binary into directory 'dist'"

/bin/rm -rf dist
mkdir dist
(cd dist-device; tar cf - . ) | (cd dist; tar xf -)

for i in pcre pcrecpp pcreposix
do
    lipo -create dist-device-armv7/lib/lib$i.a dist-device-armv6/lib/lib$i.a dist-simulator-i386/lib/lib$i.a \
	-o dist/lib/lib$i.a
done

##/bin/rm -rf dist-simulator dist-device

echo "Now package is ready in 'dist' directory'"

