[[ $1 =~ ^${TMP%U*} ]] && b=${1/${TMP%U*}} || b=${1/?/cygwin/}
"$ProgramW6432/notepad2/notepad2" "$HOMEDRIVE/$b"
