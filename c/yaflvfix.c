#define _FILE_OFFSET_BITS 64 

#include <stdio.h>
#include <string.h>

#define SKIP_SOME_TAGS 0

/* All times in ms */
#define TS_MIN_TRESHOLD 4
#define TS_WINDOW_CHECK 33000

#if defined(_MSC_VER)
#define off_t __int64
#define ftello _ftelli64
#elif defined(WIN32)
#define ftello ftello64
#endif 

int main(int argc, char* argv[])
{
	FILE *fIn, *fOut;
	off_t filePos, fileSize;
	int checkForShift, res;
	unsigned int len, dataSize, timeStamp, timeStampPrev, timeStampShift, prevAudioTS, prevVideoTS, previousTagSize, firstNonZeroTimeStamp;
	unsigned char buf[4096];
	char fname[1024], *p;

	res = 1;

	if (argc < 2)
	{
		printf("Usage: %s <input flv file> [<output flv file>]\n", argv[0]);
		return res;
	}

	printf("Yet Another FLV Fixer\n");

	fIn = fopen(argv[1], "rb");
	if (!fIn)
	{
		printf("Failed to open file: %s\n", argv[1]);
		return res;
	}

	/* Obtain file size */
	filePos = 0;
	fseek(fIn, 0, SEEK_END);
	fileSize = ftello(fIn);
	fseek(fIn, 0, SEEK_SET);
	if (fileSize == 0)
	{
		printf("Failed to obtain input file size\n");
		return res;
	}

	memset(fname, 0, sizeof(fname));
	if (argc >= 3)
		strncpy(fname, argv[2], sizeof(fname) - 1);
	else
	{
		p = strrchr(argv[1], '.');
		strncpy(fname, argv[1], p ? p - argv[1] : sizeof(fname) - 9);
		strcat(fname, "_fix.flv");
	}
	fOut = fopen(fname, "wb");
	if (!fOut)
	{
		printf("Failed to create file: %s\n", fname);
		fclose(fIn);
		return res;
	}

	do
	{
		/* Read FLV header */
		if (fread(buf, 1, 9, fIn) != 9 || buf[0] != 'F' || buf[1] != 'L' || buf[2] != 'V' || buf[3] != 0x01)
		{
			printf("Invalid FLV header\n");
			break;
		}
		if (fseek(fIn, ((((((buf[5] << 8) | buf[6]) << 8) | buf[7]) << 8) | buf[8]), SEEK_SET))
		{
			printf("Failed to seek to first FLV tag\n");
			break;
		}
		buf[5] = buf[6] = buf[7] = 0; buf[8] = 9;
		if (fwrite(buf, 1, 9, fOut) != 9)
		{
			printf("Error writing file\n");
			break;
		}
		filePos += 9;

		checkForShift = 1;
		timeStampPrev = timeStampShift = prevAudioTS = prevVideoTS = previousTagSize = firstNonZeroTimeStamp = 0;

		/* Read FLV tags */
		while (1)
		{
			printf("\rProcessed %.2f%%", ((float)filePos * 100 / fileSize));
			if (fread(buf, 1, 15, fIn) != 15)
			{
				res = 0;
				break;
			}
			filePos += 15;
			/* PreviousTagSize */
			/* Tag Type */
			/* Data Size */
			dataSize = (((buf[5] << 8) | buf[6]) << 8) | buf[7];
			/* Timestamp + TimestampExtended */
			timeStamp = (((((buf[11] << 8) | buf[8]) << 8) | buf[9]) << 8) | buf[10];
			/* StreamID */

			if (timeStamp && ((buf[4] & 0x1F) == 8 || (buf[4] & 0x1F) == 9))
			{
				/* Audio or Video */
				if (firstNonZeroTimeStamp == 0)
				{
					if (timeStamp >= TS_WINDOW_CHECK)
					{
						/* Media recorded not from the beginning */
						timeStampShift = timeStamp;
						checkForShift = 0;
						printf("\nRecording started from %u ms\n", timeStampShift);
					}
					firstNonZeroTimeStamp = timeStamp;
				}
				if (timeStampShift == 0 && checkForShift)
				{
					if (timeStampPrev >= TS_MIN_TRESHOLD && timeStamp >= timeStampPrev + TS_WINDOW_CHECK)
					{
						timeStampShift = timeStamp - timeStampPrev;
						printf("\nDetected %u ms time shift\n", timeStampShift);
					}
					else
						timeStampPrev = timeStamp;
					if (timeStamp >= firstNonZeroTimeStamp + TS_WINDOW_CHECK)
						checkForShift = 0; /* Time shift not found */
				}
				if (timeStampShift && timeStamp >= timeStampShift)
					timeStamp -= timeStampShift;
				if ((buf[4] & 0x1F) == 8)
				{
					/* Check and fix non-monotonic audio timestamps */
					if (timeStamp < prevAudioTS)
						timeStamp = prevAudioTS;
					prevAudioTS = timeStamp;
				}
				if ((buf[4] & 0x1F) == 9)
				{
					/* Check and fix non-monotonic video timestamps */
					if (timeStamp < prevVideoTS)
						timeStamp = prevVideoTS;
					prevVideoTS = timeStamp;
				}
				/* Store corrected timestamp */
				buf[10] = timeStamp;
				timeStamp >>= 8;
				buf[9] = timeStamp;
				timeStamp >>= 8;
				buf[8] = timeStamp;
				timeStamp >>= 8;
				buf[11] = timeStamp;
			}

			len = 15;
#if SKIP_SOME_TAGS
			if ((buf[4] & 0x1F) == 9)
			{
				if (fread(buf + 15, 1, 1, fIn) != 1)
				{
					res = 0;
					break;
				}
				++filePos;
				--dataSize;
				if ((buf[15] & 0xF0) == 0x50)
					len = 0; /* Skip video info frame */
				else
					++len;
			}

			if (len == 0 || dataSize == 0/*skip small packets*/)
			{
				/* Skip this tag */
				filePos += dataSize;
				if (fseek(fIn, dataSize, SEEK_CUR))
				{
					res = 0;
					break;
				}
				continue;
			}
#endif
			/* Write previous tag size */
			buf[3] = previousTagSize;
			previousTagSize >>= 8;
			buf[2] = previousTagSize;
			previousTagSize >>= 8;
			buf[1] = previousTagSize;
			previousTagSize >>= 8;
			buf[0] = previousTagSize;

			previousTagSize = dataSize + len - 4;

			/* Write tag header */
			if (fwrite(buf, 1, len, fOut) != len)
			{
				printf("\nError writing file\n");
				break;
			}
			/* Write tag data */
			while (dataSize)
			{
				len = dataSize < sizeof(buf) ? dataSize : sizeof(buf);
				if (fread(buf, 1, len, fIn) != len)
				{
					res = 0;
					break;
				}
				filePos += len;
				if (fwrite(buf, 1, len, fOut) != len)
				{
					printf("\nError writing file\n");
					break;
				}
				dataSize -= len;
			}
			if (dataSize != 0)
				break;
		}

		/* Write last tag size */
		buf[3] = previousTagSize;
		previousTagSize >>= 8;
		buf[2] = previousTagSize;
		previousTagSize >>= 8;
		buf[1] = previousTagSize;
		previousTagSize >>= 8;
		buf[0] = previousTagSize;
		fwrite(buf, 1, 4, fOut);
		filePos += 4;
		if (filePos > fileSize)
			filePos = fileSize;
	}
	while (0);

	if (fOut)
		fclose(fOut);
	if (fIn)
		fclose(fIn);

	if (!res)
		printf("\rProcessed %.2f%%\n", ((float)filePos * 100 / fileSize));

	return res;
}
