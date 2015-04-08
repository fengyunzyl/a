pushd
function warn {
  write-host -f yellow "`n$args"
}

function not ($cm, $pm) {
  if (& $cm $pm) {0} else {1}  
}

$ph, $fd = switch ($env:processor_architecture) {
  amd64 {'x86_64', 'msys64'}
  x86   {'i686',   'msys32'}
}

md -f $env:homedrive/home/bin
cd $env:homedrive/home/bin

warn 'Checking latest version...'
$bu = curl sourceforge.net/projects/msys2/files/Base/$ph |
  select -exp links | ? href -match tar | select -f 1 -exp href
$bo = $bu.split('/')[-2]

if (not test-path $bo) {
  if (test-path $fd) {
    rm -r $fd
  }
  curl -useragent . -outfile $bo $bu
}

# FIXME choco 7-zip
if (not test-path $fd) {
  7za x $bo
  7za x (gi $bo).basename
}

# FIXME hard links
robocopy -mir $fd $env:homedrive/$fd
popd
