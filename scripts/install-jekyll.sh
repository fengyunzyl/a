# packages
setup-x86_64 -nqP gcc-core,libcrypt-devel,libffi-devel,pkg-config,ruby

# faster_require
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)

# 2.0.0.alpha.1
gem i jekyll --pr

# rougify style > rouge.css
gem i rouge
