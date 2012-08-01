#define PCRE_STATIC
#include <pcre.h>
#include <stdio.h>
#include <windows.h>
  #include <dbghelp.h>
  #include <tlhelp32.h>

void kill(win32pid){
  TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, 0, win32pid), 1);
}

void dumper(win32pid){
  HANDLE hFile = CreateFile("p.core", GENERIC_WRITE, 0, 0, CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL, 0);
  MiniDumpWriteDump(OpenProcess(PROCESS_ALL_ACCESS, 0, win32pid), win32pid,
    hFile, MiniDumpWithFullMemory, 0, 0, 0);
}

int pidof(char *imagename){
  PROCESSENTRY32 pe32;
  HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  pe32.dwSize = sizeof(PROCESSENTRY32);
  do {
    if (strcmp(pe32.szExeFile, imagename) == 0)
      return pe32.th32ProcessID;
  } while (Process32Next(hProcessSnap, &pe32));
  return 0;
}

void red(char *string){
  HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_RED | FOREGROUND_INTENSITY);
  printf("%s\n", string);
  SetConsoleTextAttribute(hConsole,
    FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_RED);
}

void wf(char *file, char *data){
  HANDLE hFile = CreateFile(file, GENERIC_WRITE, 0, 0, CREATE_ALWAYS,
    FILE_ATTRIBUTE_NORMAL, 0);
  DWORD bw;
  WriteFile(hFile, data, (DWORD)strlen(data), &bw, 0);
  CloseHandle(hFile);
}
