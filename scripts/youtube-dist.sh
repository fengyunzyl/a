#!/bin/bash

# /
echo '@start bin\bash -l' > cygwin.bat
read DATE < <(date)
read CYGWIN_VERSION < <(uname -r | grep -o '[.0-9]*')
cat > README.txt <<q
youtube.sh by Steven Penny

Steven’s Home Page: http://svnpenn.github.com

Today’s date $DATE

The source code for this script can be found at
  http://github.com/svnpenn/a

Included with this package
  youtube.sh
  Cygwin $CYGWIN_VERSION
  
OPERATING INSTRUCTIONS
  Double click cygwin.bat
  Input youtube.sh
  Follow instructions after that
q
u2d README.txt

# /etc
set etc
mkdir -p $1
cd $1
echo '
PATH=/bin:/usr/local/bin

if ! [ -d $HOME ]
then
  mkdir -p $HOME
  echo %% > ~/.bash_history
fi

export PROMPT_COMMAND="history -a"
cd
' > profile
cd -

# /usr/bin
deps=(
  /dev/fd
  /bin/bash.exe
  /bin/grep.exe
  /bin/mkdir.exe
  /bin/tr.exe
  /bin/wget.exe
)
cp -r --parents ${deps[@]} .
ldd ${deps[@]:1} |
  grep usr |
  sort -u |
  cut -d\  -f3 |
  xargs cp -t bin

# /usr/local/bin
set usr/local/bin
mkdir -p $1
cd $1
cp /opt/a/youtube.sh .
cd -

# /usr/share/terminfo
set usr/share
mkdir -p $1
cd $1
cp -r /usr/share/terminfo .
cd -

# archive
read < <(ls -C)
tar acf youtube.tar.gz $REPLY
rm -r $REPLY
