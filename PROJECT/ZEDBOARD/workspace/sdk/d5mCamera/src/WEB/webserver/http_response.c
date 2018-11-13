#include <lwip/err.h>
#include <lwip/tcp.h>
#include <stdio.h>
#include <string.h>
#include <xil_printf.h>
#include <xil_types.h>
#include <xilmfs.h>
#include "../../D5M/HDMI_DISPLAY/hdmi_display.h"
#include "../../D5M/I2C_D5M/i2c_d5m.h"
#include "../../D5M/MENU_CALLS/menu_calls.h"
#include "platform_gpio.h"
#include "webserver.h"
hdmi_display_start pvideo;
#define LEDS_TOGGLE XPAR_LEDS_8BITS_BASEADDR
#define D5MBASE XPAR_PS_VIDEO_D5M_VIDEOPROCESS_CONFIG_AXIS_BASEADDR
    static u16 value;
    static u32 exposer;
    static u16 g1_gain;
    static u16 g2_gain;
    static u16 b_gain;
    static u16 r_gain;
    char *notfound_header =
    "<html> \
    <head> \
    <title>404</title> \
    <style type=\"text/css\"> \
    div#request {background: #eeeeee} \
    </style> \
    </head> \
    <body> \
    <h1>404 Page Not Found</h1> \
    <div id=\"request\">";
    char *notfound_footer =
    "</div> \
    </body> \
    </html>";
    int fk1,fk2;
    float f1,f2;
    char num1[20]="\0",num2[20]="\0";
    int GENERATE_HTTP_HEADER(char *buf, char *fext, int fsize);
    int mfs_file_read(int fd, char *buf, int buflen);
