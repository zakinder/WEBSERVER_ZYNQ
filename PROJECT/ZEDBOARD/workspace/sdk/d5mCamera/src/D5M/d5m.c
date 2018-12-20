// LAST TESTED : 12/16/2018
#include <stdio.h>
#include <xparameters.h>
#include "HDMI_DISPLAY/hdmi_display.h"
#include "I2C_D5M/i2c_d5m.h"
#include "MENU_CALLS/menu_calls.h"
#include "SYSTEM_CONFIG_HEADER/system_config_header.h"
#include "VIDEO_CHANNEL/channel.h"
hdmi_display_start pvideo;
void d5m()
{
	camera_hdmi_config();
    pvideo.uBaseAddr_IIC_HdmiOut = XPAR_HDMI_OUTPUT_HDMI_IIC_BASEADDR;
    pvideo.uDeviceId_VTC_HdmioGenerator = XPAR_VIDEO_PIPELINE_TIMMING_CONTROLELR_DEVICE_ID;
    pvideo.uDeviceId_VDMA_HdmiDisplay = XPAR_AXIVDMA_0_DEVICE_ID;
    pvideo.video_address = VIDEO_BASEADDR0;
    pvideo.uNumFrames_HdmiDisplay = XPAR_AXIVDMA_0_NUM_FSTORES;
    pvideo.hdmio_resolution = VIDEO_RESOLUTION_1080P;
    pvideo.hdmio_width_Stride  = SCREEN_WIDTH_HORIZONTAL*2;
    pvideo.hdmio_height = SCREEN_HEIGHT_VERTICAL;
    pvideo.time = (((0x0000ff & D5M_mReadReg(D5M_BASE,REG32))<<16)|((D5M_mReadReg(D5M_BASE,REG31) & 0x0000ff)<<8)|(0x0000ff & D5M_mReadReg(D5M_BASE,REG30)));
    pvideo.exposer  = 0;
    pvideo.brightness = 0;
    pvideo.pixelvalue = 0;
    pvideo.sec = D5M_mReadReg(D5M_BASE,REG30);
    pvideo.min = D5M_mReadReg(D5M_BASE,REG31);
    pvideo.hr  = D5M_mReadReg(D5M_BASE,REG32);
    printf("%d:%d:%d\n\r",(unsigned) pvideo.hr,(unsigned) pvideo.min,(unsigned) pvideo.sec);
    //buffer_vdma_hdmi(&pvideo);
    //colorBars_vdma_hdmi(&pvideo);
    //bars(&pvideo);
    videoFeatureSelect(0x0004);
    d5m_vdma_hdmi(&pvideo);
    VdmaInit();
    selected_channel();
    pointInterestFixed();
    framefifoFixed();
    //d5mtestpattern(0x0004);
    //exposerCompansate();
}
