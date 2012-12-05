#!/bin/sh

keys=(
  '/user/Software/Microsoft/Internet Explorer/TypedURLs'
  '/user/Software/Microsoft/Windows/CurrentVersion/Explorer/RunMRU'
  '/user/Software/Microsoft/Windows/CurrentVersion/Explorer/TypedPaths'
)

for key in "${keys[@]}"; do
  regtool remove "$key"
done
