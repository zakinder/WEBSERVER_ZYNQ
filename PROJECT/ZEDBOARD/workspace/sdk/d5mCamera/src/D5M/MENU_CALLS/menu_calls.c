#include "menu_calls.h"
#include <stdio.h>
#include <xil_io.h>
#include "../HDMI_DISPLAY/hdmi_display.h"
#include "../I2C_D5M/i2c_d5m.h"
#include "../UART/uartio.h"
#include "../UART/utilities.h"
#include "../VIDEO_CHANNEL/channel.h"
hdmi_display_start pvideo;
d5m_rreg d5m_rreg_ptr;
void menu_calls(ON_OFF) {
    int menu_calls_enable = ON_OFF;
    unsigned int uart_io;
    u32 current_state = mainmenu;
    int ret;
    u32 cmd_status_value;
    u32 cmd_status_substate;
    u32 address;
    u32 value;
    u32 red_value;
    u32 temp1Register;
    u32 temp2Register;
    u32 green_value;
    u32 blue_value;
    u32 th_set;
    u16 sec;
    u16 min;
    u32 hr;
    u32 system_time;
    while (menu_calls_enable == TRUE) {
        switch (current_state) {
        case mainmenu:
            temp1Register =0x00000000;
            temp2Register =0x00000000;
            exposerCompansate();
            cmds_menu();
            current_state = menu_select;
            break;
        case menu_select:
            uart_io = uart_prompt_io();
            if (uart_io == 0) {
                uart_Red_Text();
                printf("Unknown command entered %x\r\n",(unsigned) uart_io);
                printf("\r>>");
                uart_Default_Text();
                break;
            } else {
                uart_Default_Text();
                current_state = uart_io;
                break;
            }
            break;
        case clear:
            /*****************************************************************************************************************/
            menu_cls();
            current_state = mainmenu;break;
        case xbright:
            /*****************************************************************************************************************/
        	computeBrightness();
        	printf("Compute Brightness[%i]\n", (unsigned)pvideo.brightness);
            cmd_status_substate = enter_value_or_quit("xbright",xbright);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case genimage:
            /*****************************************************************************************************************/
            buffer_vdma_hdmi(&pvideo);
            cmd_status_substate = enter_value_or_quit("genimage",genimage);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case zoom:
            /*****************************************************************************************************************/
            d5m_config3();
            camerarUpdate();
            cmd_status_substate = enter_value_or_quit("zoom",zoom);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_exposer:
            /*****************************************************************************************************************/
            cmd_status_value = enter_value_or_quit("null",cmds_exposer);camera_exposer(cmd_status_value);
            cmd_status_substate = enter_value_or_quit("cmds_exposer",cmds_exposer);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case d5m_testpattern:
            /*****************************************************************************************************************/
            cmd_status_value = enter_value_or_quit("null",d5m_testpattern);d5mtestpattern(cmd_status_value);
            cmd_status_substate = enter_value_or_quit("d5m_testpattern",d5m_testpattern);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case d5m_colorgain:
            /*****************************************************************************************************************/
            d5mcolorgain();
            cmd_status_substate = enter_value_or_quit("d5m_colorgain",d5m_colorgain);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_readexposer:
            /*****************************************************************************************************************/
            read_exposer_register();
            cmd_status_substate = enter_value_or_quit("cmds_readexposer",cmds_readexposer);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_readd5m:
            /*****************************************************************************************************************/
            camera_set_registers();
            cmd_status_substate = enter_value_or_quit("cmds_readd5m",cmds_readd5m);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_displaytype:
            /*****************************************************************************************************************/
            cmd_status_value = enter_value_or_quit("null",cmds_displaytype);
            D5M_mWriteReg(D5M_BASE,REG4,cmd_status_value);
            cmd_status_substate = enter_value_or_quit("cmds_displaytype",cmds_displaytype);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case colorbars:
            /*****************************************************************************************************************/
            colorBars_vdma_hdmi(&pvideo);
            cmd_status_substate = enter_value_or_quit("colorbars",colorbars);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_printpixel:
            /*****************************************************************************************************************/
            printf("Enter row Address\n");
            menu_print_prompt();
            temp1Register = uart_prompt_io();
            printf("Enter coloum Address\n");
            menu_print_prompt();
            temp2Register = uart_prompt_io();
            uart_io = 1;
            int offset;
            u32 address = VIDEO_BASEADDR0;
            if (uart_io == 1) {
            	int x,y;
                for ( y = 0; y < temp1Register; y++ )
                {
                   for ( x = 0; x < temp2Register*2; x+=16 )
                   {
          			for(offset=0;offset<8;offset++)
          			{
          				pvideo.pixelvalue = (Xil_In16(address+offset*2) & 0x00ff);
          			}
                    printf("address[%x]=%i\n",(unsigned) address,(unsigned) pvideo.pixelvalue);
                      address = address + 0x10;
                   }
                }
            }
            cmd_status_substate = enter_value_or_quit("cmds_printpixel",cmds_printpixel);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case cmds_updated5m:
            D5mReg(&d5m_rreg_ptr);
            cameraread(&d5m_rreg_ptr);
            printf("CMD\n");
            printf("updated5m\n");
            printf("Enter Address and Value\n");
            menu_print_prompt();
            address = uart_prompt_io();
            if (address == cmds_quit || address == 0) {current_state = mainmenu;break;}
            menu_print_prompt();
            value = uart_prompt_io();
            if (value == cmds_quit || address == 0) {current_state = mainmenu;break;}
            printf("address[%x],value[%x]\n",(unsigned) address,(unsigned) value);
            printf("Confirm Enter To Send Else Quit\n");
            printf("\r>>");
            uart_io = uart_prompt_io();
            if (uart_io == 0) {
                ret = img_write_register(address,value);
                if (!ret)
                {printf("ERROR : XST_FAILURE: %d\n" ,ret);}
                camerarUpdate();
                break;
            } else {current_state = mainmenu;break;}
        case cmds_configd5m:
            printf("Config Num\n");
            printf("Enter 1 for Config1\n");
            printf("Enter 2 for Config2 VGA_640x480p60\n");
            printf("Enter 3 for Config3 VGA_640x480p60 iZOOM_MODE\n");
            menu_print_prompt();
            value = uart_prompt_io();
            if (value == cmds_quit) {current_state = mainmenu;break;}
            printf("Config Value[%d]\n",(unsigned) value);
            printf("Confirm Enter To Send Else Quit\n");
            printf("\r>>");
            uart_io = uart_prompt_io();
            if (uart_io == 0) {
                if (value == 1) {
                    d5m_config1();
                    camerarUpdate();
                    break;
                }
                if (value == 2) {
                    d5m_config2();
                    camerarUpdate();
                    break;
                }
                if (value == 3) {
                    d5m_config3();
                    camerarUpdate();
                    break;
                }
            }else {current_state = mainmenu;break;}
        case vga:
            printf("Current State : camera_exposer\n");
            d5m_config2();
            camerarUpdate();
            current_state = mainmenu;
            break;
        case hdmi:
            printf("Current State : camera_exposer\n");
            camera_hdmi_config();
            current_state = mainmenu;
            break;
        case fullhdmi:
            printf("Current State : camera_exposer\n");
            camera_set_registers();
            current_state = mainmenu;
            break;
        case cmds_videochannel:
            printf("Enter edgeType Value\n");
            printf("1-sobel 2-prewitt\n");
            menu_print_prompt();
            temp1Register = uart_prompt_io();
            if (temp1Register == clear) {
            	current_state = mainmenu;
                break;}
        	edgeType(temp1Register);
            printf("Enter edgeThreshold Value\n");
            menu_print_prompt();
            temp1Register = uart_prompt_io();
            if (temp1Register == clear) {
            	current_state = mainmenu;
                break;}
        	edgeThreshold(temp1Register);
            printf("Enter videoType Value\n");
            menu_print_prompt();
            temp2Register = uart_prompt_io();
            if (temp2Register == clear) {
            	current_state = mainmenu;
                break;}else{
            	videoFeatureSelect(temp2Register);
            	current_state = cmds_videochannel;break;}
        case coord:
            /*****************************************************************************************************************/
            printf("Enter rRange\n");
            menu_print_prompt();
            red_value = uart_prompt_io();
            printf("Enter gRange\n");
            menu_print_prompt();
            green_value = uart_prompt_io();
            printf("Enter bRange\n");
            menu_print_prompt();
            blue_value = uart_prompt_io();
        	D5M_mWriteReg(D5M_BASE,REG1,red_value);
        	D5M_mWriteReg(D5M_BASE,REG2,green_value);
        	D5M_mWriteReg(D5M_BASE,REG3,blue_value);
            cmd_status_substate = enter_value_or_quit("coord",coord);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case threshold:
            /*****************************************************************************************************************/
        	th_set=0x00000000;
        	cmd_status_value=0x00000000;
            printf("Current State : threshold\n");
            cmd_status_value = enter_value_or_quit("null",threshold);
            th_set  = (((cmd_status_value & 0x000000ff)<<16) | 0x0000E61E);
            D5M_mWriteReg(D5M_BASE,REG1,th_set);
            printf("th_set1[%x]\n",(unsigned) th_set);
            printf("th_set2[%x]\n",(unsigned) ((th_set & 0xffff0000)>>16));
            cmd_status_substate = enter_value_or_quit("threshold",threshold);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case timex:
            /*****************************************************************************************************************/
            sec=D5M_mReadReg(D5M_BASE,REG30);
            min=D5M_mReadReg(D5M_BASE,REG31);
            hr=D5M_mReadReg(D5M_BASE,REG32);
            system_time=(((0x0000ff& D5M_mReadReg(D5M_BASE,REG32))<<16)|((D5M_mReadReg(D5M_BASE,REG31) & 0x0000ff)<<8)|(0x0000ff & D5M_mReadReg(D5M_BASE,REG30)));
            pvideo.time = (((0x0000ff& D5M_mReadReg(D5M_BASE,REG32))<<16)|((D5M_mReadReg(D5M_BASE,REG31) & 0x0000ff)<<8)|(0x0000ff & D5M_mReadReg(D5M_BASE,REG30)));
            uart_Yellow_Text();
            printf("%d:%d:%d\n\r",(unsigned) hr,(unsigned) min,(unsigned) sec);
            uart_Default_Text();
            cmd_status_substate = enter_value_or_quit("timex",timex);current_state = cmd_status_substate;break;
            /*****************************************************************************************************************/
        case quit:
        	menu_calls_enable = FALSE;
            break;
        case cmds_uart:
            uartvalue();
            current_state =uartcmd(mainmenu,cmds_uart);
            break;
        default:
            printf("\r\n");
            current_state = mainmenu;
            break;
        }
    }
    printf("Break\r\n");
    menu_calls_enable = TRUE;
}
