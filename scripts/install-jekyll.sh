# Install Jekyll with Cygwin
setup-x86 -nqP gcc4-core,ruby

# install jekyll
gem install jekyll

# install coderay
gem install coderay

# install coderay_bash
set raw.github.com/rubychan/coderay/master/lib/coderay/scanners/bash.rb
if ! wget --spider $1
then
  gem install coderay_bash
  set $(find /lib/ruby -name scanners)
  cp $2/bash.rb $1
fi
