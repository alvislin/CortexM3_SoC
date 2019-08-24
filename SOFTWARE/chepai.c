#include <stdint.h>
#include "code_def.h"

// ALGORITHM
void location(uint8_t coordinate[4],uint8_t num_edge[16])
{
    uint8_t i,j,k;
    uint8_t cnt = 0;
    uint8_t m = 0;
    uint8_t temp;

    // UP EDGE TO NOT WHITE
    for(i=0;i<240;i++)
    {
        for(j=0;j<40;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0xff) cnt++;
        }
        if(cnt > 15)
        {
            coordinate[0] = i;
            break;
        }
        cnt = 0;
    }

    // DOWN EDGE TO NOT WHITE
    cnt = 0;
    for(i=150;i<=150;i--)
    {
        for(j=0;j<40;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0xff) cnt++;
        }
        if(cnt > 15)
        {
            coordinate[1] = i;
            break;
        }
        cnt = 0;
    }

    m = coordinate[0] + 7;

    // LEFT EDGE TO NOT WHITE
    for(j=4;j<40;j++)
    {
        if(CAMERA->CAMERA_VALUE[m][j] != 0xff)
        {
            coordinate[2] = j;
            break;
        }
    }

    // RIGHT EDGE TO NOT WHITE
    for(j=35;j<=35;j--)
    {
        if(CAMERA->CAMERA_VALUE[m][j] != 0xff)
        {
            coordinate[3] = j;
            if(CAMERA->CAMERA_VALUE[m][j] == 0x00) 
                coordinate[3] ++;
            break;
        }
    }

    // UP EDGE TO BLUE
    cnt = 0;
    for(i = coordinate[0] + 3;i < coordinate[1];i++)
    {
        for(j = coordinate[2] + 2;j < coordinate[3] - 2;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0) cnt++;
        }
        if(cnt == 0)
        {
            coordinate[0] = i;
            break;
        }
    }

    // DOWN EDGE TO BLUE
    cnt = 0;
    for(i = coordinate[1] - 4;i >= coordinate[0];i--)
    {
        for(j = coordinate[2] + 2;j < coordinate[3] - 2;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0) cnt++;
        }
        if(cnt == 0)
        {
            coordinate[1] = i;
            break;
        }
    }

    // UP EDGE TO NUM
    cnt = 0;
    for(i = coordinate[0] ;i < coordinate[1];i++)
    {
        for(j = coordinate[2] + 2;j < coordinate[3] - 2;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0) cnt++;
        }
        if(cnt > 5)
        {
            coordinate[0] = i;
            break;
        }
    }

    // DOWN EDGE TO NUM
    cnt = 0;
    for(i = coordinate[1] - 1;i >= coordinate[0];i--)
    {
        for(j = coordinate[2] + 2;j < coordinate[3] - 2;j++)
        {
            if(CAMERA->CAMERA_VALUE[i][j] != 0) cnt++;
        }
        if(cnt > 5)
        {
            coordinate[1] = i;
            break;
        }
    }

    uint8_t flag = 0;
    cnt = 0;

    //coordinate[3] -= 1;
    //coordinate[2] += 1;

    m = 15;
    uint8_t end_flag = 0;

    for(i = coordinate[3] - 1;i >= coordinate[2];i--)
    {
        for(j = 7;j <= 7;j--)
        {
            for(k = coordinate[0];k < coordinate[1];k++)
            {
                temp = CAMERA->CAMERA_VALUE[k][i] ;
                temp &= 1 << j;
                if(temp != 0) cnt ++;
            }
            if(flag == 0) {
                if(cnt != 0) {
                    flag = 1;
                    num_edge[m--] = ((i - coordinate[2]) << 3) + j + 1;
                    if(m == 4) {
                        if(num_edge[6] - num_edge[5] > 12) {
                            num_edge[4] = num_edge[5];
                            num_edge[3] = num_edge[5];
                            m = 2;
                        }
                    }
                }
            } else if(flag == 1) {
                if(cnt == 0) {

                    num_edge[m] = ((i - coordinate[2]) << 3) + j;
                    if(m == 2) {
                        flag = 0;
                        end_flag = 1;
                    } else {
                        m--;
                        flag = 0;
                    }

                    // if(m == 0) {
                    //     if(num_edge[1] - (((i - coordinate[2]) << 3) + j) < 20){ 
                    //         continue;
                    //     } else {
                    //         num_edge[m] = ((i - coordinate[2]) << 3) + j;
                    //         flag = 0;
                    //         end_flag = 1;
                            
                    //     }
                    // } else {
                    //     flag = 0;
                    //     num_edge[m--] = ((i - coordinate[2]) << 3) + j;
                    // }
            
                }
            }
            cnt = 0;
            if(end_flag) break;
        }
        if(end_flag) break;
    }

    flag = 0;
    cnt = 0;
}

