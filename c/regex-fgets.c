/*
$ tr "[:cntrl:]" "\n" < alj.core | wc -L
167039
*/
#define PCRE_STATIC
#include <pcre.h>
#include <stdio.h> // fopen
#include <string.h> // strlen

int main(){
  char buf[BUFSIZ];
  const char *error;
  int erroffset;
  int ovector[100];
  unsigned int offset = 0;

  // grep -axzm1 "[ -~]*$1[ -~]*" p.core
  // IFS=? read a1 a2 < <(binparse "Frag")
  // grep -azm1 Frag p.core
  
  pcre *re = pcre_compile("http.*html", 0, &error, &erroffset, 0);
  
  FILE *fp = fopen("AdobeHDS.c", "r");
  
  while (fgets(buf, sizeof buf, fp) != NULL) {
    
    pcre_exec(re, 0, buf, strlen(buf), offset, 0, ovector, sizeof ovector);
        
    if (ovector[0] > -1)
      printf("%s\n", buf);
    
  }
  
  return 0;
}
