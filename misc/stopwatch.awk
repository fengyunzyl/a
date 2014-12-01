#!awk -f
BEGIN {
  foo = systime()
  bar = "date +%s.%2N"
  while (bar | getline baz) {
    close(bar)
    printf "\t%s\r", baz - foo
  }
}
