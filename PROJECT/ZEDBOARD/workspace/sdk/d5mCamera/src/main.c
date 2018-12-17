#include <xil_types.h>
#include "D5M/d5m.h"
#include "D5M/MENU_CALLS/menu_calls.h"
#include "WEB/web.h"
// LAST TESTED : 12/16/2018
int main(void)
{
	d5m();
	menu_calls(TRUE);
    web();
    return 0;
}
