#!/bin/bash
set -eu

SYSTEM2_DIR="$(pwd)"
BUILD_DIR="$SYSTEM2_DIR/build-linux"
SMBRANCH=1.11-dev

if [[ ! -d "$BUILD_DIR" ]]; then
	mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR" || exit

# OpenSSL
echo "Building openssl"
if [[ ! -f "openssl-1.1.1k.tar.gz" ]]; then
	wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz && tar -xzf openssl-1.1.1k.tar.gz
fi

cd openssl-1.1.1k
setarch x86_64 ./config -m64 -fPIC no-shared no-tests && make -j16
mkdir lib && cp ./*.a lib/
cd "$BUILD_DIR" || exit

# Zlib
echo "Building zlib"
if [[ ! -f "zlib-1.3.1.tar.gz" ]]; then
	wget https://zlib.net/zlib-1.3.1.tar.gz && tar -xzf zlib-1.3.1.tar.gz
fi

cd zlib-1.3.1
CFLAGS="-m64 -fPIC" ./configure -static && make -j16
mkdir include && mkdir lib && cp ./*.h include/ && cp libz.a lib
cd "$BUILD_DIR" || exit

# Libidn
echo "Building libidn"
if [[ ! -f "libidn2-2.2.0.tar.gz" ]]; then
	wget https://ftp.gnu.org/gnu/libidn/libidn2-2.2.0.tar.gz && tar -xzf libidn2-2.2.0.tar.gz
fi

cd libidn2-2.2.0
CFLAGS="-m64 -fPIC" ./configure --disable-shared --enable-static --disable-doc && make -j16 
mkdir include && cp lib/*.h include/ && cp lib/.libs/libidn2.a lib
cd "$BUILD_DIR" || exit

# LibCurl
echo "Building libcurl"
if [[ ! -f "curl-7.76.0.zip" ]]; then
	wget https://curl.se/download/curl-7.76.0.zip && unzip -q curl-7.76.0.zip
fi

cd curl-7.76.0
sed -i 's/curl -w/curl -L -w/g' lib/mk-ca-bundle.pl
./configure --with-ssl="$BUILD_DIR/openssl-1.1.1k" --with-zlib="$BUILD_DIR/zlib-1.3.1" \
 --with-libidn2="$BUILD_DIR/libidn2-2.2.0" --disable-shared --enable-static --disable-rtsp \
 --disable-ldap --disable-ldaps --disable-manual --disable-libcurl-option --without-librtmp \
 --without-libssh2 --without-nghttp2 --without-gssapi --host=x86_64-pc-linux-gnu CFLAGS=-m64 && make all ca-bundle -j16 CFLAGS='-fPIC'
cd "$BUILD_DIR" || exit

# SourceMod
echo "Getting sourcemod"
if [[ ! -d "sourcemod-${SMBRANCH}" ]]; then
	git clone https://github.com/alliedmodders/sourcemod --recursive --branch "$SMBRANCH" --single-branch "sourcemod-${SMBRANCH}" --depth 1 --shallow-submodules
fi


echo "Building system2"
cd "$SYSTEM2_DIR" || exit
make SMSDK="$BUILD_DIR/sourcemod-${SMBRANCH}" OPENSSL="$BUILD_DIR/openssl-1.1.1k" ZLIB="$BUILD_DIR/zlib-1.3.1" IDN="$BUILD_DIR/libidn2-2.2.0" CURL="$BUILD_DIR/curl-7.76.0" -j16 CFLAGS='-fPIC'
