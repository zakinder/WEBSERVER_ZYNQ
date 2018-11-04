#include <xparameters.h>
#define SCREEN_WIDTH_HORIZONTAL 1920
#define SCREEN_HEIGHT_VERTICAL 1080
#define VIDEO_RESOLUTION_VGA       0
#define VIDEO_RESOLUTION_480P      1
#define VIDEO_RESOLUTION_576P      2
#define VIDEO_RESOLUTION_SVGA      3
#define VIDEO_RESOLUTION_XGA       4
#define VIDEO_RESOLUTION_720P      5
#define VIDEO_RESOLUTION_SXGA      6
#define VIDEO_RESOLUTION_1080P     7
#define VIDEO_RESOLUTION_UXGA      8
#define NUM_VIDEO_RESOLUTIONS      9
#define ADV7511_ADDR 0x72
typedef unsigned char un8bits;//Unsign 8 bits
typedef char sn8bits;//Sign 8 bits
typedef unsigned short un16bits;//Unsign 16 bits
typedef short sn16bits;//Sign 16 bits
typedef unsigned long un32bits;//Unsign 32 bits
typedef long sn32bits;//Sign 32 bits
typedef unsigned long long un64bits;//Unsign 64 bits
typedef signed long long sn64bits;//Sign 64 bits
typedef float Xfloat32;
typedef double Xfloat64;
typedef unsigned long Xboolean;
#define UART_ADDRESS XPAR_PS7_UART_1_BASEADDR
#define D5M_BASE XPAR_PS_VIDEO_D5M_VIDEOPROCESS_CONFIG_AXIS_BASEADDR
