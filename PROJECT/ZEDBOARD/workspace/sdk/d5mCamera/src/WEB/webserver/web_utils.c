#include <stdio.h>
#include <string.h>
#include "webserver.h"
int IS_CMD_LED(char *buf)
{
    buf += 6;
    return (!strncmp(buf, "CMD", 3) && !strncmp(buf + 4, "LEDXHR", 6));
}
int IS_CMD_SWITCH(char *buf)
{
    buf += 6;
    return (!strncmp(buf, "CMD", 3) && !strncmp(buf + 4, "SWITCHXHR", 9));
}
int CMD_PL_PS_STREAMER_LED_ON(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"PL_PS_STREAMER_LED_ON",21));
}
int CMD_PL_PS_STREAMER_LED_PAT(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"PL_PS_STREAMER_LED_PAT",22));
}
int CMD_PL_PS_STREAMER_LED_OFF(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"PL_PS_STREAMER_LED_OFF", 22));
}
int CMD_PS_FP_ADD(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"FP_ADD", 6));
}
int CMD_PL_LW_FEQ(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"LW_FEQ", 6));
}
int CMD_PL_HI_FEQ(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"HI_FEQ", 6));
}
int CMD_PS_FP_SUB(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"FP_SUB", 6));
}
int CMD_PS_FP_MUL(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"FP_MUL", 6));
}
int CMD_PL_PS_STREAMER_ASSERT(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"PL_PS_STREAMER_ASSERT", 21));
}
int CMD_PL_PS_STREAMER_CORE(char *buf)
{
    return (!strncmp(buf,"CMD",3) && !strncmp(buf + 4,"PL_PS_STREAMER_CORE", 19));
}
void extract_file_name(char *filename, char *req, int rlen, int maxlen)
{
    char *fstart, *fend;
    req += strlen("GET ");
    if (*req == '/')
        req++;
        fstart = req;
    while (*req != ' ')
        req++;
        fend = req-1;
    if (fend < fstart)
    {
        strcpy(filename, "index.html");
        return;
    }
    if (fend - fstart > maxlen)
    {
        *fend = 0;
        strcpy(filename, "404.html");
        printf("Request filename is too long\r\n");
        return;
    }
    strncpy(filename, fstart, fend-fstart+1);
    filename[fend-fstart+1] = 0;
    if (*fend == '/')
        strcat(filename, "index.html");
}
char *get_file_extension(char *fname)
{
    char *fext = fname + strlen(fname) - 1;
    while (fext > fname) {
    if (*fext == '.')
        return fext + 1;
    fext--;
    }
    return NULL;
}
int GENERATE_HTTP_HEADER(char *buf, char *fext, int fsize)
{
    char lbuf[40];
    strcpy(buf, "HTTP/1.1 200 OK\r\nContent-Type: ");
    if (fext == NULL)
        strcat(buf, "text/html");
    else if (!strncmp(fext, "htm", 3))
        strcat(buf, "text/html");
    else if (!strncmp(fext, "jpg", 3))
        strcat(buf, "image/jpeg");
    else if (!strncmp(fext, "gif", 3))
        strcat(buf, "image/gif");
    else if (!strncmp(fext, "json", 4))
        strcat(buf, "application/json");
    else if (!strncmp(fext, "js", 2))
        strcat(buf, "application/javascript");
    else if (!strncmp(fext, "pdf", 2))
        strcat(buf, "application/pdf");
    else if (!strncmp(fext, "css", 2))
        strcat(buf, "text/css");
    else
        strcat(buf, "text/plain");
        strcat(buf, "\r\n");
        sprintf(lbuf, "Content-length: %d", fsize);
        strcat(buf, lbuf);
        strcat(buf, "\r\n");
        strcat(buf, "Connection: close\r\n");
        strcat(buf, "\r\n");
    return strlen(buf);
}
static int p_arg_count = 0;
static http_arg httpArgArray[1000];
static int httpArgArrayIndex = 0;
http_arg *palloc_arg()
{
    http_arg *a;
    a = &(httpArgArray[httpArgArrayIndex]);
    httpArgArrayIndex++;
    if (httpArgArrayIndex == 1000)
    httpArgArrayIndex = 0;
    a->count = p_arg_count++;
    a->fd = -1;
    a->fsize = 0;
    return a;
}
void pfree_arg(http_arg *arg)
{
;
}