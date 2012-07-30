// i686-w64-mingw32-gcc AdobeHDS.c -ldbghelp -lpcre -Wall
#include <pcre.h>
#include <stdio.h>
#include <windows.h>
  #include <dbghelp.h>
  #include <tlhelp32.h>

void red(char *string){
  void *hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_RED | FOREGROUND_INTENSITY);
  printf("%s\n", string);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_RED);
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

void dumper(win32pid){
  void *hProc = OpenProcess(PROCESS_ALL_ACCESS, FALSE, win32pid);
  void *hFile = CreateFile("p.core", GENERIC_WRITE, 0, 0, CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL, 0);
  MiniDumpWriteDump(hProc, win32pid, hFile, MiniDumpWithFullMemory, 0, 0, 0);
  CloseHandle(hFile);
}

void kill(win32pid){
  void *hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, win32pid);
  TerminateProcess(hProcess, 1);
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












