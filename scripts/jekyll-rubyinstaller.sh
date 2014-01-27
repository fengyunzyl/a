GEM_HOME=/usr/local/ruby/lib/ruby/gems/2.0.0
cd $GEM_HOME

# fast-stemmer
gem f fast-stemmer
gem sp fast-stemmer-1.0.2.gem --ruby > fast-stemmer.gemspec
mv fast-stemmer.gemspec specifications

# yajl-ruby
gem f yajl-ruby -v1.1
gem sp yajl-ruby-1.1.0.gem --ruby > yajl-ruby.gemspec
mv yajl-ruby.gemspec specifications

# redcarpet
gem f redcarpet -v2.3
gem sp redcarpet-2.3.0.gem --ruby > redcarpet.gemspec
mv redcarpet.gemspec specifications

# jekyll
gem i jekyll
