#!/bin/sh
# netadmintools.com/part279

# Install dependencies
mingw-get install msys-wget

# Install grep
wget ftp.gnu.org/gnu/grep/grep-2.11.tar.xz
tar xf grep*
cd grep*

PATH=/mingw/bin:/bin
./configure
make CC='gcc -static'
