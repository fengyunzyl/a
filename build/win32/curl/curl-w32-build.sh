#!/bin/sh
# Instructions to install dependencies

# Install Curl
wget curl.haxx.se/download/curl-7.24.0.tar.lzma
tar xf curl-7.24.0.tar.lzma
cd curl-7.24.0
mingw32-make mingw32
cp -r include /mingw
cp -r lib /mingw
