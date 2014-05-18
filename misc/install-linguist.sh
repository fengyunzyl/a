# packages
set gcc-core gcc-g++ libcrypt-devel libicu-devel patch ruby zlib-devel
apt-cyg install $*

# faster_require
git clone git://github.com/rdp/faster_require
cd faster_require
gem b faster_require.gemspec
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)
cd -

# charlock_holmes
git clone --single-branch git://github.com/brianmario/charlock_holmes
cd charlock_holmes
gem b charlock_holmes.gemspec
gem i charlock_holmes

# linguist
gem i github-linguist
linguist $(find /lib -name csv.rb)
