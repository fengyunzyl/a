set wshshell = wscript.createobject("wscript.shell")
wscript.sleep 1000
for cound = 0 to 1000
  wshshell.sendkeys "{LEFT}{RIGHT}"
next
