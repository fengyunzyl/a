
git add -A "$1"

# print first added line if found, else print first removed line
b=$(git diff --cached | awk '
  /^+[^+]/       {m=$0;exit}
  /^-[^-]/ && !m {m=$0}
  END            {sub(/^[-+# ]+/, "", m); print m}
')

git commit -m "$b"
