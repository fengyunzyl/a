# install Adobe HDS

cd /usr/local/bin
wget raw.github.com/K-S-V/Scripts/master/AdobeHDS.php

cat > php <<'EOF'
read script < <(command -v $1 | cygpath -mf-) && shift
/usr/local/php/php $script $*
EOF
