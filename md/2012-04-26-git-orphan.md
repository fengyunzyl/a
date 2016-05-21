---
layout: post
title: Git orphan
tags: Git
---

![git](/img/2012/git.jpg){:.width1}

~~~ bash
# Local rename
git branch -m master master-old
# Remote rename
git push origin master-old
git push origin :master
# Local new master
git checkout --orphan master
git rm -rf .
# do work
git add -A
git commit -m 'Initial commit'
# Remote new master
git push origin master
git push origin :master-old
~~~

* <http://stackoverflow.com/q/1384325/in-git-is-there-a-simple-way-of-introduci>
* <http://stackoverflow.com/q/1526794/rename-remote-git-branch>
