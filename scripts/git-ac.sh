
git add -A "$1"

# print first added line if found, else print first removed line
y=$(git diff --cached | awk '
  /^+[^+]/       {z=$0;exit}
  /^-[^-]/ && !z {z=$0}
  END            {sub(/^[-+# ]+/, "", z); print z}
')

git commit -m "$y"
