cd
if ! type apt-cyg >/dev/null
then
  lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
  install apt-cyg /bin
fi
apt-cyg install wget curl
xargs -p apt-cyg install <<< 'make mingw64-x86_64-gcc-core'
if ! type git 2>/dev/null
then
  wget -nc tastycake.net/~adam/cygwin/x86_64/git/git-2.0.4-1.tar.xz
  tar -x -C / -f git-2.0.4-1.tar.xz
fi
