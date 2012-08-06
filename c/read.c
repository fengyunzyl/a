/*
pcre_compile
pcre_exec
fopen
fread
memchr



http://www.codecogs.com/reference/computing/c/stdio.h/fread.php
http://ubuntuforums.org/showthread.php?t=141670&page=3

#include <stdlib.h> // malloc
*/
#include <stdio.h> // FILE, printf

int main(){
  
  FILE *fp = fopen("null.log", "rb");
  
  fseek(fp, 0, SEEK_END);
  
  long siz = ftell(fp);
  
  rewind(fp);
  
  char buffer[siz + 1];
  
  fread(buffer, 1, siz, fp);
  
  buffer[siz] = '\0';
  
  printf("%s", buffer);
  
  
  
  
  
  
  int e = pcre_exec(cre, 0, line_buf, line_end - line_buf, );
  
  
  
  /*
  char *line_end = memchr(buffer, 'f', strlen(buffer));
  printf("%s\n\n%s", buffer, line_end);
  */
  return 0;  
}



























