# install PHP
setup -nqP libpcre1

# php
wget downloads.sf.net/cygwin-ports/php-5.4.11-1.tar.bz2
tar xf php-5.4.11-1.tar.bz2 -C/

# php-bcmath
wget downloads.sf.net/cygwin-ports/php-bcmath-5.4.11-1.tar.bz2
tar xf php-bcmath-5.4.11-1.tar.bz2 -C/

# php-curl
wget downloads.sf.net/cygwin-ports/php-curl-5.4.11-1.tar.bz2
tar xf php-curl-5.4.11-1.tar.bz2 -C/

# php-simplexml
wget downloads.sf.net/cygwin-ports/php-simplexml-5.4.11-1.tar.bz2
tar xf php-simplexml-5.4.11-1.tar.bz2 -C/

# look for the script using PATH environment variable
cd /bin
mv php php5
cd /usr/local/bin
cat > php <<'EOF'
read < <(command -v $1) && shift
php5 $REPLY $*
EOF
