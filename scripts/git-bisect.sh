
git clone git://github.com/mojombo/jekyll.git
cd jekyll
git bisect start
git bisect good 151ec1a
git bisect bad master

# repeat
git clean -fx
gem build jekyll.gemspec
gem uninstall -x jekyll
gem install jekyll
# test
cd /opt/svnpenn.github.com
timeout 10 jekyll serve -w
cd -
