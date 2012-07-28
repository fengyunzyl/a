#!/bin/sh
# glob.com.au/sendmail

# Install dependencies
mingw-get install bsdtar
mingw-get install msys-wget

# Install sendmail
# /usr/lib/sendmail
# smtp_server=smtp.gmail.com
# auth_username=svnpenn
# git send-email *.patch

cd /lib
wget glob.com.au/sendmail/sendmail.zip
bsdtar -xf sendmail.zip
