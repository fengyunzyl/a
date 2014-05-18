# packages
apt-cyg install gcc-core libcrypt-devel libffi-devel pkg-config ruby

# faster_require
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)

# 2.0.3
gem i jekyll

# rougify style > rouge.css
gem i rouge
