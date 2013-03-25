#!/bin/bash
mkdir baby-cygwin
cd baby-cygwin

# /
echo '@start bin\bash -l' > cygwin.bat
read DATE < <(date)
read CYGWIN_VERSION < <(uname -r | grep -o '[.0-9]*')
u2d > README.txt <<q
Baby Cygwin by Steven Penny

Steven’s Home Page: http://svnpenn.github.com

Today’s date $DATE

The build script for this build can be found at
  http://github.com/svnpenn/a/blob/master/baby-cygwin.sh

Included with this package
  Cygwin $CYGWIN_VERSION
  
OPERATING INSTRUCTIONS
  Put any scripts into /usr/local/bin
  Double click cygwin.bat
q

# /dev
set dev
mkdir -p $1
cd $1
cp -r /dev/fd .
$WINDIR/system32/attrib -s
cd -

# /etc
set etc
mkdir -p $1
cd $1
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
  /bin/sort.exe
  /bin/tee.exe
  /bin/sleep.exe
  /bin/rm.exe
  /bin/tr.exe
  /bin/uniq.exe
  /bin/wget.exe
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
set usr/share
mkdir -p $1
cd $1
cp -r /usr/share/terminfo .
cd -

# archive
cd ${0%/*}
read BABY_VERSION < <(git log --follow --oneline $0 | wc -l)
cd -
read aa < <(ls -C)
tar acf baby-cygwin-$BABY_VERSION.tar.gz $aa
rm -r $aa
