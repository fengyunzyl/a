# must run a single time to avoid repeated downloading of setup.ini
setup-x86_64 -nq -P libxml2

setup-x86_64 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php,php-bcmath,php-curl,php-simplexml

# look for the script using PATH environment variable
cd /usr/local/bin
echo '/bin/php "$(type -p $1)" "${@:2}"' > php
chmod +x php
