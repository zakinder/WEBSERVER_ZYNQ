#ifndef __CHANNEL_H__
#define __CHANNEL_H__

#include <xil_types.h>

#define RegKernel_1   32
#define RegKernel_2   36
#define RegKernel_3   40
#define RegKernel_4   44
#define RegKernel_5   48
#define RegKernel_6   52
#define RegKernel_7   56
#define RegKernel_8   60
#define RegKernel_9   64
#define KernalConfig  68

void sobel();
void prewitt();
void computeBrightness();
void pRbrightness();
void selected_channel();
void edgeThreshold(u16 thresholdValue);
void videoFeatureSelect(u16 videoType);
void edgeType(u16 edgeTypeValue);
void color_correction(u16 videoType);
void ycbcrSelect(u16 videoType);
void deltaConfig(u16 videoType);
void framefifoMode(u16 fifoMode);
void point_Interest(u16 videoType);
void frameReadData();
void fifoStatus();
#endif // __CHANNEL_H__
