# test baby cygwin

usage ()
{
  echo usage: $0 VERSION
  exit
}

[ $1 ] || usage
wget strm.googlecode.com/files/baby-cygwin-$1.tar.gz
tar xf baby-cygwin-$1.tar.gz
cd baby-cygwin/usr/local/bin
find /opt/a -maxdepth 1 -type f -exec cp -t. {} +
echo 'baby cygwin ready.'
