#!/bin/sh

pag=http://stream-recorder.com/forum/adobe-hds-downloader-t12074

# Page 1
wget -O "1.html" -U iPad "google.com/search?q=cache:${pag}.html"

# Other pages
for i in {2..42}
do
  wget -O "$i.html" -U iPad "google.com/search?q=cache:${pag}p${i}.html"
done
