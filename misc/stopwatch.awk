#!awk -f
BEGIN {
  foo = systime()
  bar = "date +%s.%N"
  while (bar | getline baz) {
    close(bar)
    printf "\t%.2f\r", baz - foo
  }
}
