# Cygwin packages
setup -nqP libicu-devel,patch,ruby

# charlock_holmes
git clone --single-branch git://github.com/brianmario/charlock_holmes
cd charlock_holmes
# github.com/brianmario/charlock_holmes/issues/32
sed -i '51 s/^/have_library "icuuc"/' ext/charlock_holmes/extconf.rb
gem build charlock_holmes.gemspec
gem install charlock_holmes
cd -

# Install posix-spawn
git clone git://github.com/rtomayko/posix-spawn
cd posix-spawn
gem build posix-spawn.gemspec
gem install posix-spawn

# Install github-linguist
gem install github-linguist
linguist /usr/lib/ruby/1.9.1/csv.rb
