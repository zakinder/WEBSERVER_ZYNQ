#ifndef __WEBSERVER_H__
#define __WEBSERVER_H__
#include "lwip/tcp.h"
#define MAX_FILENAME 256
int platform_init_fs();
int http_init_devices();
void extract_file_name(char *filename, char *req, int rlen, int maxlen);
char *get_file_extension(char *buf);
int IS_CMD_LED(char *buf);
int IS_CMD_SWITCH(char *buf);
int CMD_PL_PS_STREAMER_LED_ON(char *buf);
int CMD_PL_PS_STREAMER_LED_PAT(char *buf);
int CMD_PL_PS_STREAMER_LED_OFF(char *buf);
int CMD_PS_FP_ADD(char *buf);
int CMD_PS_FP_SUB(char *buf);
int CMD_PS_FP_MUL(char *buf);
int CMD_PL_PS_STREAMER_ASSERT(char *buf);
int CMD_PL_PS_STREAMER_CORE(char *buf);
int GENERATE_RESPONSE(struct tcp_pcb *pcb, char *http_req, int http_req_len);
typedef struct {
	int count;
	int fd;
	int fsize;
} http_arg;
http_arg *palloc_arg();
void pfree_arg(http_arg *);
int start_web_application();
#endif
