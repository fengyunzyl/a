
git clone git://github.com/mojombo/jekyll.git
cd jekyll
git bisect start
git bisect good 151ec1a
git bisect bad master
