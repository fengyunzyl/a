# install PHP
setup-x86 -nqP libpcre1
wget downloads.sf.net/cygwin-ports/setup.bz2
bunzip2 setup.bz2
set $(awk '/@ php/ {f = 1} f && /version/ {print; exit}' setup)

# php
wget downloads.sf.net/cygwin-ports/php-$2.tar.bz2
tar xf php-$2.tar.bz2 -C/

# php-bcmath
wget downloads.sf.net/cygwin-ports/php-bcmath-$2.tar.bz2
tar xf php-bcmath-$2.tar.bz2 -C/

# php-curl
wget downloads.sf.net/cygwin-ports/php-curl-$2.tar.bz2
tar xf php-curl-$2.tar.bz2 -C/

# php-simplexml
wget downloads.sf.net/cygwin-ports/php-simplexml-$2.tar.bz2
tar xf php-simplexml-$2.tar.bz2 -C/

# look for the script using PATH environment variable
cd /bin
mv php php5
cd /usr/local/bin
cat > php <<'EOF'
read < <(command -v $1) && shift
php5 $REPLY $*
EOF
