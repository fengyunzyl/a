# must run a single time to avoid repeated downloading of setup.ini
setup-x86 -nq -P libxml2

setup-x86 -nq -K http://cygwinports.org/ports.gpg \
  -s http://mirrors.kernel.org/sources.redhat.com/cygwinports \
  -P php,php-bcmath,php-curl,php-simplexml

# look for the script using PATH environment variable
cd /bin
mv php php5
cd /usr/local/bin
cat > php <<'EOF'
php5 "$(type -p $1)" "${@:2}"
EOF
