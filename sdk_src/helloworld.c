/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "dma_passthrough.h"
#include "xil_printf.h"
#define SAMPLES_PER_FRAME  1280


typedef struct dma_buffer
{
	dma_passthrough_t* p_dma_passthrough_inst;
	int           samples_per_frame;
	int           bytes_per_sample;
} dma_buffer_t;

int main()
{
	int     status;
	int     ii = 0, jj = 0, cnt = 0;
	int     snd_buf[SAMPLES_PER_FRAME];
	dma_buffer_t *p_obj;


	xil_printf("A\r\n");
	// Allocate memory for ADC object
	p_obj = (dma_buffer_t*) malloc(sizeof(dma_buffer_t));
	if (p_obj == NULL)
	{
		xil_printf("ERROR! Failed to allocate memory for DMA Buffer object.\n\r");
		return 1;
	}

	xil_printf("B\r\n");
	// Create DMA Passthrough object to be used by the ADC
	p_obj->p_dma_passthrough_inst = dma_passthrough_create
	(
		XPAR_AXIDMA_0_DEVICE_ID,
		sizeof(int)
	);

	xil_printf("C\r\n");

	u32 i = 0;
	for (i = 0; i < 0xFFFFFF; i++);
	xil_printf("Blank screen.\r\n");



	while(1)
	{
		for (ii = 0; ii < SAMPLES_PER_FRAME; ii++) snd_buf[ii] =  (1024 - (ii % 1024));

		dma_passthrough_set_snd_buf(p_obj->p_dma_passthrough_inst, snd_buf);
		status = dma_passthrough_snd(p_obj->p_dma_passthrough_inst);
		if (status != DMA_PASSTHROUGH_SUCCESS)
		{
			xil_printf("ERROR! DMA Passthrough error occurred when trying to get data.\n\r");
			return 1;
		}
		u32 i = 0;
//		snd_buf[50] = (snd_buf[50] + 1) % 900;
		for (i = 0; i < 0xFFFFFFF; i++);
	}



//    cleanup_platform();
    return 0;
}
