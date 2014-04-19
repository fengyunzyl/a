# packages
set gcc-core gcc-g++ libcrypt-devel libicu-devel patch ruby zlib-devel
apt-cyg install $*

# faster_require
gem i faster_require
cd $(find /lib -type d -name 'faster_require*')
curl -L github.com/rdp/faster_require/commit/dd680bb.diff | git apply
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
