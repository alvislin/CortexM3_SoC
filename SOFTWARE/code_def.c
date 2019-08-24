#include "code_def.h"
#include <stdint.h>

extern uint32_t key3_flag;
extern uint32_t key2_flag;
extern uint32_t key1_flag;
extern uint32_t key0_flag;

extern uint8_t	uart_flag;

void DMA(int src,int dst,int size,int len)
{
	DMAC -> DMA_SRC = src;
	DMAC -> DMA_DST = dst;
	DMAC -> DMA_SIZE = size;
	DMAC -> DMA_LEN = len;
	__wfi();
}

void Timer_Reset(uint32_t rst)
{
	TIMER->TIMER_RST = rst;
}
void Timer_Enable(uint32_t en)
{
	TIMER->TIMER_EN = en;
}

// const uint8_t num[50][3] = {
// 0,126,0,
// 128,255,0,
// 192,255,3,
// 224,255,3,
// 240,255,7,
// 240,231,15,
// 248,129,15,
// 248,0,31,
// 120,0,31,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,30,
// 120,0,31,
// 248,0,15,
// 248,129,15,
// 240,255,15,
// 240,255,7,
// 224,255,3,
// 192,255,1,
// 128,255,0,
// 0,126,0,
// 0,0,0,
// 0,0,0
// };

void SYSInit(void)
{
	// GPIO initial
	Set_GPIO_Dir(0xff00);

	// IRQ enable
	NVIC_CTRL_ADDR	=	0x3f;

	LED_LightUp(0);

	// UART DISPLAY
	//UARTString("Cortex-M3 Start up!\n");


	// Systick initial
	Set_SysTick_CTRL(0);

	// CAMERA initial
	CAMERA_Initial();

	// OLED initial
	OLED_Initial();
	OLED_Clear();

	key3_flag = 0;
	key2_flag = 0;
	key1_flag = 0;
	key0_flag = 0;
	uart_flag = 0;
	Timer_Reset(1);

	// int i,j,k;
	// for(i = 0;i < 50;i++) {
	// 	for(j = 0;j < 3;j++) {
	// 		// for(k = 0;k < 5;k++)
	// 		 	NUMBER->NUM[0][i][j] = num[i][j];
	// 		//NUMBER->ALB[i][j] = num[i][j];
	// 	}
	// }

	LED_ShutDown(0);

}

void delay(uint32_t time)
{
	Set_SysTick_CTRL(0);
	Set_SysTick_LOAD(time);
	Set_SysTick_VALUE(0);
	Set_SysTick_CTRL(0x7);
	__wfi();
}