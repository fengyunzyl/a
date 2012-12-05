#!/bin/sh
# http://developer.github.com/v3/repos/downloads

# Get downloads
curl -k https://api.github.com/repos/svnpenn/etc/downloads

# Delete download
curl -X DELETE -u svnpenn -k \
  https://api.github.com/repos/svnpenn/etc/downloads/379687

# Create new download
curl -X POST -u svnpenn -k \
  -d '{"name":"tcl-8.5.13.tar.gz","size":130073}' \
  https://api.github.com/repos/svnpenn/etc/downloads

# POST to s3
curl -k \
-F "key=downloads/svnpenn/etc/tcl-8.5.13.tar.gz" \
-F "acl=public-read" \
-F "success_action_status=201" \
-F "Filename=tcl-8.5.13.tar.gz" \
-F "AWSAccessKeyId=AKIAI..." \
-F "Policy=ewogICA..." \
-F "Signature=kgI+Qun..." \
-F "Content-Type=application/gzip" \
-F "file=@tcl-8.5.13.tar.gz" \
https://github.s3.amazonaws.com/
