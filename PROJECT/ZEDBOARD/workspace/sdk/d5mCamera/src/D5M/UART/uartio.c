// LAST TESTED : 12/16/2018
#include "uartio.h"
#include <stdio.h>
#include <string.h>
#include "../SYSTEM_CONFIG_HEADER/system_config_header.h"
#include "utilities.h"
u8 uart_per_byte_read(u32 uart_address) {
    u8 uart_io;
    if (uart_address == uart_1_baseaddr)
        read(1, (char*) &uart_io, 1);
    return (uart_io);
}
u16 uart_two_byte_read(u32 uart_address)
{
    u16 uart_io;
    if (uart_address == uart_1_baseaddr)
        read(1, (char*) &uart_io, 1);
    return (uart_io);
}
u32 uart_prompt_io()
{
    int nTemp;
    int i;
    int nNumberBits = 32;
    u8 userinput = 0;
    int received_uart_data = 0;
    u8 auserinput[8];
    u32 nReturnVal = 0;
    nTemp = bit_expo(2, nNumberBits) - 1;
    fflush(stdout);
    while (userinput != 13) {
        userinput = uart_two_byte_read(uart_1_baseaddr);
        if (userinput == 32) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf(" ");
            fflush(stdout);
        } else if ((userinput >= 48 && userinput <= 57)) {
            userinput -= 48;
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Cyan_Text();
            printf("%d", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput >= 65 && userinput <= 90) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Magenta_Text();
            printf("%c", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput >= 97 && userinput <= 122) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            uart_Magenta_Text();
            printf("%c", userinput);
            uart_Default_Text();
            fflush(stdout);
        } else if (userinput == 13) {
            for (i = 0; i < received_uart_data; i++) {
                nReturnVal += auserinput[i]
                        * bit_expo(10, received_uart_data - i - 1);
            }
            if (nReturnVal > nTemp)
                nReturnVal = nTemp;
        }
    }
    uart_Cyan_Text();
    printf("\r>>\r\n", nReturnVal);
    uart_Default_Text();
    return (nReturnVal);
}
int bit_expo(int base_value, int exponent)
{
    int i = 0;
    int nValue = 0;
    if (exponent == 0)
        nValue = 1;
    else {
        nValue = base_value;
        for (i = 1; i < exponent; i++) {
            nValue = nValue * base_value;
        }
    }
    return (nValue);
}//
unsigned int uart_prompt_excute()
{
    int nTemp;
    int i;
    int nNumberBits = 32;
    u8 userinput = 0;
    int received_uart_data = 0;
    u8 auserinput[8];
    unsigned int nReturnVal = 0;
    nTemp = bit_expo(2, nNumberBits) - 1;
    printf(":");
    fflush(stdout);
    while (userinput != 13) {
        userinput = uart_two_byte_read(UART_ADDRESS);
        if (userinput == 32) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf(" ");
            fflush(stdout);
        } else if ((userinput >= 48 && userinput <= 57)) {
            userinput -= 48;
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%d", userinput);
            fflush(stdout);
        } else if (userinput >= 65 && userinput <= 90) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%C", userinput);
            fflush(stdout);
        } else if (userinput >= 97 && userinput <= 122) {
            auserinput[received_uart_data] = userinput;
            received_uart_data++;
            printf("%c", userinput);
            fflush(stdout);
        } else if (userinput == 13) {
            for (i = 0; i < received_uart_data; i++) {
                nReturnVal += auserinput[i]
                        * bit_expo(10, received_uart_data - i - 1);
            }
            if (nReturnVal > nTemp)
                nReturnVal = nTemp;
        }
    }
    printf("\r>> %c\r\n", nReturnVal);
    return (nReturnVal);
}
void uartvalue()
{
    u32 ascii_char = 1;
    ascii_char = uart_prompt_excute();
    printf("uarttester = %X\r\n", ascii_char);
    printf("uarttester = %d\r\n", ascii_char);
    printf("uarttester = %i\r\n", ascii_char);
    printf("uarttester = %x\r\n", ascii_char);
    printf("uarttester = %c\r\n", ascii_char);
}
/*******************************************************/
/*
u32 enter_value_or_quit(arg1,arg2);
arg1 value : null or valid_state or invalid_state
             null          : return routine cmds
             valid_state   : return user entered valid state.
             invalid_state : return if user entered invalid state then arg2 is returned.
arg2 value : depended on arg1 if invalid state then arg2 is returned.
*/
u32 enter_value_or_quit(char s[],u32 current_state)
{
    u32 value_enter_quit;
    int result;
    char command_print[200];
    strcpy(command_print, "null");
    result = strcmp(command_print, s);
    if (result == 0)
    {
        printf("Enter Value:\n");
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0x71 || value_enter_quit == 0x51)
        {
            return quit_current_state;
        }
        else if (value_enter_quit == 0)
        {
            return value_enter_quit;
        }
        else
        {
            return value_enter_quit;
        }
    }
    else
    {
        cmds_menu();
        uart_Green_Text();
        printf("Press Enter to remain in Current State : %s or Above cmds\n",s);
        uart_Default_Text();
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0)
        {
            printf("Last State :%s\n",s);
            return current_state;
        }
        else
        {
            printf("Last State :%s\n",s);
            return value_enter_quit;
        }
    }
}
u32 enter_or_quit(char s[],u32 current_state)
{
    u32 value_enter_quit;
    int result;
    char command_print[200];
    strcpy(command_print, "null");
    result = strcmp(command_print, s);
    if (result == 0)
    {
        printf("Enter Value:\n");
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0x71 || value_enter_quit == 0x51)
        {
            return quit_current_state;
        }
        else if (value_enter_quit == 0)
        {
            return value_enter_quit;
        }
        else
        {
            return value_enter_quit;
        }
    }
    else
    {
        printf("Current State : %s\n",s);
        printf("Press Enter to remain in Current State : %s\n",s);
        uart_Green_Text();
        printf("Next State : ?\n");
        uart_Default_Text();
        menu_print_prompt();
        value_enter_quit = uart_prompt_io();
        if (value_enter_quit == 0)
        {
            printf("Last State :%s\n",s);
            return current_state;
        }
        else
        {
            printf("Last State :%s\n",s);
            return value_enter_quit;
        }
    }
}
void menu_print_prompt()
{
    uart_Yellow_Text();
    printf("\r\n>> ");
    uart_Default_Text();
}
u32 uartcmd(u32 argA,u32 argB){
    printf("Enter to quit\n");
    printf("\r>>");
    u32 uartquit;
    uartquit = uart_prompt_io();
    if (uartquit == cmds_quit || uartquit == 0x00) {return argA;
    } else {return argB;}
}