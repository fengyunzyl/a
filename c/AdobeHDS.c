// i686-w64-mingw32-gcc AdobeHDS.c -ldbghelp -lpcre -Wall
#include <io.h>
#include <pcre.h>
#include <stdio.h>
#include <windows.h>
  #include <dbghelp.h>
  #include <tlhelp32.h>

void kill(win32pid){
  TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, 0, win32pid), 1);
}

void dumper(win32pid){
  MiniDumpWriteDump(OpenProcess(PROCESS_ALL_ACCESS, 0, win32pid), win32pid,
    (void *)_get_osfhandle(fileno(fopen("p.core", "w"))),
    MiniDumpWithFullMemory, 0, 0, 0);
}

int pidof(const char *imagename){
  PROCESSENTRY32 pe32;
  void *hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  pe32.dwSize = sizeof(PROCESSENTRY32);
  do {
    if (strcmp(pe32.szExeFile, imagename) == 0)
      return pe32.th32ProcessID;
  } while (Process32Next(hProcessSnap, &pe32));
  return 0;
}

void red(char *string){
  void *hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_RED | FOREGROUND_INTENSITY);
  printf("%s\n", string);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_RED);
}

int main(){
  int pid_flash;
  pid_flash = pidof("plugin-container.exe");
  kill(pid_flash);
  FILE *mms = fopen("\\Windows/System32/Macromed/Flash/mms.cfg", "w");
  fprintf(mms, "ProtectedMode=0");
  fclose(mms);
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












