# install PHP

# libxml2
setup-x86 -nq -P libxml2

# php
setup-x86 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php

# php-bcmath
setup-x86 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php-bcmath

# php-curl
setup-x86 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php-curl

# php-simplexml
setup-x86 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php-simplexml

# look for the script using PATH environment variable
cd /bin
mv php php5
cd /usr/local/bin
cat > php <<'EOF'
read < <(command -v $1) && shift
php5 $REPLY $*
EOF
