/* ffmpeg_test.c
 * (C) Copyright 2010 Michael Meeuwisse
 *
 * To compile:
 * gcc -o ffmpeg_test ffmpeg_test.c video.c -lavformat -lavcodec -lavutil -lswscale -Wall
 *
 * Usage:
 * ./ffmpeg_test videofile
 *
 
 
 Description: 
	Application reads a passed by arguments video file and extracts first 100 frames 
	and writes them to screens folder in PPM format. 

Note: 
	The current compiled version in /bin is based on 2011-05-27 Zeranoe FFmpeg build.


Compiling & running on Windows:

1. Install MinGW
2. From http://ffmpeg.zeranoe.com/builds/ download 'Shared' & 'Dev' builds of FFmpeg.
3. Copy 'Include' & 'Lib' folders from 'Dev' package to MinGW installation directory.
4. Run BUILD.bat - if everything went ok, then continue.
5. Copy all DLL(avcodec-53.dll etc.) files from 'Shared' package 'Bin' folder to this directory bin folder.
6. Launch TEST.bat to get 100 first frames from included sample video. The screens will be placed in 'screens' folder.

Enjoy!
 
echo MinGW directory is: %MINGWDIR%
PATH=%MINGWDIR%\bin;%MINGWDIR%\include;%MINGWDIR%\lib

echo Compiling...
gcc -o bin/app.exe src/*.c -lavformat -lavcodec -lavutil -lswscale -Wall
 */



#ifndef VIDEOH
#define VIDEOH

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>

#include <stdio.h>
#include <string.h>




typedef struct _video {
    AVFormatContext *pFormatCtx;
    AVCodecContext *pCtx;
    AVCodec *pCodec;
    AVFrame *pRaw;
    AVFrame *pDat;
    uint8_t *buffer;
		struct SwsContext *Sctx;
		int videoStream, width, height, format;
} video;

video *video_init(char *file, int width, int height, int format);
int video_next(video *cur);
video *video_quit(video *cur);
void video_debug_ppm(video *cur, char *file);

#endif

// captures first 100 frames
#define NUM_FRAMES 100

int main(int argc, char *argv[]) {

	video *cur;
	
	/* Warning: example code below assumes all calls succeed */
	
//	cur = video_init(argv[1], 250, 100, PIX_FMT_RGB24);
	cur = video_init(argv[1], 0, 0, PIX_FMT_RGB24);//PIX_FMT_GRAY8);
	
	char name[64];
	int num = 0;
	
	mkdir("screens");
	
	while(num++ < NUM_FRAMES){
		sprintf(name, "screens/test%d.ppm", num);
		while(video_next(cur) < -1);
		printf("writing %d frame\r", num);
		video_debug_ppm(cur, name);
	}
	
	video_quit(cur);
	
	return 0;
}

/* Init video source 
 * file: path to open
 * width: destination frame width in pixels - use 0 for source
 * height: destination frame height in pixels - use 0 for source
 * format: PIX_FMT_GRAY8 or PIX_FMT_RGB24
 * Returns video context on succes, NULL otherwise
 */
