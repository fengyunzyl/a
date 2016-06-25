#!/usr/bin/ex -sS
v.^\s*//.s.//.\r#&.
%s.\v> \&([^&]). $\&\&\1.g
%!indent -st
%s.\n#\s\+. .
%s.\v\$(\_s*)\&\& ?.\&\1.g
%s. $
x
