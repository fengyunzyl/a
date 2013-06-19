# Cygwin packages
setup -nqP libicu-devel,patch,ruby,zlib-devel

# charlock_holmes
git clone --depth 1 git://github.com/brianmario/charlock_holmes.git
cd charlock_holmes
# github.com/brianmario/charlock_holmes/issues/32
sed -i '
50 s/^/have_library "z" or abort "libz missing"/
51 s/^/have_library "icuuc" or abort "libicuuc missing"/
' ext/charlock_holmes/extconf.rb
gem build charlock_holmes.gemspec
gem install charlock_holmes
cd -

# Install posix-spawn
git clone --depth 1 git://github.com/rtomayko/posix-spawn.git
cd posix-spawn
gem build posix-spawn.gemspec
gem install posix-spawn

# Install github-linguist
gem install github-linguist
linguist /usr/lib/ruby/1.9.1/csv.rb