void Loat2Mem(uint8_t coordinate[4],uint8_t num_edge[16])
{
    uint8_t start_byte,end_byte;
    uint8_t start_bit,end_bit;
    uint8_t diff;
    uint8_t i,j,k;
    uint8_t temp,temp1,temp2;

    for(j = 0;j < 8;j++)
    {

        start_byte = (num_edge[j << 1] >> 3) + coordinate[2];
        end_byte = (num_edge[(j << 1) + 1] >> 3) + coordinate[2];
        start_bit = num_edge[j << 1] - ((num_edge[j << 1] >> 3) << 3);
        end_bit = num_edge[(j << 1) + 1] - ((num_edge[(j << 1) + 1] >> 3) << 3);

        diff = end_byte - start_byte;

        for(i=0;i<50;i++)
        {
            if(diff == 0)
            {
                if(j >= 3) {
                    NUMBER->NUM[j-3][i][0] = 0;
                    NUMBER->NUM[j-3][i][2] = 0;
                // } else if(j == 1) {
                //     NUMBER->ALB[i][0] = 0;
                //     NUMBER->ALB[i][2] = 0;
                // } else if(j == 0) {
                //     NUMBER->CHN[i][0] = 0;
                //     NUMBER->CHN[i][2] = 0;
                }
                if((coordinate[1] - coordinate[0]) >= i)
                {
                    temp = 0xff >> (7 - start_bit);
                    temp |= 0xff << (end_bit + 1);
                    temp = ~temp;
                    if(j >= 3) 
                        NUMBER->NUM[j-3][i][1] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;
                    // else if(j == 1)
                    //     NUMBER->ALB[i][1] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;   
                    // // else if(j == 0)
                    //     NUMBER->CHN[i][1] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;             
                }
                else
                {
                    if(j >= 3)
                        NUMBER->NUM[j-3][i][1] = 0;
                    // else if(j == 1)
                    //     NUMBER->ALB[i][1] = 0;
                    // else if(j == 0)
                    //     NUMBER->CHN[i][1] = 0;
                }  
            }
        
            else if(diff == 1)
            {
                if((coordinate[1] - coordinate[0]) >= i)
                {
                    
                    temp = 0xff >> (7 - start_bit);
                    temp = ~temp;
                    temp1 = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;

                    temp = 0xff << (end_bit + 1);
                    temp = ~temp;
                    temp2 = CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] & temp;

                    if(j >= 3) {
                        NUMBER->NUM[j-3][i][0] = temp1 << 4;
                        NUMBER->NUM[j-3][i][1] = (temp1 >> 4) | (temp2 << 4);
                        NUMBER->NUM[j-3][i][2] = (temp2 << 4) & 0x0f;
                    // } else if(j == 1) {
                    //     NUMBER->ALB[i][0] = temp1 << 4;
                    //     NUMBER->ALB[i][1] = (temp1 >> 4) | (temp2 << 4);
                    //     NUMBER->ALB[i][2] = (temp2 << 4) & 0x0f;
                    // } else if(j == 0) {
                    //     NUMBER->CHN[i][0] = temp1 << 4;
                    //     NUMBER->CHN[i][1] = (temp1 >> 4) | (temp2 << 4);
                    //     NUMBER->CHN[i][2] = (temp2 << 4) & 0x0f;
                    }
                }
                else
                {
                    if(j >= 3) {
                        NUMBER->NUM[j-3][i][2] = 0;
                        NUMBER->NUM[j-3][i][1] = 0;
                        NUMBER->NUM[j-3][i][0] = 0;
                    // } else if(j == 1) {
                    //     NUMBER->ALB[i][2] = 0;
                    //     NUMBER->ALB[i][1] = 0;
                    //     NUMBER->ALB[i][0] = 0;
                    // } else if(j == 0) {
                    //     NUMBER->CHN[i][2] = 0;
                    //     NUMBER->CHN[i][1] = 0;
                    //     NUMBER->CHN[i][0] = 0;
                    }
                }  
            }

            else if(diff == 2)
            {
                if((coordinate[1] - coordinate[0]) >= i)
                {
                    if(j >= 3) {
                        temp = 0xff >> (7 - start_bit);
                        temp = ~temp;
                        NUMBER->NUM[j-3][i][0] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;

                        NUMBER->NUM[j-3][i][1] =  CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1];

                        temp = 0xff << (end_bit + 1);
                        temp = ~temp;
                        NUMBER->NUM[j-3][i][2] = CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] & temp;
                    // } else if(j == 1) {
                    //     temp = 0xff >> (7 - start_bit);
                    //     temp = ~temp;
                    //     NUMBER->ALB[i][0] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;

                    //     NUMBER->ALB[i][1] =  CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1];

                    //     temp = 0xff << (end_bit + 1);
                    //     temp = ~temp;
                    //     NUMBER->ALB[i][2] = CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] & temp;
                    // // } else if(j == 0) {
                    //     temp = 0xff >> (7 - start_bit);
                    //     temp = ~temp;
                    //     NUMBER->CHN[i][0] = CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] & temp;

                    //     NUMBER->CHN[i][1] =  CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1];

                    //     temp = 0xff << (end_bit + 1);
                    //     temp = ~temp;
                    //     NUMBER->CHN[i][2] = CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] & temp;
                    }
                }
                else
                {
                    if(j >= 3) {
                        NUMBER->NUM[j-3][i][2] = 0;
                        NUMBER->NUM[j-3][i][1] = 0;
                        NUMBER->NUM[j-3][i][0] = 0;
                    // } else if(j == 1) {
                    //     NUMBER->ALB[i][2] = 0;
                    //     NUMBER->ALB[i][1] = 0;
                    //     NUMBER->ALB[i][0] = 0;
                    // } else if(j == 0) {
                    //     NUMBER->CHN[i][2] = 0;
                    //     NUMBER->CHN[i][1] = 0;
                    //     NUMBER->CHN[i][0] = 0;
                    }
                }  
            }

            else if(diff == 3)
            {
                if((coordinate[1] - coordinate[0]) >= i)
                {
                    if(j >= 3) {
                        NUMBER->NUM[j-3][i][0] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] << (8 - start_bit));
                        NUMBER->NUM[j-3][i][1] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] << (8 - start_bit));
                        NUMBER->NUM[j-3][i][2] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] << (8 - start_bit));
                        NUMBER->NUM[j-3][i][2] &= ~(0xff << (8 - start_bit + end_bit));
                    // } else if(j == 1) {
                    //     NUMBER->ALB[i][0] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] << (8 - start_bit));
                    //     NUMBER->ALB[i][1] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] << (8 - start_bit));
                    //     NUMBER->ALB[i][2] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] << (8 - start_bit));
                    //     NUMBER->ALB[i][2] &= ~(0xff << (8 - start_bit + end_bit));
                    // } else if(j == 0) {
                    //     NUMBER->CHN[i][0] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] << (8 - start_bit));
                    //     NUMBER->CHN[i][1] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 1] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] << (8 - start_bit));
                    //     NUMBER->CHN[i][2] = (CAMERA->CAMERA_VALUE[coordinate[0] + i][start_byte + 2] >> start_bit) | (CAMERA->CAMERA_VALUE[coordinate[0] + i][end_byte] << (8 - start_bit));
                    //     NUMBER->CHN[i][2] &= ~(0xff << (8 - start_bit + end_bit));
                    }
                }
                else
                {
                    if(j >= 3) {
                        NUMBER->NUM[j-3][i][2] = 0;
                        NUMBER->NUM[j-3][i][1] = 0;
                        NUMBER->NUM[j-3][i][0] = 0;
                    // } else if(j == 1) {
                    //     NUMBER->ALB[i][2] = 0;
                    //     NUMBER->ALB[i][1] = 0;
                    //     NUMBER->ALB[i][0] = 0;
                    // } else if(j == 1) {
                    //     NUMBER->CHN[i][2] = 0;
                    //     NUMBER->CHN[i][1] = 0;
                    //     NUMBER->CHN[i][0] = 0;
                    }
                }  
            }
        }
    }
    
    uint8_t ver_diff = 0;
    ver_diff = coordinate[1] - coordinate[0];

    int8_t ver_shift = 0;
    if(ver_diff < 50) {
        ver_shift = (50 - ver_diff) >> 1;
        for(i = ver_diff;i <= ver_diff;i--) {
            for(j = 0;j < 3;j++)
            {
                // //NUMBER->CHN[i + ver_shift][j] = NUMBER->CHN[i][j];
                // //NUMBER->ALB[i + ver_shift][j] = NUMBER->ALB[i][j];
                // if(i < ver_shift) {
                //     //NUMBER->CHN[i][j] = 0;
                //     NUMBER->ALB[i][j] = 0;
                // }
                for(k = 0;k < 5;k++) {
                    NUMBER->NUM[k][i + ver_shift][j] = NUMBER->NUM[k][i][j];
                    if(i < ver_shift) {
                        NUMBER->NUM[k][i][j] = 0;
                    }
                }
            }
        }
    }

}

