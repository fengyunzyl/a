function new {
  set "$pn/baby-cygwin/$1"
  mkdir -p "$1"
  cd "$1"
}
pn=~+
new

# /
echo 'bin/bash -l' > cygwin.ps1
chmod +x cygwin.ps1
DATE=$(date)
CYGWIN_VERSION=$(uname -r | cut -d'(' -f1)
sed 's/$/\r/' > README.txt <<+
Baby Cygwin by Steven Penny

Steven’s Home Page: http://svnpenn.github.io

Today’s date $DATE

The build script for this build can be found at
  http://github.com/svnpenn/a

Included with this package
  Cygwin $CYGWIN_VERSION

OPERATING INSTRUCTIONS
  Put any scripts into /usr/local/bin
  Right click cygwin.ps1
+

# /dev
new dev

# /etc
new etc
cat > profile <<'+'
PATH=/usr/bin:/usr/local/bin:$PATH
PS1='\e];\a\n\e[33m\w\n\e[m$ '
[ -d ~ ] || mkdir -p ~
[ -a ~/.bash_history ] || echo cd > ~/.bash_history
[ -a /bin/awk ] || ln -s /bin/gawk /bin/awk
[ -a /dev/fd ] || ln -s /proc/self/fd /dev/fd
cd
+

# /usr/bin
deps=(
  /bin/bash     /bin/cat     /bin/chmod /bin/cp     /bin/cut   /bin/date
  /bin/diff     /bin/dirname /bin/du    /bin/dumper /bin/expr  /bin/file
  /bin/find     /bin/gawk    /bin/grep  /bin/ln     /bin/ls    /bin/mkdir
  /bin/mkpasswd /bin/mount   /bin/mv    /bin/printf /bin/ps    /bin/rm
  /bin/rmdir    /bin/sed     /bin/sh    /bin/sleep  /bin/sort  /bin/stat
  /bin/tee      /bin/tr      /bin/uname /bin/uniq   /bin/wget  /bin/xargs
)
new bin
cp ${deps[*]} .
ldd ${deps[*]} | awk '/usr/ && ! aa[$0]++ {print $3}' | xargs cp -t.

# /usr/local/bin
new usr/local/bin

# /usr/share/terminfo
new usr/share
cp -r /usr/share/terminfo .

# archive
gt=$(dirname "$0")
cd "$gt"
BABY_VERSION=$(git log --follow --oneline "$0" | wc -l)
new
7za a baby-cygwin-${BABY_VERSION}.zip *
