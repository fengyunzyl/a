while (Test-Path Alias:wget) {Remove-Item Alias:wget}
wget -qO- sourceware.org/cygwin/mirrors.lst | % {
  if ($_ -notmatch 'http') {
    return
  }
  $alpha = $_.split(';')[0]
  $alpha
  wget --quiet --spider --tries 1 --timeout .1 $alpha
  if ($?) {
    $bravo += ,$alpha
  }
}
"`nGOOD MIRRORS"
$bravo | sort length
