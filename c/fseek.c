/*
hulu.c
i686-w64-mingw32-gcc hulu.c -Wall
*/

#include <stdio.h> // fopen
#include <stdlib.h> // malloc
#include <string.h> // strlen

int main ()
{
  // need array big enough for the biggest "video" line
  // 888
  
  // read file
  FILE * f;
  int size;
  char * buffer;
  f = fopen("a.core", "r");
  
  fseek(f, 0, SEEK_END);
  size = ftell(f);
  fseek(f, 0, SEEK_SET);
  
  buffer = malloc(size);
  fread(buffer, 1, size, f);
  fclose(f);
  
  // print
  int len;
  
  while (size > 0)
    {
      if (strstr(buffer, "<video "))
        puts(buffer);
      
      // move pointer
      len = strlen(buffer) + 1;
      buffer += len;
      size -= len;
    }

  return 0;
}
