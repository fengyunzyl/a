#!/bin/sh
# Install OpenSSH to /usr/local

# Install
mingw-get install msys-openssh

# Copy files
cd /bin

cp msys-crypto* /usr/local/bin
cp msys-minires* /usr/local/bin
cp ssh.exe /usr/local/bin
