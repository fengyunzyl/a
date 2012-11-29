#!/bin/bash
# Should be v1.8.0.1-260-g226dcb5

# Get last tag
# ed9fe755130891fc878bb2433204faffb534697b        refs/tags/v1.8.0.1^{}
git ls-remote -t git://github.com/git/git.git |
  tail -1 |
  tr / ^ |
  cut -d^ -f3
  tee tg

# Get commits to HEAD
wget -qO- https://api.github.com/repos/git/git/compare/$REPLY...HEAD |
  grep total_commits
