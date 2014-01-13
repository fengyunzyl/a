# baby cygwin

warn () {
  printf '\e[36m%s\e[m\n' "$*"
}

log () {
  unset PS4
  qq=$(( set -x
         : "$@" )2>&1)
  warn "${qq:2}"
  eval "${qq:2}"
}

set "$PWD"
mkdir baby-cygwin
cd baby-cygwin

# /
echo '@start bin\bash -l' > cygwin.bat
chmod +x cygwin.bat
DATE=$(date)
CYGWIN_VERSION=$(uname -r | sed 's/(.*//')
u2d > README.txt <<bb
Baby Cygwin by Steven Penny

Steven’s Home Page: http://svnpenn.github.io

Today’s date $DATE

The build script for this build can be found at
  http://github.com/svnpenn/a

Included with this package
  Cygwin $CYGWIN_VERSION

OPERATING INSTRUCTIONS
  Put any scripts into /usr/local/bin
  Double click cygwin.bat
bb

# /dev
mkdir dev

# /etc
mkdir etc
cd etc
cat > profile <<'bb'
PATH=/usr/bin:/usr/local/bin:$PATH
PS1='\e];\a\n\e[33m\w\n\e[m$ '
if ! [ -a /etc/passwd ]
then
  mkpasswd > /etc/passwd
  cmd /c start bash -l
  kill -7 $$
fi
[ -d ~ ] || mkdir -p ~
[ -a ~/.bash_history ] || echo cd > ~/.bash_history
[ -a /bin/awk ] || ln -s /bin/gawk /bin/awk
[ -a /dev/fd ] || ln -s /proc/self/fd /dev/fd
cd
bb
cd -

# /usr/bin
deps=(
  /bin/bash  /bin/cat     /bin/chmod  /bin/cp     /bin/cut   /bin/date
  /bin/diff  /bin/dirname /bin/du     /bin/dumper /bin/expr  /bin/find
  /bin/gawk  /bin/grep    /bin/ln     /bin/ls     /bin/mkdir /bin/mkpasswd
  /bin/mount /bin/mv      /bin/printf /bin/ps     /bin/rm    /bin/rmdir
  /bin/sed   /bin/sh      /bin/sleep  /bin/sort   /bin/stat  /bin/tee
  /bin/tr    /bin/uname   /bin/uniq   /bin/wget   /bin/xargs
)
mkdir bin
cd bin
cp ${deps[*]} .
ldd ${deps[*]} | awk '/usr/ && ! aa[$0]++ {print $3}' | xargs cp -t.
cd -

# /usr/local/bin
mkdir -p usr/local/bin

# /usr/share/terminfo
mkdir -p usr/share
cd usr/share
cp -r /usr/share/terminfo .

# archive
cd ${0%/*}
BABY_VERSION=$(git log --follow --oneline $0 | wc -l)
cd "$1"
log zip -9mqr baby-cygwin-${BABY_VERSION}.zip baby-cygwin
