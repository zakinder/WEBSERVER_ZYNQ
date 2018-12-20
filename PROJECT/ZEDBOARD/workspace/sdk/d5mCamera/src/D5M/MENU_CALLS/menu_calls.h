// LAST TESTED : 12/16/2018
#include <xil_types.h>
u32 uartcmd(u32 argA,u32 argB);
void menu_calls(int ON_OFF);
#define REG1 0
#define REG2 4
#define REG3 8
#define REG4 12
#define REG5 16
#define REG6 20
#define REG7 24
#define REG8 28
#define REG9 32
#define REG10 36
#define REG11 40
#define REG12 44
#define REG13 48
#define REG14 52
#define REG15 56
#define REG16 60
#define REG17 64
#define REG18 68
#define REG19 72
#define REG20 76
#define REG21 80
#define REG22 84
#define REG23 88
#define REG24 92
#define REG25 96
#define REG26 100
#define REG27 104
#define REG28 108
#define REG29 112
#define REG30 116
#define REG31 120
#define REG32 124
#define D5M_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define D5M_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))