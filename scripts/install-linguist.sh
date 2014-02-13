# packages
pacman -S gcc icu-devel libcrypt-devel patch ruby zlib-devel

# faster_require
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)

# charlock_holmes
git clone --single-branch git://github.com/brianmario/charlock_holmes
cd charlock_holmes
# github.com/brianmario/charlock_holmes/issues/32
sed -i '51s/^/have_library "icuuc"/' ext/charlock_holmes/extconf.rb
gem b charlock_holmes.gemspec
echo ac_cv_build=x86_64-unknown-cygwin > ~/config.site
export CONFIG_SITE=~/config.site
gem i charlock_holmes

# linguist
gem i github-linguist
linguist /lib/ruby/2.0.0/csv.rb
