# packages
pacman -S gcc libcrypt-devel libffi-devel pkg-config ruby

# faster_require
gem i faster_require
sed -i "1crequire '$(gem w faster_require)'" $(gem w rubygems)

# v1.4.3
git clone git://github.com/jekyll/jekyll
cd jekyll
gem b jekyll.gemspec
gem i jekyll

# rouge
gem i rouge
rougify style > rouge.css
