#include "code_def.h"
#include <stdint.h>
#include "oledfont.h"

void Set_OLED_SCLK(void)
{
    OLED->OLED_SCLK = 1;
}
void Clr_OLED_SCLK(void)
{
    OLED->OLED_SCLK = 0;
}
void Set_OLED_SDIN(void)
{
    OLED->OLED_SDIN = 1;
}
void Clr_OLED_SDIN(void)
{
    OLED->OLED_SDIN = 0;
}
void OLED_Start(void)
{
    Set_OLED_SCLK();
    Set_OLED_SDIN();
    Clr_OLED_SDIN();
    delay(50);
    Clr_OLED_SCLK();
}
void OLED_Stop(void)
{
    delay(100);
    Set_OLED_SCLK();
    Clr_OLED_SDIN();
    delay(50);
    Set_OLED_SDIN();
    delay(100);
}
void OLED_Waite(void)
{
    delay(80);
    Set_OLED_SCLK();
    delay(100);
    Clr_OLED_SCLK();
}
void OLED_Write_Byte(uint8_t data)
{
    uint8_t i,m,da;
    da = data;
    Clr_OLED_SCLK();
    for(i=0;i<8;i++)
    {
        m = da;
        m = m & 0x80;
        if(m == 0x80) Set_OLED_SDIN();
        else Clr_OLED_SDIN();
        delay(100);
        da = da << 1;
        Set_OLED_SCLK();
        delay(100);
        Clr_OLED_SCLK(); 
        delay(20);
    }
}
void OLED_Command(uint8_t command)
{
    OLED_Start();
    OLED_Write_Byte(0x78);
    OLED_Waite();
    // OLED_Stop();
    // OLED_Start();
    OLED_Write_Byte(0x00);
    OLED_Waite();
    // OLED_Stop();
    // OLED_Start();
    OLED_Write_Byte(command);
    OLED_Waite();
    OLED_Stop();
}
void OLED_Data(uint8_t data)
{
    OLED_Start();
    OLED_Write_Byte(0x78);
    OLED_Waite();
    // OLED_Stop();
    // OLED_Start();
    OLED_Write_Byte(0x40);
    OLED_Waite();
    // OLED_Stop();
    // OLED_Start();
    OLED_Write_Byte(data);
    OLED_Waite();
    OLED_Stop();
}
void OLED_Set_Pos(uint8_t x, uint8_t y)
{
    OLED_Command(0xb0+y);
    OLED_Command(((x & 0xf0) >> 4) | 0x10);
    OLED_Command(x&0x0f);
}
void OLED_Display_On(void)
{
    OLED_Command(0x8d);
    OLED_Command(0x14);
    OLED_Command(0xaf);
}
void OLED_Display_Off(void)
{
    OLED_Command(0x8d);
    OLED_Command(0x10);
    OLED_Command(0xae);
}
void OLED_Clear(void)
{
    uint8_t i,n;
    for(i=0;i<8;i++)
    {
        OLED_Command(0xb0+i);
        OLED_Command(0x00);
        OLED_Command(0x10);
        for(n=0;n<128;n++) OLED_Data(0);
    }
}
void OLED_On(void)
{
    uint8_t i,n;
    for(i=0;i<8;i++)
    {
        OLED_Command(0xb0+i);
        OLED_Command(0x00);
        OLED_Command(0x10);
        for(n=0;n<128;n++) OLED_Data(1);
    }  
}
void OLED_Show_Char(uint8_t x, uint8_t y, uint8_t chr)
{
    uint8_t c = 0,i = 0;
    c = chr - ' ';
    if((c > 15) && (c < 26))
        c = c - 16;
    else if((c > 32) && (c < 59))
        c = c - 33 + 10;
    else if((c > 64) && (c < 91))
        c = c - 65 + 10 + 26;
	if(x>128-1)
    {
        x = 0;
        y = y + 2;
    }
	OLED_Set_Pos(x,y);	
	for(i=0;i<8;i++)
	    OLED_Data(F8X16[c*16+i]);
	OLED_Set_Pos(x,y+1);
	for(i=0;i<8;i++)
	    OLED_Data(F8X16[c*16+i+8]);
}
void OLED_Initial(void)
{
    OLED_Command(0xAE);
	OLED_Command(0x00);
	OLED_Command(0x10);
	OLED_Command(0x40);
	OLED_Command(0xB0);
	OLED_Command(0x81);
	OLED_Command(0xFF);
	OLED_Command(0xA1);
	OLED_Command(0xA6);
	OLED_Command(0xA8);
	OLED_Command(0x3F);
	OLED_Command(0xC8);
	OLED_Command(0xD3);
	OLED_Command(0x00);
	OLED_Command(0xD5);
	OLED_Command(0x80);
	OLED_Command(0xD8);
	OLED_Command(0x05);
	OLED_Command(0xD9);
	OLED_Command(0xF1);
	OLED_Command(0xDA);
	OLED_Command(0x12);
	OLED_Command(0xDB);
	OLED_Command(0x30);
	OLED_Command(0x8D);
	OLED_Command(0x14);
	OLED_Command(0xAF);
}


void Display_plate(uint8_t num)
{
    OLED_Clear();
    
    //OLED_Show_Char(16,4,ACC_RESULT->RESULT[num][5]);
    OLED_Show_Char(32,4,ACC_RESULT->RESULT[num][0]);
	OLED_Show_Char(48,4,ACC_RESULT->RESULT[num][1]);
	OLED_Show_Char(64,4,ACC_RESULT->RESULT[num][2]);
	OLED_Show_Char(80,4,ACC_RESULT->RESULT[num][3]);
	OLED_Show_Char(96,4,ACC_RESULT->RESULT[num][4]);
}

void Display_QVGA(void)
{
    uint8_t i,j;
    for(i = 0;i < 240;i++)
    {
        for(j = 0;j < 40;j++)
        {
            WriteUART(CAMERA->CAMERA_VALUE[i][j]);
        }
    }
}