/*
i686-w64-mingw32-gcc regex.c -ldbghelp -lpcre -Wall
*/
#include "AdobeHDS.h"

int main(){

  char buf[BUFSIZ];
  const char *error;
  int erroffset;
  int ovector[100];
  unsigned int offset = 0;

  pcre *re = pcre_compile("http.*html", 0, &error, &erroffset, 0);
  
  FILE *fp = fopen("AdobeHDS.c", "r");
  
  while (fgets(buf, sizeof buf, fp) != NULL) {
    
    pcre_exec(re, 0, buf, strlen(buf), offset, 0, ovector, sizeof ovector);
        
    if (ovector[0] > -1)
      printf("%s\n", buf);
    
  }

  return 0;
}
