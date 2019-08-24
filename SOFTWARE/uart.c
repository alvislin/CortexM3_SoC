#include "code_def.h"
#include <stdint.h>

char ReadUARTState()
{
    char state;
	state = UART -> UARTTX_STATE;
    return(state);
}

char ReadUART()
{
    char data;
	data = UART -> UARTRX_DATA;
    return(data);
}

void WriteUART(char data)
{
    while(ReadUARTState());
	UART -> UARTTX_DATA = data;
}

void UARTString(char *stri)
{
	int i;
	for(i=0;i<strlen(stri);i++)
	{
		WriteUART(stri[i]);
	}
}

uint8_t uart_flag;

void UARTHandle()
{
	uart_flag = 1;
}

void SendPlate(uint8_t coordinate[4], uint8_t num_edge[16])
{
	uint8_t i,j,k;

	for(i = 0;i < 4;i++)
	{
		WriteUART(coordinate[i]);
	}
	for(i = 0;i < 16;i++)
	{
		WriteUART(num_edge[i]);
	}

	uint8_t b;
	
	for(i = 0;i < 5;i++)
	{
		for(j = 0;j < 50;j++)
		{
			for(k = 0;k < 3;k++)
			{
				WriteUART(NUMBER->NUM[i][j][k]);
			}
		}
	}
	// for(j = 0;j < 50;j++)
	// {
	// 	for(k = 0;k < 3;k++)
	// 	{
	// 		WriteUART(NUMBER->CHN[j][k]);
	// 	}
	// }
	for(j = 0;j < 50;j++)
	{
		for(k = 0;k < 3;k++)
		{
			WriteUART(NUMBER->ALB[j][k]);
		}
	}
}