void Calibration(void)
{
    signed char i,j,k,m;
    uint8_t left,right;
    uint8_t flag = 0;
    uint8_t shift;
    uint8_t temp;

    for(i = 0;i < 5;i++)
    {
        flag = 0;
        for(j = 0;j < 3;j++)
        {
            for(k = 0;k < 8;k++)
            {
                for(m = 0;m < 50;m++)
                {
                    temp = NUMBER->NUM[i][m][j];
                    temp &= 1 << k;
                    if(temp != 0)
                    {
                        left = (j << 3) + k;
                        flag = 1;
                        break;
                    }
                }
            if(flag) break;
            }
        if(flag) break;
        }

        flag = 0;
        for(j = 2;j <= 2;j--)
        {
            for(k = 8;k <= 8;k--)
            {
                for(m = 0;m < 50;m++)
                {
                    temp = NUMBER->NUM[i][m][j];
                    temp &= 1 <<  k;
                    if(temp != 0)
                    {
                        right = (j << 3) + k;
                        flag = 1;
                        break;
                    }
                }
            if(flag) break;
            }
        if(flag) break;
        }

        shift = ((23 - right) + left) >> 1;

        if(shift > left)
        {
            shift -= left;
            for(j = 0;j < 50;j++)
            {
                NUMBER->NUM[i][j][2] <<= shift;
                NUMBER->NUM[i][j][2] |= NUMBER->NUM[i][j][1] >> (8 - shift);
                NUMBER->NUM[i][j][1] <<= shift;
                NUMBER->NUM[i][j][1] |= NUMBER->NUM[i][j][0] >> (8 - shift);
                NUMBER->NUM[i][j][0] <<= shift;
            }
        }
        else if(shift < left)
        {
            shift = left - shift;
            for(j = 0;j < 50;j++)
            {
                NUMBER->NUM[i][j][0] >>= shift;
                NUMBER->NUM[i][j][0] |= NUMBER->NUM[i][j][1] << (8 - shift);
                NUMBER->NUM[i][j][1] >>= shift;
                NUMBER->NUM[i][j][1] |= NUMBER->NUM[i][j][2] << (8 - shift);
                NUMBER->NUM[i][j][2] >>= shift;
            }
        }
    }

    // flag = 0;
    // for(j = 0;j < 3;j++)
    // {
    //     for(k = 0;k < 8;k++)
    //     {
    //         for(m = 0;m < 50;m++)
    //         {
    //             temp = NUMBER->CHN[m][j];
    //             temp &= 1 << k;
    //             if(temp != 0)
    //             {
    //                 left = (j << 3) + k;
    //                 flag = 1;
    //                 break;
    //             }
    //         }
    //     if(flag) break;
    //     }
    // if(flag) break;
    // }

    // flag = 0;
    // for(j = 2;j >= 0;j--)
    // {
    //     for(k = 8;k >= 0;k--)
    //     {
    //         for(m = 0;m < 50;m++)
    //         {
    //             temp = NUMBER->CHN[m][j];
    //             temp &= 1 <<  k;
    //             if(temp != 0)
    //             {
    //                 right = (j << 3) + k;
    //                 flag = 1;
    //                 break;
    //             }
    //         }
    //     if(flag) break;
    //     }
    // if(flag) break;
    // }

    // shift = ((23 - right) + left) >> 1;

    // if(shift > left)
    // {
    //     shift -= left;
    //     for(j = 0;j < 50;j++)
    //     {
    //         NUMBER->CHN[j][2] <<= shift;
    //         NUMBER->CHN[j][2] |= NUMBER->CHN[j][1] >> (8 - shift);
    //         NUMBER->CHN[j][1] <<= shift;
    //         NUMBER->CHN[j][1] |= NUMBER->CHN[j][0] >> (8 - shift);
    //         NUMBER->CHN[j][0] <<= shift;
    //     }
    // }
    // else if(shift < left)
    // {
    //     shift = left - shift;
    //     for(j = 0;j < 50;j++)
    //     {
    //         NUMBER->CHN[j][0] >>= shift;
    //         NUMBER->CHN[j][0] |= NUMBER->CHN[j][1] << (8 - shift);
    //         NUMBER->CHN[j][1] >>= shift;
    //         NUMBER->CHN[j][1] |= NUMBER->CHN[j][2] << (8 - shift);
    //         NUMBER->CHN[j][2] >>= shift;
    //     }
    // }

    // flag = 0;
    // for(j = 0;j < 3;j++)
    // {
    //     for(k = 0;k < 8;k++)
    //     {
    //         for(m = 0;m < 50;m++)
    //         {
    //             temp = NUMBER->ALB[m][j];
    //             temp &= 1 << k;
    //             if(temp != 0)
    //             {
    //                 left = (j << 3) + k;
    //                 flag = 1;
    //                 break;
    //             }
    //         }
    //     if(flag) break;
    //     }
    // if(flag) break;
    // }

    // flag = 0;
    // for(j = 2;j <= 2;j--)
    // {
    //     for(k = 8;k <= 8;k--)
    //     {
    //         for(m = 0;m < 50;m++)
    //         {
    //             temp = NUMBER->ALB[m][j];
    //             temp &= 1 <<  k;
    //             if(temp != 0)
    //             {
    //                 right = (j << 3) + k;
    //                 flag = 1;
    //                 break;
    //             }
    //         }
    //     if(flag) break;
    //     }
    // if(flag) break;
    // }

    // shift = ((23 - right) + left) >> 1;

    // if(shift > left)
    // {
    //     shift -= left;
    //     for(j = 0;j < 50;j++)
    //     {
    //         NUMBER->ALB[j][2] <<= shift;
    //         NUMBER->ALB[j][2] |= NUMBER->ALB[j][1] >> (8 - shift);
    //         NUMBER->ALB[j][1] <<= shift;
    //         NUMBER->ALB[j][1] |= NUMBER->ALB[j][0] >> (8 - shift);
    //         NUMBER->ALB[j][0] <<= shift;
    //     }
    // }
    // else if(shift < left)
    // {
    //     shift = left - shift;
    //     for(j = 0;j < 50;j++)
    //     {
    //         NUMBER->ALB[j][0] >>= shift;
    //         NUMBER->ALB[j][0] |= NUMBER->ALB[j][1] << (8 - shift);
    //         NUMBER->ALB[j][1] >>= shift;
    //         NUMBER->ALB[j][1] |= NUMBER->ALB[j][2] << (8 - shift);
    //         NUMBER->ALB[j][2] >>= shift;
    //     }
    // }

}