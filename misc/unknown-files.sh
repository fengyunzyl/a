#!/bin/sh
# This will associate unknown files with Notepad2.
# Scripts will still need an extension because of GitHub. 
# If you leave out the %1 it will just open a blank notepad.
# superuser.com/questions/13653

# Change default program
# reg add 'HKCR\Unknown\shell' -d 'openas' -f
reg add 'HKCR\Unknown\shell' -d 'Notepad2' -f

# Install Notepad2
reg add 'HKCR\*\shell\Notepad2\command' -d 'notepad "%1"' -f
reg add 'HKCR\Unknown\shell\Notepad2\command' -d 'notepad "%1"' -f

# Install custom Notepad2
# reg add 'HKCR\*\shell\Notepad2\command' -d 'C:\notepad2\Notepad2 "%1"' -f
# reg add 'HKCR\Unknown\shell\Notepad2\command' -d 'C:\notepad2\Notepad2 "%1"' -f
