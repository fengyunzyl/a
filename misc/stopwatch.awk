#!awk -f
func z() {
  getline < y
  close(y)
  return $0
}
BEGIN {
  y = "/proc/uptime"
  x = z()
  while (1)
    printf "%s\r", z() - x
}
