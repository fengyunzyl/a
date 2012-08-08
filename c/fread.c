#include <stdio.h> // fopen



int main(){
  char buf[BUFSIZ];
  char *error;
  int erroffset;
  int ovector[100];
  unsigned int offset = 0;
  FILE *fp = fopen("null.log", "r")
  pcre *re = pcre_compile("sdf", 0, &error, &erroffset, 0);
  
  while (fread(buf, sizeof buf, 1, fp) == 1) {
    
    for (line_next = buf; line_next < buf + sizeof;
        start_ofs -= line_next - line_buf)
      {
        
      }
    
    
    
    
    
    
    int e = pcre_exec(re, 0, buf, strlen(buf), offset, 0, ovector, sizeof ovector);
    
    printf("%d\n", e);
    
    
    
    
    
  }
  
  
  
  
  
  
  
  
  
  
  
  
  return 0;
}
