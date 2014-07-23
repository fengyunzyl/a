# black is invisible
& {
  'blue'
  'cyan'
  'darkblue'
  'darkcyan'
  'darkgray'
  'darkgreen'
  'darkmagenta'
  'darkred'
  'darkyellow'
  'gray'
  'green'
  'magenta'
  'red'
  'white'
  'yellow'
} | % {
  Write-Host -ForegroundColor $_ $_
}
