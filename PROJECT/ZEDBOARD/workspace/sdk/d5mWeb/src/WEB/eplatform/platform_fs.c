#include "mfs_config.h"
#ifndef __PPC__
#include "xil_printf.h"
#endif
int
platform_init_fs()
{
	mfs_init_fs(MFS_NUMBYTES, (char *)(MFS_BASE_ADDRESS+4), MFS_INIT_TYPE);
	if (mfs_exists_file("index.html") == 0) {
		xil_printf("%s: ERROR: unable to locate index.html in MFS\r\n", __FUNCTION__);
		xil_printf("One of your applications requires a Memory File System to be loaded.\r\n");
                xil_printf("Please check if MFS has been loaded, "
				"and it has index.html file in root directory\r\n");
		return -1;
	}
	return 0;
}
