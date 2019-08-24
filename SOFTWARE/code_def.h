#include <stdint.h>

//INTERRUPT DEF
#define NVIC_CTRL_ADDR (*(volatile unsigned *)0xe000e100)

//GPIO DEF
typedef struct{
    volatile uint32_t GPIO_RDATA;
    volatile uint32_t GPIO_DIR;
    volatile uint32_t GPIO_WDATA;
}GPIOType;

#define GPIO_BASE 0x40000000
#define GPIO ((GPIOType *)GPIO_BASE)

//CAMERA CONFIG DEF
typedef struct{
    volatile uint32_t CAMERA_CONFIG_RST;
    volatile uint32_t CAMERA_CONFIG_PWDN;
    volatile uint32_t CAMERA_CONFIG_SCL;
    volatile uint32_t CAMERA_CONFIG_SDAO;
    volatile uint32_t CAMERA_CONFIG_SDAI;
    volatile uint32_t CAMERA_CONFIG_SDAOEN;
    volatile uint32_t CAMERA_DATA_STATE;
    volatile uint32_t CAMERA_DATA_LEN;
}CAMERA_CONFIGType;

#define CAMERA_CONFIG_BASE 0x4001ffd0
#define CAMERA_CONFIG ((CAMERA_CONFIGType *)CAMERA_CONFIG_BASE)


//DMAC DEF
typedef struct{
    volatile uint32_t DMA_SRC;
    volatile uint32_t DMA_DST;
    volatile uint32_t DMA_SIZE;
    volatile uint32_t DMA_LEN;
}DMACType;

#define DMAC_BASE 0x40000200
#define DMAC ((DMACType *)DMAC_BASE)

//CAMERA DEF
typedef struct{
    volatile uint8_t CAMERA_VALUE[240][40];
}CAMERAType;

#define CAMERA_BASE 0x40010000
#define CAMERA ((CAMERAType *)CAMERA_BASE)

//OLED DEF
typedef struct{
    volatile uint32_t OLED_SCLK;
    volatile uint32_t OLED_SDIN;
}OLEDType;

#define OLED_BASE 0x40000300
#define OLED ((OLEDType *)OLED_BASE)

//TIMER DEF
typedef struct{
    volatile uint32_t TIMER_RST;
    volatile uint32_t TIMER_EN;
}TIMERType;

#define TIMER_BASE 0x40000400
#define TIMER ((TIMERType *)TIMER_BASE)

//ACCC DEF
typedef struct{
    volatile uint8_t ACC_DATA[50][3];
    volatile uint8_t ACC_STATE;
    volatile uint8_t NUM[10];
}ACCType;

#define ACC_BASE 0x40030000
#define ACC ((ACCType *)ACC_BASE)

//SysTick DEF
typedef struct{
    volatile uint32_t CTRL;
    volatile uint32_t LOAD;
    volatile uint32_t VALUE;
    volatile uint32_t CALIB;
}SysTickType;

#define SysTick_BASE 0xe000e010
#define SysTick ((SysTickType *)SysTick_BASE)

//UART DEF
typedef struct{
    volatile uint32_t UARTRX_DATA;
    volatile uint32_t UARTTX_STATE;
    volatile uint32_t UARTTX_DATA;
}UARTType;

#define UART_BASE 0x40000100
#define UART ((UARTType *)UART_BASE)

//NUMBER DEF
typedef struct{
    volatile uint8_t CHN[50][3];
    volatile uint8_t ALB[50][3];
    volatile uint8_t NUM[5][50][3];
}NUMBERType;

#define NUMBER_BASE 0x20000a00
#define NUMBER ((NUMBERType *)NUMBER_BASE)

//NUMBER DEF
typedef struct{
    volatile uint8_t RESULT[20][5];
}RESULTType;

#define RESULT_BASE 0x20000900
#define ACC_RESULT ((RESULTType *)RESULT_BASE)

//SCB DEF
typedef struct
{
  volatile uint32_t CPUID;                  
  volatile uint32_t ICSR;                   
  volatile uint32_t VTOR;                   
  volatile uint32_t AIRCR;                  
  volatile uint32_t SCR;                    
  volatile uint32_t CCR;                    
  volatile uint8_t  SHP[12];                
  volatile uint32_t SHCSR;                  
  volatile uint32_t CFSR;                   
  volatile uint32_t HFSR;                   
  volatile uint32_t DFSR;                   
  volatile uint32_t MMFAR;                  
  volatile uint32_t BFAR;                   
  volatile uint32_t AFSR;                   
  volatile uint32_t PFR[2];                 
  volatile uint32_t DFR;                    
  volatile uint32_t ADR;                    
  volatile uint32_t MMFR[4];                
  volatile uint32_t ISAR[5];                
  volatile uint32_t RESERVED0[5];
  volatile uint32_t CPACR;                  
} SCBType;

