# install google
# http://googlecl.googlecode.com

cd
rm -r googlecl
wget -nc googlecl.googlecode.com/files/googlecl-win32-0.9.14.zip
unzip googlecl-win32-0.9.14.zip
cd googlecl
chmod +x google.exe python26.dll pyexpat.pyd _socket.pyd _ssl.pyd
