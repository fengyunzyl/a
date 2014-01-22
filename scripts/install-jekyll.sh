# cygwin packages
setup-x86_64 -nqP gcc4-core,ruby

# gems
gem install jekyll kramdown coderay

# install coderay_bash
set raw.github.com/rubychan/coderay/master/lib/coderay/scanners/bash.rb
if ! wget --spider $1
then
  gem install coderay_bash
  set $(find /lib/ruby -name scanners)
  cp $2/bash.rb $1
fi
