# baby cygwin

warn ()
{
  printf '\e[36m%s\e[m\n' "$*"
}

log ()
{
  unset PS4
  set $((set -x; : "$@") 2>&1)
  shift
  warn $*
  eval $*
}

set $PWD
mkdir baby-cygwin
cd baby-cygwin

# /
echo '@start bin\bash -l' > cygwin.bat
DATE=$(date)
CYGWIN_VERSION=$(uname -r | sed 's/(.*//')
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
  /bin/awk
  /bin/bash
  /bin/cp
  /bin/date
  /bin/diff
  /bin/dumper
  /bin/find
  /bin/gawk
  /bin/grep
  /bin/mkdir
  /bin/ls
  /bin/printf
  /bin/rm
  /bin/sed
  /bin/sleep
  /bin/sort
  /bin/stat
  /bin/tee
  /bin/tr
  /bin/uniq
  /bin/wget
  /bin/xargs
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
cd $1
log zip -9mqr baby-cygwin-${BABY_VERSION}.zip baby-cygwin
