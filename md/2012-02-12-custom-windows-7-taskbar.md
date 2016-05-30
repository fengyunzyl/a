---
layout: post
title: Custom Windows 7 Taskbar
tags: Windows
---

~~~ bash
#!/bin/dash
# support.microsoft.com?id=269269
# Grant full control of aero.msstyles
cd /c/Windows/Resources/Themes/Aero
# takeown /f aero.msstyles
# icacls aero.msstyles /grant Users:f
mv aero.msstyles aero-old.msstyles
~~~

* <http://anolis.codeplex.com>
* <http://winmatrix.com/forums/index.php?/topic/14250-tutorial-hex-editing-vista-visual-styles>
