/*
i686-w64-mingw32-gcc AdobeHDS.c -ldbghelp -lpcre -Wall

git clone git://metalog.git.sourceforge.net/gitroot/metalog/metalog
ibm.com/developerworks/systems/library/es-MigratingWin32toLinux.html
lemoda.net/c/read-whole-file
pastebin.com/j0aYDBfq
stackoverflow.com/q/1421785/how-can-i-use-pcre-to-get-all-match-groups
ubuntuforums.org/showthread.php?t=141670&page=3
*/
#include "AdobeHDS.h"

int main(){
  int pid_flash;
  pid_flash = pidof("plugin-container.exe");
  kill(pid_flash);
  wf("\\Windows/System32/Macromed/Flash/mms.cfg", "ProtectedMode=0");
  red("Press enter after video starts");
  getchar();
  red("Printing results");
  pid_flash = pidof("plugin-container.exe");
  dumper(pid_flash);
  kill(pid_flash);
  
  // grep -axzm1 "[ -~]*$1[ -~]*" p.core
  // IFS=? read a1 a2 < <(binparse "Frag")

  return 0;
}