#define SCB_BASE 0xe000ed00
#define SCB ((SCBType *)SCB_BASE)

// IRQ
void KEY0(void);
void KEY1(void);
void KEY2(void);
void KEY3(void);

// UART
char ReadUARTState(void);
char ReadUART(void);
void WriteUART(char data);
void UARTString(char *stri);
void UARTHandle(void);
void SendPlate(uint8_t coordinate[4], uint8_t num_edge[16]);

// DMA
void DMA(int src,int dst,int size,int len);

// SYSTEM INITIAL
void SYSInit(void);

// GPIO
void Set_GPIO_Dir(uint16_t dir);
uint16_t Read_GPIO_Input(void);
uint16_t Read_GPIO_Output(void);
uint16_t Read_GPIO_Dir(void);
void Set_GPIO_Value(uint16_t value);
void LED_LightUp(uint8_t num);
void LED_ShutDown(uint8_t num);
uint8_t Read_Switch(uint8_t num);

// SYSTICK
void SysTickHandler(void);
void Set_SysTick_CTRL(uint32_t ctrl);
void Set_SysTick_LOAD(uint32_t load);
uint32_t Read_SysTick_VALUE(void);
void Set_SysTick_VALUE(uint32_t value);
void Set_SysTick_CALIB(uint32_t calib);
uint32_t Timer_Ini(void);
uint8_t Timer_Stop(uint32_t *duration_t,uint32_t start_t);

// DELAY FUNC
void delay(uint32_t time);

//OLED
void Set_OLED_SCLK(void);
void Clr_OLED_SCLK(void);
void Set_OLED_SDIN(void);
void Clr_OLED_SDIN(void);
void OLED_Start(void);
void OLED_Stop(void);
void OLED_Waite(void);
void OLED_Write_Byte(uint8_t data);
void OLED_Command(uint8_t command);
void OLED_Data(uint8_t data);
void OLED_Set_Pos(uint8_t x, uint8_t y);
void OLED_Display_On(void);
void OLED_Display_Off(void);
void OLED_Clear(void);
void OLED_On(void);
void OLED_Show_Char(uint8_t x, uint8_t y, uint8_t chr);
void OLED_Show_CHinese(uint8_t x,uint8_t y,uint8_t no);
void OLED_Initial(void);
void Display_plate(uint8_t num);
void Display_QVGA(void);

// CAMERA
void Set_CAMERA_SDA_W(void);
void Set_CAMERA_SDA_R(void);
void Set_CAMERA_SCL(void);
void Clr_CAMERA_SCL(void);
void Set_CAMERA_RST(void);
void Clr_CAMERA_RST(void);
void Set_CAMERA_PWDN(void);
void Clr_CAMERA_PWDN(void);
void Set_CAMERA_SDA(void);
uint32_t Read_CAMERA_SDA(void);
void Clr_CAMERA_SDA(void);
void CAMERA_Start(void);
void CAMERA_Stop(void);
void CAMERA_Waite(void);
void CAMERA_Write_Byte(uint8_t data);
void CAMERA_Command(uint8_t addr_h,uint8_t addr_l,uint8_t data);
void CAMERA_Data(uint8_t data);
void CAMERA_Initial(void);
uint32_t Read_CAMERA_DATA_STATE(void);
void Set_CAMERA_DATA_STATE(uint32_t state);
uint32_t Read_CAMERA_DATA_LEN(void);
uint8_t CAMERA_Read_Byte(void);
uint8_t CAMERA_Read_Reg(uint16_t reg);
uint8_t CAMERA_Focus_Init(void);
void CAMERA_Light_Mode(void);	
void CAMERA_Color_Saturation(void);
void CAMERA_Brightness(void);	
void CAMERA_Contrast(void);	
void CAMERA_Sharpness(void);	
uint8_t CAMERA_Focus_Constant(void);
void CAMERA_NA(void);
void photo(uint8_t coordinate[4], uint8_t num_edge[16]);

// ALGORITHM
void location(uint8_t coordinate[4],uint8_t num_edge[16]);
void Loat2Mem(uint8_t coordinate[4],uint8_t num_edge[16]);
void Calibration(void);

// ACC
void Set_ACC_STATE(uint32_t state);
uint32_t Read_ACC_STATE(void);
void Load_ACC_Data(uint8_t num);
uint32_t Result(void);
void Detect(uint8_t chepai, uint8_t num);

// TIMER
void Timer_Reset(uint32_t rst);
void Timer_Enable(uint32_t en);