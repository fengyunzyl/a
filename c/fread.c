/*
aleax.it/TutWin32
boredzo.org/pointers
github.com/ffi/ffi/wiki/Binary-data
roseindia.net/c-tutorials/c-structure-pointer.shtml
stackoverflow.com/q/1835986/how-to-use-eof-to-run-through-a-text-file-in-c
*/
#define PCRE_STATIC
#include <pcre.h>
#include <stdio.h> // fopen

struct file {
  char *buf;
  int size;
};

struct file read_whole_file(char *file_name){
  FILE *fp = fopen(file_name, "r");
  fseek(fp, 0, SEEK_END);
  struct file fs;
  fs.size = ftell(fp);
  rewind(fp);
  fs.buf = malloc(fs.size);
  fread(fs.buf, 1, fs.size, fp);
  fclose(fp);
  return fs;
}

int main(){
  struct file fs = read_whole_file("null.log");
  
  printf("%s\n%d", fs.buf, fs.size);
  
  return 0;
}
