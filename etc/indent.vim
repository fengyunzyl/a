#!/usr/bin/ex -sS
" 1. decorate comments preceded by code
v,^\s*//,s,//,\r#&,
" 2. decorate printf format strings
g,\\n.$,s,$,//,
" 3. decorate bitwise AND
%s, &\_s, $\&\&,g
%!indent -st
" 4. undecorate bitwise AND
%s,\v\$(\_s*)\&\& ?,\&\1,g
%s, $
" 5. undecorate printf format strings
%s, //$
" 6. undecorate comments preceded by code
%s,\n#\s\+, ,
x
