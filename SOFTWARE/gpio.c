#include "code_def.h"
#include <stdint.h>


void Set_GPIO_Dir(uint16_t dir)
{
	GPIO->GPIO_DIR	=	dir;
}

uint16_t Read_GPIO_Input(void)
{
	return(GPIO->GPIO_RDATA);
}

uint16_t Read_GPIO_Output(void)
{
	return(GPIO->GPIO_WDATA);
}

uint16_t Read_GPIO_Dir(void)
{
	return(GPIO->GPIO_DIR);
}

void Set_GPIO_Value(uint16_t value)
{
	GPIO->GPIO_WDATA=value;
}

void LED_LightUp(uint8_t num)
{
	uint16_t temp;
	temp = Read_GPIO_Output();
	temp |= 1 << (8 + num);
	Set_GPIO_Value(temp);
}
void LED_ShutDown(uint8_t num)
{
	uint16_t temp;
	uint8_t temp1;
	temp = Read_GPIO_Output();
	temp1 = 1 << num;
	temp1 = ~temp1;
	temp &= temp1 << 8;
	Set_GPIO_Value(temp);
}
uint8_t Read_Switch(uint8_t num)
{
	uint16_t temp;
	temp = Read_GPIO_Input();
	uint16_t temp1;
	temp1 = 1 << num;
	temp1 &= temp;
	if(temp1 == 0) return 0;
	else return 1;
}