video *video_init(char *file, int width, int height, int format) {
	int i = 0;
	
	video *ret = malloc(sizeof(video));
	memset(ret, 0, sizeof(video));
	ret->format = format;
	
	/* Init ffmpeg */
	av_register_all();
	
	/* Open file, check usability */
	if(av_open_input_file(&ret->pFormatCtx, file, NULL, 0, NULL) ||
		av_find_stream_info(ret->pFormatCtx) < 0)
		return video_quit(ret);
	
	/* Find the first video stream */
	ret->videoStream = -1;
	for(i = 0; i < ret->pFormatCtx->nb_streams; i++)
		if(ret->pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
			ret->videoStream = i;
			break;
		}
	
	if(ret->videoStream == -1)
		return video_quit(ret);
	
	/* Get context for codec, pin down target width/height, find codec */
	ret->pCtx = ret->pFormatCtx->streams[ret->videoStream]->codec;
	ret->width = width? width: ret->pCtx->width;
	ret->height = height? height: ret->pCtx->height;
	ret->pCodec = avcodec_find_decoder(ret->pCtx->codec_id);
	
	if(!ret->pCodec ||
		avcodec_open(ret->pCtx, ret->pCodec) < 0)
		return video_quit(ret);
	
	/* Frame rate fix for some codecs */
	if(ret->pCtx->time_base.num > 1000 && ret->pCtx->time_base.den == 1)
		ret->pCtx->time_base.den = 1000;
	
	/* Get framebuffers */
	ret->pRaw = avcodec_alloc_frame();
	ret->pDat = avcodec_alloc_frame();
	
	if(!ret->pRaw || !ret->pDat)
		return video_quit(ret);
	
	/* Create data buffer */
	ret->buffer = malloc(avpicture_get_size(ret->format, 
		ret->pCtx->width, ret->pCtx->height));
	
	/* Init buffers */
	avpicture_fill((AVPicture *) ret->pDat, ret->buffer, ret->format, 
		ret->pCtx->width, ret->pCtx->height);
	
	/* Init scale & convert */
	ret->Sctx = sws_getContext(ret->pCtx->width, ret->pCtx->height, ret->pCtx->pix_fmt,
		ret->width, ret->height, ret->format, SWS_BICUBIC, NULL, NULL, NULL);
	
	if(!ret->Sctx)
		return video_quit(ret);
	
	/* Give some info on stderr about the file & stream */
	//dump_format(ret->pFormatCtx, 0, file, 0);
	
	return ret;
}

/* Parse next packet from cur video
 * Returns 0 on succes, -1 on read error,
 * -2 when not a video packet (ignore these) and -3 for invalid frames (skip these)
 */
int video_next(video *cur) {
	AVPacket packet;
	int finished = 0;
	
	/* Can we read a frame? */
	if(av_read_frame(cur->pFormatCtx, &packet) < 0)
		return -1;
	
	/* Is it what we're trying to parse? */
	if(packet.stream_index != cur->videoStream) {
		av_free_packet(&packet);
		return -2;
	}
	
	/* Decode it! */
	avcodec_decode_video2(cur->pCtx, cur->pRaw, &finished, &packet);
	
	/* Succes? If not, drop packet. */
	if(!finished) {
		av_free_packet(&packet);
		return -3;
	}
	
	/* gcc gets trippy because of the double const usage in argument 2 - hard cast 
	 * Scale & convert decoded frame to correct size & colorspace
	 */
	sws_scale(cur->Sctx, (const uint8_t* const *) cur->pRaw->data, cur->pRaw->linesize, 
		0, cur->pCtx->height, cur->pDat->data, cur->pDat->linesize);
	av_free_packet(&packet);
	
	return 0;
}

/* Close & Free cur video context 
 * This function is also called on failed init, so check existence before de-init
 */
video *video_quit(video *cur) {
	if(cur->Sctx)
		sws_freeContext(cur->Sctx);
	
	if(cur->pRaw)
		av_free(cur->pRaw);
	if(cur->pDat)
		av_free(cur->pDat);
	
	if(cur->pCtx)
		avcodec_close(cur->pCtx);
	if(cur->pFormatCtx)
		av_close_input_file(cur->pFormatCtx);
	
	free(cur->buffer);
	free(cur);
	
	return NULL;
}

/* Output frame to file in PPM format */
void video_debug_ppm(video *cur, char *file) {
	int i = 0;
	FILE *out = fopen(file, "wb");
	
	if(!out)
		return;
	
	/* PPM header */
	fprintf(out, "P%d\n%d %d\n255\n", cur->format == PIX_FMT_GRAY8? 5: 6, 
		cur->width, cur->height);
	
	/* Spit out raw data */
	for(i = 0; i < cur->height; i++)
		fwrite(cur->pDat->data[0] + i * cur->pDat->linesize[0], 1,
			cur->width * (cur->format == PIX_FMT_GRAY8? 1: 3), out);
	
	fclose(out);
}