# baby cygwin
set $PWD
mkdir baby-cygwin
cd baby-cygwin

# /
echo '@start bin\bash -l' > cygwin.bat
DATE=$(date)
CYGWIN_VERSION=$(uname -r | grep -o '[.0-9]*')
u2d > README.txt <<q
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
q

# /dev
mkdir dev
cd dev
cp -r /dev/fd .
$WINDIR/system32/attrib -s
cd -

# /etc
mkdir etc
cd etc
cat > profile <<'q'
PATH=/bin:/usr/local/bin
PROMPT_COMMAND='history -a'
PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
[ -d dev/fd ] || $WINDIR/system32/attrib +s dev/fd
[ -d $HOME ] || mkdir -p $HOME
[ -a ~/.bash_history ] || echo %% > ~/.bash_history
cd
q
cd -

# /usr/bin
deps=(
  /bin/bash.exe
  /bin/cp.exe
  /bin/diff.exe
  /bin/dumper.exe
  /bin/find.exe
  /bin/grep.exe
  /bin/mkdir.exe
  /bin/ls.exe
  /bin/printf.exe
  /bin/rm.exe
  /bin/sed.exe
  /bin/sleep.exe
  /bin/sort.exe
  /bin/tee.exe
  /bin/tr.exe
  /bin/uniq.exe
  /bin/wget.exe
  /bin/xargs.exe
)
mkdir bin
cd bin
cp ${deps[*]} .
ldd ${deps[*]} |
  grep usr |
  sort -u |
  cut -d' ' -f3 |
  xargs cp -t .
cd -

# /usr/local/bin
mkdir -p usr/local/bin

# /usr/share/terminfo
mkdir -p usr/share
cd usr/share
cp -r /usr/share/terminfo .
cd -

# archive
cd ${0%/*}
BABY_VERSION=$(git log --follow --oneline $0 | wc -l)
cd $1
P7ZIP="${ProgramW6432}/7-zip/7z"
"$P7ZIP" a -mx=9 baby-cygwin-${BABY_VERSION}.zip baby-cygwin
rm -r baby-cygwin
