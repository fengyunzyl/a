#!/bin/sh

# Cygwin packages
setup -nqP git
setup -nqP libicu-devel
setup -nqP make
setup -nqP ruby
setup -nqP wget
setup -nqP zlib

# Install charlock_holmes, you must clone it
git clone --depth 1 git://github.com/brianmario/charlock_holmes.git
cd charlock_holmes/ext/charlock_holmes
wget raw.github.com/a3li/a3li-overlay/master/dev-ruby/charlock_holmes/files\
/extconf.patch
git apply extconf.patch
cd ../..
gem build charlock_holmes.gemspec
gem install charlock_holmes-0.6.9
cd ..

# Install posix-spawn
git clone --depth 1 git://github.com/rtomayko/posix-spawn.git
cd posix-spawn
gem build posix-spawn.gemspec
gem install posix-spawn-0.3.6
cd ..

# Install github-linguist
gem install github-linguist
