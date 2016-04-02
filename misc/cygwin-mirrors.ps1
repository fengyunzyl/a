while (Test-Path Alias:wget) {Remove-Item Alias:wget}
wget -qO- sourceware.org/cygwin/mirrors.lst | % {
  if ($_ -notmatch 'http') {
    return
  }
  $alfa = $_.split(';')[0]
  $alfa
  wget --quiet --spider --tries 1 --timeout .2 $alfa
  if ($?) {
    $bravo += ,$alfa
  }
}
"`nGOOD MIRRORS"
$bravo | sort length
