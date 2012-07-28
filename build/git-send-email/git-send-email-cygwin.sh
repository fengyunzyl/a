#!/bin/sh
# schacon.github.com/git/git-send-email

# Install Cygwin packages
./setup -nqs ftp://lug.mtu.edu/cygwin -P gcc4,git,make,openssl-devel,zlib

# Install Perl modules
cpan Authen::SASL
cpan MIME::Base64
cpan Net::SMTP::SSL

# Set ~/.gitconfig
git config --global sendemail.smtpencryption tls
git config --global sendemail.smtpserver smtp.gmail.com
git config --global sendemail.smtpuser svnpenn@gmail.com

# Test
git send-email --to rtmpdump@mplayerhq.hu *.patch

# Alpine
# Personal Name, Steven Penny
# Email Address, svnpenn@gmail.com
# Mail Server, imap.gmail.com/ssl
# Login name, svnpenn@gmail.com
