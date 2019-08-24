#include "code_def.h"
#include <stdint.h>

void Set_ACC_STATE(uint32_t state)
{
    ACC->ACC_STATE = state;
}

uint32_t Read_ACC_STATE(void)
{
    return(ACC->ACC_STATE);
}

void Load_ACC_Data(uint8_t num)
{

    DMA(&(NUMBER->NUM[num][0][0]),&(ACC->ACC_DATA[0][0]),0,150);

}

void Detect(uint8_t chepai, uint8_t num)
{
    LED_LightUp(2);
    Load_ACC_Data(num);
    Set_ACC_STATE(1);
    while(Read_ACC_STATE());
    int change;
    int max;
    int result;
    int i;
    for(i = 0;i < 10;i++) {
        change = ACC->NUM[i];
        if(change &0x80) {
            change &= ~0x80;
            change = 0 - change;
        }
        if(i == 0) {
            max = change;
            result = 0;
        } else {
            if(max < change) {
                max = change;
                result = i;
            }
        }
    }


    ACC_RESULT->RESULT[chepai][num] = (uint8_t)(result + 48);

    LED_ShutDown(2);


}