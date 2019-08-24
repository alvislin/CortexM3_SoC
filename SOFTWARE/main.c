#include "code_def.h"
#include <stdint.h>
#include <stdio.h>

extern uint32_t key3_flag;
extern uint32_t key2_flag;
extern uint32_t key1_flag;
extern uint32_t key0_flag;
extern uint8_t 	uart_flag;

int main()
{
	SYSInit();

	uint8_t fault_flag = 0;
	uint8_t i = 0;
	uint8_t j = 0;

	uint8_t chepai = 0;
	uint8_t number = 0;
	uint8_t alb_flag = 0;
	uint8_t coordinate[4];
	uint8_t num_edge[16];
	uint8_t re[34];
	while(!key3_flag){;}
	key3_flag = 0;

	 Timer_Enable(1);

	for(chepai = 0;chepai < 20;chepai++) {

		LED_ShutDown(7);
		LED_ShutDown(6);

		for(i = 0;i < 4;i++) coordinate[i] = 0;
		for(i = 0;i < 16;i++) num_edge[i] = 0;

		photo(coordinate,num_edge);

		for(i = 2;i < 15;i++) {
			if(num_edge[i] > num_edge[i + 1]) {
				fault_flag = 1;
				LED_LightUp(7);
				break;
			} else {
				fault_flag = 0;
			}
		}

		if(fault_flag) {
			chepai--;
			continue;
		}
			
		for(number = 0;number < 5;number++)
			Detect(chepai,number);

		fault_flag = 1;

		if(chepai > 0) {
			for(number = 0;number < 5;number++) {
				if(ACC_RESULT->RESULT[chepai][number] != ACC_RESULT->RESULT[chepai-1][number]) {
					fault_flag = 0;
					break;
				}
			}
		} else {
			fault_flag = 0;
		}

		if(fault_flag) {
			chepai--;
			LED_LightUp(6);
			continue;
		} else {
			WriteUART(0xc5);
			while(!uart_flag) {;}
			uart_flag = 0;
			delay(3730000);
		}

	}

	Timer_Enable(0);

	int8_t discnt = 0;
	while(1) {
		if(key2_flag) {
			Display_plate(discnt++);
			if(discnt == 20) discnt = 0;
			key2_flag = 0;
		} else if(key1_flag) {
			Display_plate(discnt--);
			if(discnt == -1) discnt = 19;
			key1_flag = 0;
		}
	}

}	
		