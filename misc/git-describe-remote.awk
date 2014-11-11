#!awk -f
BEGIN {
  if (ARGC != 2) {
    print "git-describe-remote.sh stedolan/jq"
    exit
  }
  FS = "[ /^]+"
  url = "https://github.com/" ARGV[1]
  while ("git ls-remote " url | getline) {
    if (!sha)
      sha = substr($0, 1, 7)
    tag = $3
  }
  while ("curl -s " url "/releases/tag/" tag | getline)
    if ($3 ~ "commits")
      printf "%s-%s-g%s\n", tag, $2, sha
}
