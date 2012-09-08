#!/bin/sh

# Set ~/.gitconfig
git config --global sendemail.smtpencryption tls
git config --global sendemail.smtpserver smtp.gmail.com
git config --global sendemail.smtpuser svnpenn@gmail.com

# Install Perl modules. Packages gcc4 git make openssl-devel
# must be installed or cpan will fail.
cpan Authen::SASL # auth
cpan Net::SMTP::SSL

# Test
git send-email --to rtmpdump@mplayerhq.hu *.patch
