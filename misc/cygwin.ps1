pushd
function not ($cm, $pm) {
  if (& $cm $pm) {0} else {1}  
}

$su, $fd = switch ($env:processor_architecture) {
  amd64 {'setup-x86_64.exe', 'cygwin64'}
  x86   {'setup-x86.exe',    'cygwin'}
}

md -f $env:homedrive/home/bin
cd $env:homedrive/home/bin

if (not test-path $su) {
  if (test-path $fd) {
    rm -r $fd
  }
  curl -outfile $su http://cygwin.com/$su
}

& ./$su -n -q -s http://box-soft.com -R $pwd/$fd | oh
# FIXME hard links
robocopy -mir $fd $env:homedrive/$fd
popd
