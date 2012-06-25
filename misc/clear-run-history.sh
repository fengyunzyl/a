#!/bin/sh

# YES
reg delete 'HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\TypedURLs'

# MAYBE
reg delete 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU'
