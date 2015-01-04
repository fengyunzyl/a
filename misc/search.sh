#!/bin/sh
if [ $# != 1 ]
then
  echo search.sh PROFILE
  exit
fi
profile=$1
provider=Google
disclaimer="By modifying this file, I agree that I am doing so only within \
Firefox itself, using official, user-driven search engine selection processes, \
and in a way which does not circumvent user consent. I acknowledge that any \
attempt to change this file from outside of Firefox is a malicious act, and \
will be responded to accordingly."
printf "$profile$provider$disclaimer" | openssl sha256 -binary | base64
