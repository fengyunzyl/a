#!/bin/dash -e
# http://xhelmboyx.tripod.com/formats/mp4-layout.txt
# GOOD
# 0 1 2 3 4 5 7 8 9 10 11 12 13

# BAD
# 6 14

ic() {
  by=$1
  wd=$((${#by} - 2))
  printf %0${wd}x $((by + sp)) | pc
}

pc() {
  awk -b '{printf "%c", strtonum("0x" RT)}' RS=..
}

if [ "$#" != 1 ]
then
  echo 'metadata.sh [bytes]'
  exit
fi

sp=$1

ffmpeg -i confetti-720p-h264-192k-aac.mp4 -c copy -f adts - |
ffmpeg -i - -c copy -bsf aac_adtstoasc -movflags faststart \
  -metadata title=Confetti good.m4a

ffmpeg -i confetti-720p-h264-192k-aac.mp4 -c copy -vn -movflags faststart \
  -metadata title=Confetti bad.m4a

cp good.m4a $sp.m4a

# moov
ic 0x0000A35E | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x18))

# trak
ic 0x0000A268 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x8C))

# mdia
ic 0x0000A1E0 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x114))

# minf
ic 0x0000A18B | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x169))

# stbl
ic 0x0000A14F | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1A5))

# stsd
ic 0x00000067 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1AD))

# mp4a
ic 0x00000057 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1BD))

# stco  NEED
ic 0x0000A386 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC))
ic 0x0010A2F5 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC + 4))
ic 0x0020A1F0 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC + 8))
ic 0x0030A08E | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC + 12))
ic 0x00409E5F | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC + 16))
ic 0x00509E41 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0xA2DC + 20))

# esds
ic 0x00000033 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1E1))
ic 0x22 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1F1))
ic 0x14 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x1F9))
ic 0x02 | dd conv=notrunc of=$sp.m4a bs=1 seek=$((0x20B))

(
  head -c $((0x20E))
  if [ "$sp" ]
  then printf %0$((sp*2))x 0x00 | pc
  fi
  cat
) < $sp.m4a > $$
mv $$ $sp.m4a

exit

if [ "$#" != 2 ]
then
  echo 'ff-metadata.sh [basename a] [basename b]'
  exit
fi

tr '\0' '\n' < $1.m4a > $1.txt
tr '\0' '\n' < $2.m4a > $2.txt
git diff $1.txt $2.txt > metadata.diff

exit

BAD
GOOD

6C
5E
moov

76
68
trak

EE
E0
mdia

99
8B
minf

5D
4F
stbl

75
67
stsd

65
57
mp4a

# long unsigned offset + long ASCII text string 'esds'
00 00 00 41 65 73 64 73
00 00 00 33 65 73 64 73

# 4 bytes version/flags
00 00 00 00
00 00 00 00

# 1 byte ES descriptor type tag = 8-bit hex value 0x03
03
03

# 3 bytes extended descriptor type tag string
80 80 80
80 80 80    

# 1 byte descriptor type length
30
22 

# 2 bytes ES ID
00 01
00 01

# 1 byte stream priority
00
00

# 1 byte decoder config descriptor type tag
04
04

# 3 bytes extended descriptor type tag string
80 80 80
80 80 80   

# 1 byte descriptor type length
22
14  

# 1 byte object type ID
40
40

# 6 bits stream type
# 1 bit upstream flag
# 1 bit reserved flag
15
15

# 3 bytes buffer size
00 00 00
00 00 00

# 4 bytes maximum bit rate
00 02 EE 8E
00 02 EE 8E

# 4 bytes average bit rate
00 02 EE 8E
00 02 EE 8E

# 1 byte decoder specific descriptor type tag
05
05

# 3 bytes extended descriptor type tag string
80 80 80
80 80 80    

# 1 byte descriptor type length
10
02

# ES header start codes = hex dump
12 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
12 10

# 1 byte SL config descriptor type tag
06
06

# 3 bytes extended descriptor type tag string
80 80 80
80 80 80

# 1 byte descriptor type length
01
01

# 1 byte SL value
02
02

# long unsigned offset + long ASCII text string 'stco'
00 00 00 28 73 74 63 6F
00 00 00 28 73 74 63 6F

# 4 bytes number of offsets
00 00 00 00
00 00 00 00

# 4+ bytes block offsets
00 00 00 06
00 00 00 06

00 00 A3 94
00 00 A3 86

00 10 A3 03
00 10 A2 F5

00 20 A1 FE
00 20 A1 F0

00 30 A0 9C
00 30 A0 8E

00 40 9E 6D
00 40 9E 5F

00 50 9E 4F
00 50 9E 41
