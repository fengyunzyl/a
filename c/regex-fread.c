/*
codecogs.com/reference/computing/c/stdio.h/fread.php
ubuntuforums.org/showthread.php?t=141670&page=3

$ tr "[:cntrl:]" "\n" < alj.core | wc -L
167039
*/
#define PCRE_STATIC
#include <pcre.h>
#include <stdio.h> // fopen
#include <string.h> // strlen

int main(){
  char buffer[167039];
  const char *error;
  int erroffset;
  int ovector[100];
  unsigned int offset = 0;
  
  FILE *fp = fopen("null.log", "r");
  
  fread(buffer, 167039, 1, fp);
  
  pcre *re = pcre_compile("sdf", 0, &error, &erroffset, 0);
  
  int e = pcre_exec(re, 0, buffer, strlen(buffer), offset, 0, ovector, sizeof ovector);
  
  printf("%d", e);
  
  return 0;
}

