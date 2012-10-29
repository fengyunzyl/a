/*
hulu.c

i686-w64-mingw32-gcc hulu.c -Wall

mapfile vids < <(grep -aoz "<video [^>]*>" pg.core | sort | uniq -w123)
*/

#include <stdio.h> // fopen
#include <stdlib.h> // malloc

int main ()
{
  /* read file */
  FILE * f;
  int size;
  char * buffer;
  f = fopen("pg.core", "r");
  
  fseek(f, 0, SEEK_END);
  size = ftell(f);
  fseek(f, 0, SEEK_SET);
  
  buffer = malloc(size);
  fread(buffer, 1, size, f);
  fclose(f);
  
  /* print */
  printf("%s\n", buffer);
  
  return 0;
}
