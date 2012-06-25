'This script creates a cygwin shortcut with the current directory.
set app = createobject("shell.application")
set shell = createobject("wscript.shell")

'Set CHERE_INVOKING
shell.environment("SYSTEM")("CHERE_INVOKING") = 1

'Execute Cygwin
linkfile = "C:\cygwin\cygwin.lnk"
set link = shell.createshortcut(linkfile)
link.targetpath = "C:\cygwin\bin\bash.exe"
link.arguments = "--login -i"
link.workingdirectory = wscript.arguments(0)
link.save
app.shellexecute linkfile
