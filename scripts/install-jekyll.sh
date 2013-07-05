# Install Jekyll with Cygwin
setup -nqP gcc4-core,ruby

# install jekyll
gem install jekyll

# install posix-spawn
git clone git@github.com:rtomayko/posix-spawn
cd posix-spawn
gem build posix-spawn.gemspec
gem install posix-spawn

# install coderay
gem install coderay

# install coderay_bash
gem install coderay_bash
set $(find /lib/ruby -name scanners)
cp $2/bash.rb $1
