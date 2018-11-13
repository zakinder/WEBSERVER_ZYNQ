#include <xil_types.h>
u32 uartcmd(u32 argA,u32 argB);
void menu_calls(int ON_OFF);
#define REG1 0
#define REG2 4
#define REG3 8
#define REG4 12
#define REG5 16
#define REG6 20
#define REG30 116
#define REG31 120
#define REG32 124
#define D5M_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define D5M_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
