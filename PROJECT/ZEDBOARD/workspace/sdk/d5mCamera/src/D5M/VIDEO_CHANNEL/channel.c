#include <xil_types.h>
#include <stdio.h>
#include <xil_io.h>
#include "../MENU_CALLS/menu_calls.h"
#include "channel.h"
#include "../SYSTEM_CONFIG_HEADER/system_config_header.h"
#include "../MENU_CALLS/menu_calls.h"
#include "../HDMI_DISPLAY/hdmi_display.h"
#include "../I2C_D5M/i2c_d5m.h"
hdmi_display_start pvideo;
void edgeThreshold(u16 thresholdValue)
{
    D5M_mWriteReg(D5M_BASE,REG5,thresholdValue);
}
void videoFeatureSelect(u16 videoType)
{
    D5M_mWriteReg(D5M_BASE,REG6,videoType);
}
void ycbcrSelect(u16 videoType)
{
    D5M_mWriteReg(D5M_BASE,REG7,videoType);
}
void color_correction(u16 videoType)
{
    D5M_mWriteReg(D5M_BASE,REG8,videoType);
}
void point_Interest(u16 videoType)
{
    D5M_mWriteReg(D5M_BASE,REG19,videoType);
}
void deltaConfig(u16 videoType)
{
    D5M_mWriteReg(D5M_BASE,REG20,videoType);
}
void framefifoMode(u16 fifoMode)
{
    D5M_mWriteReg(D5M_BASE,REG21,fifoMode);
}
void frameReadData()
{
    pvideo.fifoData    = D5M_mReadReg(D5M_BASE,REG1);//gridLockDatao
    printf("pvideo.fifoData %d\n\r",(unsigned) (pvideo.fifoData));
}
void fifoStatus()
{
    pvideo.lockData    = D5M_mReadReg(D5M_BASE,REG2);
    pvideo.fifoEmptyh  = D5M_mReadReg(D5M_BASE,REG3);
    pvideo.fifoFullh   = D5M_mReadReg(D5M_BASE,REG4);
    pvideo.cpuGridCont = D5M_mReadReg(D5M_BASE,REG5);
    printf("pvideo.lockData %d\n\r",(unsigned) (pvideo.lockData));
    printf("pvideo.fifoEmptyh %d\n\r",(unsigned) (pvideo.fifoEmptyh));
    printf("pvideo.fifoFullh %d\n\r",(unsigned) (pvideo.fifoFullh));
    printf("pvideo.cpuGridCont %d\n\r",(unsigned) (pvideo.cpuGridCont));
}
void edgeType(u16 edgeTypeValue)
{
    if (edgeTypeValue == 1) {
        sobel();
    }else{
        prewitt();
    }
}
void selected_channel()
{
    // 0 - RGB Video
    // 1 - RGB-Vertical PATTERN
    // 2 - RGB-Horizonat PATTERN
    u16 videoPLTest =0x0004;
    u16 thresholdValue =0x0007;
    // 0 - Edge BLACK WHITE
    // 1 - Video-EDGE ALONG RGB
    // 2 - Detector-Video
    // 3 - Sharp Video
    // 4 - normal Video
    u16 videoType =0x0003;
    u16 RedRange =0xE61E;
    u16 GreenRange =0x961E;
    u16 BlueRange =0x961E;
    //    u16 RedRange =0x0000;
    //    u16 GreenRange =0x0000;
    //    u16 BlueRange =0x0000;
    D5M_mWriteReg(D5M_BASE,REG1,RedRange);//cord
    D5M_mWriteReg(D5M_BASE,REG2,GreenRange);//cord
    D5M_mWriteReg(D5M_BASE,REG3,BlueRange);//cord
    D5M_mWriteReg(D5M_BASE,REG4,videoPLTest);
    edgeThreshold(thresholdValue);
    prewitt();
    videoFeatureSelect(videoType);
}
void sobel()
{
    u32 KernelEnable = 0x01FF;
    //  GX
    //  [-1 +0 +1]
    //  [-2 +0 +2]
    //  [-1 +0 +1]
    //  GY
    //  [+1 +2 +1]
    //  [+0 +0 +0]
    //  [-1 -2 -1]
                          //  GY  GX
    u16 Kernel_1 = 0x01FF;//  +1  -1
    u16 Kernel_2 = 0x0200;//  +2  +0
    u16 Kernel_3 = 0x0101;//  +1  -1
    u16 Kernel_4 = 0x00FE;//  +0  -2
    u16 Kernel_5 = 0x0000;//  +0  +0
    u16 Kernel_6 = 0x0002;//  +0  +2
    u16 Kernel_7 = 0xFFFF;//  -1  -1
    u16 Kernel_8 = 0xFE00;//  -2  +0
    u16 Kernel_9 = 0xFF01;//  -1  +1
    D5M_mWriteReg(D5M_BASE,RegKernel_1,Kernel_1);
    D5M_mWriteReg(D5M_BASE,RegKernel_2,Kernel_2);
    D5M_mWriteReg(D5M_BASE,RegKernel_3,Kernel_3);
    D5M_mWriteReg(D5M_BASE,RegKernel_4,Kernel_4);
    D5M_mWriteReg(D5M_BASE,RegKernel_5,Kernel_5);
    D5M_mWriteReg(D5M_BASE,RegKernel_6,Kernel_6);
    D5M_mWriteReg(D5M_BASE,RegKernel_7,Kernel_7);
    D5M_mWriteReg(D5M_BASE,RegKernel_8,Kernel_8);
    D5M_mWriteReg(D5M_BASE,RegKernel_9,Kernel_9);
    D5M_mWriteReg(D5M_BASE,KernalConfig,KernelEnable);
}
void prewitt()
{
    u32 KernelEnable = 0x01FF;
    //  GX
    //  [+1 +0 -1]
    //  [+1 +0 -1]
    //  [+1 +0 -1]
    //  GY
    //  [+1 +1 +1]
    //  [+0 +0 +0]
    //  [-1 -1 -1]
                           //  GY  GX
    u16 KernelPv1 = 0x01FF;//  +1  -1
    u16 KernelPv2 = 0x0100;//  +1  +0
    u16 KernelPv3 = 0x0101;//  +1  -1
    u16 KernelPv4 = 0x00FF;//  +0  -1
    u16 KernelPv5 = 0x0000;//  +0  +0
    u16 KernelPv6 = 0x0001;//  +0  -1
    u16 KernelPv7 = 0xFFFF;//  -1  -1
    u16 KernelPv8 = 0xFF00;//  -1  +0
    u16 KernelPv9 = 0xFF01;//  -1  +1
    D5M_mWriteReg(D5M_BASE,RegKernel_1,KernelPv1);
    D5M_mWriteReg(D5M_BASE,RegKernel_2,KernelPv2);
    D5M_mWriteReg(D5M_BASE,RegKernel_3,KernelPv3);
    D5M_mWriteReg(D5M_BASE,RegKernel_4,KernelPv4);
    D5M_mWriteReg(D5M_BASE,RegKernel_5,KernelPv5);
    D5M_mWriteReg(D5M_BASE,RegKernel_6,KernelPv6);
    D5M_mWriteReg(D5M_BASE,RegKernel_7,KernelPv7);
    D5M_mWriteReg(D5M_BASE,RegKernel_8,KernelPv8);
    D5M_mWriteReg(D5M_BASE,RegKernel_9,KernelPv9);
    D5M_mWriteReg(D5M_BASE,KernalConfig,KernelEnable);
}
void computeBrightness() {
    int offset;
    u32 address = VIDEO_BASEADDR0;
    pvideo.brightness =0;
    int buffer_error_colms = 8;
    int x,y;
      for ( y = 8; y < SCREEN_HEIGHT_VERTICAL; y++ )
      {
         for ( x = 0; x < SCREEN_WIDTH_HORIZONTAL*2; x++ )
         {
                pvideo.pixelvalue = (Xil_In16(address) & 0xffff);
            address = address + 0x2;
            if(y>buffer_error_colms)
            {
                if (pvideo.pixelvalue > pvideo.brightness)
                {
                    pvideo.brightness = pvideo.pixelvalue;
                }
            }
         }
        // printf("address[data]:%i     %i    %i\n",y,(unsigned)pvideo.pixelvalue, (unsigned)pvideo.brightness);
      }
}
void pRbrightness(){
    computeBrightness();
    printf("computedBrightnes :%i\n",(unsigned)pvideo.brightness);
}
void exposerCompansate(){
    pRexposer();
    pRbrightness();
        if(pvideo.brightness > 120)
        {
            camera_exposer(400);
        }
        else if(pvideo.brightness > 110)
        {
            camera_exposer(600);
        }
        else
        {
            camera_exposer(800);
        }
        pRexposer();
        pRbrightness();
}
