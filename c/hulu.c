/*
i686-w64-mingw32-gcc hulu.c -Wall
mapfile vids < <(grep -aoz "<video [^>]*>" pg.core | sort | uniq -w123)
*/

#include <stdio.h> // fopen
#include <stdlib.h> // malloc
#include <string.h> // strstr

int main ()
{
  // need array big enough for the biggest "video" line
  // 888

  char * buffer;
  int size;
  size = 1000;
  FILE * f;
  
  // need the "b"
  f = fopen("pg.core", "rb");
  
  buffer = malloc(size);
  
  while (! feof(f))
    {
      fgets(buffer, size, f);

      if (strstr(buffer, "<video "))
        printf("%s", buffer);
    }

  fclose(f);
  return 0;
}
