# packages
pacman -S gcc libcrypt-devel libffi-devel pkg-config ruby

# faster_require
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)

# jekyll
gem i jekyll

# rougify style > rouge.css
gem i rouge