int DO_404(struct tcp_pcb *pcb, char *req, int rlen)
{
    int len, hlen;
    int BUFSIZE = 1024;
    char buf[BUFSIZE];
    err_t err;
    len = strlen(notfound_header) + strlen(notfound_footer) + rlen;
    hlen = GENERATE_HTTP_HEADER((char *)buf, "html", len);
    if (tcp_sndbuf(pcb) < hlen)
    {
        xil_printf("cannot send 404 message, tcp_sndbuf = %d bytes, message length = %d bytes\r\n",
        tcp_sndbuf(pcb), hlen);
        return -1;
    }
    if ((err = tcp_write(pcb, buf, hlen, 1)) != ERR_OK)
    {
        xil_printf("%s: error (%d) writing 404 http header\r\n", __FUNCTION__, err);
        return -1;
    }
    tcp_write(pcb, notfound_header, strlen(notfound_header), 1);
    tcp_write(pcb, req, rlen, 1);
    tcp_write(pcb, notfound_footer, strlen(notfound_footer), 1);
    return 0;
}
void REVERSE(char *str, int len)
{
    int i=0, j=len-1, temp;
    while (i<j)
    {
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
        i++; j--;
    }
}
int INT_TO_STR(int x, char str[], int d)
{
   int i = 0;
   while (x)
   {
       str[i++] = (x%10) + '0';
       x = x/10;
   }
   while (i < d)
   str[i++] = '0';
   REVERSE(str, i);
   str[i] = '\0';
   return i;
}
void FLOATING_POINT_ASSERT(int n, char *res, int afterpoint)
{
   INT_TO_STR(n, res, 0);
}
void FLOATING_POINT_NUMBER_AFTERPOINT(float n, char *res, int afterpoint)
{
    int ipart = (int)n;
    float fpart = n - (float)ipart;
    int i = INT_TO_STR(ipart, res, 0);
    if (afterpoint != 0)
    {
        res[i] = '.';
        fpart = fpart * 10* 10*afterpoint;
        INT_TO_STR((int)fpart, res + i + 1, afterpoint);
    }
} 
float STRING_TO_FLOATING_POINT_NUMBER(const char* s){
float rez = 0, fact = 1;
    /* ACTION: - ************************************/
    if (*s == '-')
    {
        s++;
        fact = -1;
    };
    /************************************************/
  int point_seen=0;
  /* AFTER REACTION: . ****************************/
  for (point_seen = 0; *s; s++)
  {
    if (*s == '.')
    {
        point_seen = 1;
        continue;
    };
    int d = *s - '0';
    if (d >= 0 && d <= 9)
    {
        if (point_seen) fact /= 10.0f;
        rez = rez * 10.0f + (float)d;
    };
  };
  /************************************************/
  return rez * fact;
}
int STRING_TO_NUMBERS(const char* s){
int rez = 0, fact = 1;
int point_seen=0;
  /* AFTER REACTION: . ****************************/
  for (point_seen = 0; *s; s++)
  {
        if (*s == '.')
        {
            point_seen = 1;
            continue;
        };
    int d = *s - '0';
    if (d >= 0 && d <= 9)
    {
        rez = rez + (int)d;
    };
  };
  /************************************************/
  return rez * fact;
}
int STRING_TO_NUMBER(const char* s){
    int rez = 0, fact = 1;
        /* ACTION: - ************************************/
        if (*s == '-')
        {
            s++;
            fact = -1;
        };
        /************************************************/
      int point_seen=0;
      /* AFTER REACTION: . ****************************/
      for (point_seen = 0; *s; s++)
      {
        if (*s == '.')
        {
            point_seen = 1;
            continue;
        };
        int d = *s - '0';
        if (d >= 0 && d <= 9)
        {
            rez = rez * 10 + (int)d;
        };
      };
      /************************************************/
      return rez * fact;
}
unsigned volatile char * CONVERT_CHAR_S(char *str)
{
    int i,j,cx=0,cnt=0;
    for(i=0;str[i];i++)
    {
        if(str[i]=='/')
        {
            for(j=i+1;str[j];j++)
            {
                num2[cx]=str[j];
                cx++;
                if(str[j]==' ')
                {
                    cx=1;
                    break;
                }
            }
            cnt++;
        }
        if(cnt>=1)
        {
            break;
        }
        num1[i]=str[i];
    }
f1=STRING_TO_FLOATING_POINT_NUMBER(num1);
f2=STRING_TO_FLOATING_POINT_NUMBER(num2);
}
unsigned volatile char * UNPACK(char *str)
{
    int i,j,cx=0,cnt=0;
    for(i=0;str[i];i++)
    {
        if(str[i]=='/')
        {
            for(j=i+1;str[j];j++)
            {
                num2[cx]=str[j];
                cx++;
                if(str[j]==' ')
                {
                    cx=1;
                    break;
                }
            }
            cnt++;
        }
        if(cnt>=1)
        {
            break;
        }
        num1[i]=str[i];
    }
fk1=STRING_TO_NUMBER(num1);
fk2=STRING_TO_NUMBER(num2);
}
void TOGGLE_TASK()
{
    *(volatile unsigned int*)LEDS_TOGGLE=0x03;
    *(volatile unsigned int*)LEDS_TOGGLE=0x0c;
    *(volatile unsigned int*)LEDS_TOGGLE=0x30;
    *(volatile unsigned int*)LEDS_TOGGLE=0xc0;
    *(volatile unsigned int*)LEDS_TOGGLE=0x30;
    *(volatile unsigned int*)LEDS_TOGGLE=0x0c;
    *(volatile unsigned int*)LEDS_TOGGLE=0x03;
}
int DO_HTTP_POST(struct tcp_pcb *pcb, char *req, int rlen)
{
    /*Locals*/
    unsigned int Button = 0;
    unsigned int value;
    int BUFSIZE = 1024;
    unsigned char buf[BUFSIZE];
    int n;
    int len;
    char *p;
    static char res[20];
    Button = GET_SWITCH_STATE();
    if(Button==0)
    {
    /* CONTROLLING/OBTAINING/STATUS
    RAW ADC VALUES IN BINARY FORMAT
    SERVER_RESPONSE : CMD_PL_PS_STREAMER_ASSERT
    */
        if(CMD_PL_PS_STREAMER_ASSERT(req+6))
        {
            static char ress[20];
            read_adc_channels(&interrupt);
            unsigned s = (((0x0000ff& D5M_mReadReg(D5MBASE,124))<<16)|((D5M_mReadReg(D5MBASE,120) & 0x0000ff)<<8)|(0x0000ff & D5M_mReadReg(D5MBASE,116)));
            sprintf(ress,"%d", s);
            char *json_response = ress;
            //adcchannels();
            if (s != (((0x0000ff& D5M_mReadReg(D5M_BASE,124))<<16)|((D5M_mReadReg(D5M_BASE,120) & 0x0000ff)<<8)|(0x0000ff & D5M_mReadReg(D5M_BASE,116))))
            {
            	xil_printf(" %d\n\r", s);
            	//printf("Powered On Time %d:%d:%d\n\r",(unsigned) ((pvideo.time & 0xff0000)>>16),(unsigned) ((pvideo.time & 0x00ff00)>>8),(unsigned) (pvideo.time & 0x0000ff));
            }
            len = GENERATE_HTTP_HEADER(buf, "js", 4);
            p = buf + len;
            strcpy(p, json_response);
            len += strlen(json_response);
        }
    }
    /* CONTROLLING/OBTAINING/STATUS
       RAW ADC VALUES IN BINARY FORMAT
       SERVER_RESPONSE : CMD_PL_PS_STREAMER_ASSERT
    */
    if(Button==2)
    {
        if(CMD_PL_PS_STREAMER_ASSERT(req+6))
        {
        unsigned s = rch00signal();
        int n_switches = 21;
        char *json_response = "PL_PS_STREAMER_ASSERT";
        xil_printf("ADC_DATA: %d\n\r", s);
        len = GENERATE_HTTP_HEADER(buf, "js", n_switches);
        p = buf + len;
        #if 1
            for (n = 0; n < n_switches; n++, p++) {
            *p = '0' + (s & 0x1);
            s >>= 1;
        }
            *p = 0;
            len += n_switches;
        #else
            strcpy(p, json_response);
            len += strlen(json_response);
        #endif
        }
    }
    /* CONTROLLING/OBTAINING/STATUS
       ASSERT LEDS HIGH FROM CLIENT REQUEST
       SERVER_RESPONSE : CMD_PL_PS_STREAMER_LED_ON
    */
    if(CMD_PL_PS_STREAMER_LED_ON(req+6))
    {
        unsigned s = rch00signal();
        *(volatile unsigned int*)LEDS_TOGGLE=0xFF;
        char *json_response = "PL_PS_STREAMER_LED_ON";
        xil_printf("http POST: switch state: %x\n\r", s);
        /* Assert High Freq on SW-1 */
        //WRITE_FREQHIGH_SINE_WAVE();
        WRITE_SW1_SINE_WAVE();
        len = GENERATE_HTTP_HEADER(buf, "js", 21);
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
    }
    /* CONTROLLING/OBTAINING/STATUS
       ASSERT LEDS LOW FROM CLIENT REQUEST
       SERVER_RESPONSE : CMD_PL_PS_STREAMER_LED_OFF
    */
    if(CMD_PL_PS_STREAMER_LED_OFF(req+6))
    {
        unsigned s = rch00signal();
        *(volatile unsigned int*)LEDS_TOGGLE=0x0;
        char *json_response = "PL_PS_STREAMER_LED_OFF";
        xil_printf("http POST: switch state: %x\n\r", s);
        /*ASSERT LOW FREQ ON SW-0 */
        //WRITE_FREQLOW_SINE_WAVE();
        /* CONTROLLING/OBTAINING/STATUS
        TOGGLE LEDS FROM CLIENT REQUEST 
        SERVER_RESPONSE : CMD_PL_PS_STREAMER_LED_PAT
        */
        WRITE_SW0_SINE_WAVE();
        len = GENERATE_HTTP_HEADER(buf, "js", 22);
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
    }
    /* CONTROLLING/OBTAINING/STATUS
       TOGGLE LEDS FROM CLIENT REQUEST
       SERVER_RESPONSE : CMD_PL_PS_STREAMER_LED_PAT
    */
    if(CMD_PL_PS_STREAMER_LED_PAT(req+6))
    { 
        TOGGLE_TASK();
        char *json_response = "PL_PS_STREAMER_LED_PAT";
        xil_printf("PL_PS_STREAMER_LED_PAT\n\r");
        len = GENERATE_HTTP_HEADER(buf, "js", 22);
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
    }
    /* CONTROLLING/OBTAINING/STATUS
       ADD TWO GIVEN VALUES FROM CLIENT
       SERVER_RESPONSE : CMD_PL_LW_FEQ
    */
    if(CMD_PL_LW_FEQ(req+6))
    {
        char buf1[1400] __attribute__ ((unused)) __attribute__((optimize("O0")));
        static char temp[20];
        char str[100];
        strcpy(str,req+17);
        UNPACK(str);
        int fl=fk1;
        int fh=fk2;
        WRITE_FREQLOW(fl);//slv_reg2
        WRITE_FREQHIGH(fh);//slv_reg1
        xil_printf("CMD_PL_LW_FEQ =  %d\n\r",fl);
        xil_printf("CMD_PL_HI_FEQ =  %d\n\r",fh);
        xil_printf("-------------------\n\r");
        sprintf(temp,"%d", fl);
        char *json_response = temp;
        len = GENERATE_HTTP_HEADER(buf, "js", strlen(temp));
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
        strncpy(num1,"\0",20);
        strncpy(num2,"\0",20);
        strncpy(temp,"\0",20);
        //*(volatile unsigned int*)LEDS_TOGGLE=fh;
    }
    /* CONTROLLING/OBTAINING/STATUS
       ADD TWO GIVEN VALUES FROM CLIENT
       SERVER_RESPONSE : CMD_PS_FP_ADD
    */
    if(CMD_PS_FP_ADD(req+6))
    {
        char buf1[1400] __attribute__ ((unused)) __attribute__((optimize("O0")));
        char str[100];
        strcpy(str,req+17);
        CONVERT_CHAR_S(str);
        float add=f1+f2;
        FLOATING_POINT_NUMBER_AFTERPOINT(add, res, 6);
        xil_printf("-------------------\n\r");
        xil_printf("CMD:CMD_PS_FP_ADD\n\r");
        xil_printf("-------------------\n\r");
        xil_printf("Value1 : %f\n\r",f1);
        xil_printf("Value1 : %f\n\r",f2);
        xil_printf("SUM Length : %d\n\r",strlen(res));
        xil_printf("SUM %f\n\r",res);
        char *json_response = res;
        xil_printf("-------------------\n\r");
        len = GENERATE_HTTP_HEADER(buf, "js", strlen(res));
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
        strncpy(num1,"\0",20);
        strncpy(num2,"\0",20);
        strncpy(res,"\0",20);
    }
    /* CONTROLLING/OBTAINING/STATUS
       SUBTRACT TWO GIVEN VALUES FROM CLIENT
       SERVER_RESPONSE : CMD_PS_FP_SUB
    */
    if(CMD_PS_FP_SUB(req+6))
    {
        int min=0;;
        char tbuf[15],str[100];
        strcpy(str,req+17);
        CONVERT_CHAR_S(str);
        float sub=f1-f2;
        if(sub<0)
        {
            sub=-sub;
            min++;
        }
        FLOATING_POINT_NUMBER_AFTERPOINT(sub, res, 6);
        if(min==1)
        {
            strcpy(tbuf,"-");
            strcat(tbuf,res);
            min=0;
            memset(res, 0, 20);
            strcpy(res,tbuf);
        }
        char *json_response = res;
        xil_printf("-------------------\n\r");
        xil_printf("CMD:CMD_PS_FP_SUB\n\r");
        xil_printf("-------------------\n\r");
        xil_printf("SUB Length : %d\n\r",strlen(res));
        xil_printf("SUB %s\n\r",res);
        len = GENERATE_HTTP_HEADER(buf, "js", strlen(res));
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
        strncpy(num1,"\0",20);
        strncpy(num2,"\0",20);
        strncpy(res,"\0",20);
    }
    /* CONTROLLING/OBTAINING/STATUS
       MULTIPLY TWO GIVEN VALUES FROM CLIENT
       SERVER_RESPONSE : CMD_PS_FP_MUL
    */
    if(CMD_PS_FP_MUL(req+6))
    {
        char str[100];
        strcpy(str,req+17);
        CONVERT_CHAR_S(str);
        float mul=f1*f2;
        FLOATING_POINT_NUMBER_AFTERPOINT(mul, res, 6);
        char *json_response = res;
        xil_printf("-------------------\n\r");
        xil_printf("CMD:CMD_PS_FP_MUL\n\r");
        xil_printf("-------------------\n\r");
        xil_printf("MUL Length : %d\n\r",strlen(res));
        xil_printf("MUL %s\n\r",res);
        len = GENERATE_HTTP_HEADER(buf, "js", strlen(res));
        p = buf + len;
        strcpy(p, json_response);
        len += strlen(json_response);
        strncpy(num1,"\0",20);
        strncpy(num2,"\0",20);
        strncpy(res,"\0",20);
    }
    /*Assert Error Print When there is a tcp write issue*/
    if (tcp_write(pcb, buf, len, 1) != ERR_OK)
    {
        xil_printf("error writing http POST response to socket\n\r");
        xil_printf("http header = %s\r\n", buf);
        return -1;
    }
    return 0;
}
int DO_HTTP_GET(struct tcp_pcb *pcb, char *req, int rlen)
{
    int BUFSIZE = 1400;
    char filename[MAX_FILENAME];
    unsigned char buf[BUFSIZE];
    signed int fsize, hlen, n;
    int fd;
    char *fext;
    err_t err;
    extract_file_name(filename, req, rlen, MAX_FILENAME);
    if (mfs_exists_file(filename) != 1)
    {
        xil_printf("requested file %s not found, returning 404\r\n", filename);
        DO_404(pcb, req, rlen);
        return -1;
    }
    xil_printf("Initializing DO_HTTP_GET \r\n");
    fext = get_file_extension(filename);
    fd = mfs_file_open(filename, MFS_MODE_READ);
    if (fd == -1)
    {
        platform_init_fs();
        extract_file_name(filename, req, rlen, MAX_FILENAME);
        if (mfs_exists_file(filename) != 1)
        {
            xil_printf("requested file %s not found, returning 404\r\n", filename);
            DO_404(pcb, req, rlen);
            return -1;
        }
        fext = get_file_extension(filename);
        fd = mfs_file_open(filename, MFS_MODE_READ);
        return -1;
    }
    fsize = mfs_file_lseek(fd, 0, MFS_SEEK_END);
    if (fsize == -1)
    {
        xil_printf("\r\nFile Read Error\r\n");
        return -1;
    }
    hlen = GENERATE_HTTP_HEADER((char *)buf, fext, fsize);
    if ((err = tcp_write(pcb, buf, hlen, 3)) != ERR_OK)
    {
        xil_printf("error (%d) writing http header to socket\r\n", err);
        xil_printf("attempted to write #bytes = %d, tcp_sndbuf = %d\r\n", hlen, tcp_sndbuf(pcb));
        xil_printf("http header = %s\r\n", buf);
        return -1;
    }
    tcp_output(pcb);
    while (fsize > 0)
    {
        int sndbuf;
        sndbuf = tcp_sndbuf(pcb);
        if (sndbuf < BUFSIZE)
        {
            http_arg *a = (http_arg *)pcb->callback_arg;
            a->fd = fd;
            a->fsize = fsize;
            return -1;
        }
        n = mfs_file_read(fd, (char *)buf, BUFSIZE);
        if ((err = tcp_write(pcb, buf, n, 3)) != ERR_OK)
        {
            xil_printf("error writing file (%s) to socket, remaining unwritten bytes = %d\r\n",
            filename, fsize - n);
            xil_printf("attempted to lwip_write %d bytes, tcp write error = %d\r\n", n, err);
            break;
        }
        tcp_output(pcb);
        if (fsize >= n)
            fsize -= n;
        else
            fsize = 0;
    }
    mfs_file_close(fd);
    return 0;
}
enum HTTP_REQ_TYPE { HTTP_GET, HTTP_POST, HTTP_UNKNOWN };
enum HTTP_REQ_TYPE decode_http_request(char *req, int l)
{
    char *get_str = "GET";
    char *post_str = "POST";
    if (!strncmp(req, get_str, strlen(get_str)))
    return HTTP_GET;
    if (!strncmp(req, post_str, strlen(post_str)))
    return HTTP_POST;
    return HTTP_UNKNOWN;
}
//void DUMP_PAYLOAD(char *p, int len)
//{
//    int i, j;
//    for (i = 0; i < len; i+=16)
//    {
//        for (j = 0; j < 16; j++)
//        xil_printf("%c ", p[i+j]);
//        xil_printf("%d ", p[i+j]);
//        xil_printf("%d ", p[i]);
//        xil_printf("%d ", p[j]);
//        xil_printf("\r\n");
//    }
//
//    xil_printf("total len = %d\r\n", len);
//
//    //d5m();
//
//}
void DUMP_PAYLOAD(char *p, int len)
{
int i;
for (i = 0; i < len; i+=16)
{
        value =p[i];
}
D5M_mWriteReg(D5M_BASE,REG4,value);
if(value==0)
{
	camera_hdmi_config();
}
if(value==1){
	exposer=0x800;
    g1_gain=2;
    g2_gain=2;
    b_gain=3;
    r_gain=3;
	xil_printf("01.Set to RGB 444 Mode\n\r");
}
if(value==2)
{
    g1_gain=2;
    g2_gain=2;
    b_gain=3;
    r_gain=3;
	exposer=800;
	xil_printf("02.Set to YCbCr 4:2:2 Mode\n\r");
}
if(value==3)
{
	exposer = exposer + 0x32;
	camera_exposer(exposer);
	xil_printf("03.exposer+50 Mode %d\n\r", exposer);
}
if(value==4)
{
	exposer = exposer - 0x32;
	camera_exposer(exposer);
	xil_printf("04.exposer-50 %d\n\r", exposer);
}
if(value==5)
{
	g1_gain++;
	img_write_register(43,g1_gain);//Green1 Gain
	xil_printf("05.Updated g1_gain+1 %d\n\r", g1_gain);
}
if(value==6)
{
	b_gain++;
	img_write_register(44,b_gain);//Blue Gain
	xil_printf("06.Updated b_gain+1 %d\n\r", b_gain);
}
if(value==7)
{
	r_gain = r_gain + 0x1;
	img_write_register(45,r_gain);//Red Gain
	xil_printf("07.Updated r_gain+1 %d\n\r", r_gain);
}
if(value==8)
{
	g2_gain = g2_gain + 0x1;
	img_write_register(46,g2_gain);//Green2 Gain
	xil_printf("08.Updated g2_gain+1 %d\n\r", g2_gain);
}
if(value==9)
{
	g1_gain = g1_gain - 0x1;
	img_write_register(43,g1_gain);//Green1 Gain
	xil_printf("09.Updated g1_gain-1 %d\n\r", g1_gain);
}
if(value==10)
{
	b_gain = b_gain - 0x1;
	img_write_register(44,b_gain);//Blue Gain
	xil_printf("10.Updated b_gain-1 %d\n\r", b_gain);
}
if(value==11)
{
	r_gain = r_gain - 0x1;
	img_write_register(45,r_gain);//Red Gain
	xil_printf("11.Updated r_gain-1 %d\n\r", r_gain);
}
if(value==12)
{
	g2_gain = g2_gain - 0x1;
	img_write_register(46,g2_gain);//Green2 Gain
	xil_printf("12.Updated g2_gain-1 %d\n\r", g2_gain);
}
    xil_printf("\r\n");
}
int GENERATE_RESPONSE(struct tcp_pcb *pcb, char *http_req, int http_req_len)
{
    enum HTTP_REQ_TYPE request_type = decode_http_request(http_req, http_req_len);
    switch(request_type)
    {
        case HTTP_GET:
        return DO_HTTP_GET(pcb, http_req, http_req_len);
        case HTTP_POST:
        return DO_HTTP_POST(pcb, http_req, http_req_len);
        default:
        xil_printf("Config D5M Camera\r\n");
        DUMP_PAYLOAD(http_req, http_req_len);
        return DO_404(pcb, http_req, http_req_len);
    }
}
