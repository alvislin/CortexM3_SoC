;/**************************************************************************//**
; * @file     startup_CMSDK_CM3.s
; * @brief    CMSIS Core Device Startup File for
; *           CMSDK_CM3 Device
; * @version  V3.05
; * @date     09. November 2016
; ******************************************************************************/
;/* Copyright (c) 2011 - 2016 ARM LIMITED
;
;   All rights reserved.
;   Redistribution and use in source and binary forms, with or without
;   modification, are permitted provided that the following conditions are met:
;   - Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
;   - Redistributions in binary form must reproduce the above copyright
;     notice, this list of conditions and the following disclaimer in the
;     documentation and/or other materials provided with the distribution.
;   - Neither the name of ARM nor the names of its contributors may be used
;     to endorse or promote products derived from this software without
;     specific prior written permission.
;   *
;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;   ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
;   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;   POSSIBILITY OF SUCH DAMAGE.
;   ---------------------------------------------------------------------------*/
;/*
;//-------- <<< Use Configuration Wizard in Context Menu >>> ------------------
;*/


; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=4
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x000400

                AREA    HEAP, NOINIT, READWRITE, ALIGN=4
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY, ALIGN=4
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp               
                DCD     Reset_Handler              
                DCD     0               
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     0         
                DCD     SysTick_Handler    
                DCD     KEY0_Handler
                DCD     KEY1_Handler
                DCD     KEY2_Handler
                DCD     KEY3_Handler   
                DCD     DMA_Wakeup_Handler  
                DCD     UART_Handler

       

                AREA    |.text|, CODE, READONLY, ALIGN=4


; Reset Handler

Reset_Handler   PROC
                GLOBAL  Reset_Handler
				ENTRY
                IMPORT  __main
                LDR     R0, =__main
				MOV     R8, R0
                MOV     R9, R8
                BX      R0
                ENDP

SysTick_Handler PROC
                EXPORT SysTick_Handler            [WEAK]
                IMPORT SysTickHandler
                PUSH    {LR}
                BL      SysTickHandler
                POP     {PC}		
                ENDP

KEY0_Handler    PROC
                EXPORT KEY0_Handler            [WEAK]
				IMPORT KEY0
				PUSH	{R0,R1,R2,LR}
                BL		KEY0
				POP		{R0,R1,R2,PC}
                ENDP

KEY1_Handler    PROC
                EXPORT KEY1_Handler            [WEAK]
				IMPORT KEY1
				PUSH	{R0,R1,R2,LR}
                BL		KEY1
				POP		{R0,R1,R2,PC}
                ENDP

KEY2_Handler    PROC
                EXPORT KEY2_Handler            [WEAK]
				IMPORT KEY2
				PUSH	{R0,R1,R2,LR}
                BL		KEY2
				POP		{R0,R1,R2,PC}
                ENDP

KEY3_Handler    PROC
                EXPORT KEY3_Handler            [WEAK]
				IMPORT KEY3
				PUSH	{R0,R1,R2,LR}
                BL		KEY3
				POP		{R0,R1,R2,PC}
                ENDP
                
DMA_Wakeup_Handler    PROC
                EXPORT DMA_Wakeup_Handler            [WEAK]
				BX      LR
                ENDP

UART_Handler    PROC
                EXPORT UART_Handler            [WEAK]
				IMPORT UARTHandle
				PUSH	{R0,R1,R2,LR}
                BL		UARTHandle
				POP		{R0,R1,R2,PC}
                ENDP

                ALIGN 4
					
				IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap

__user_initial_stackheap 

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
     
                ALIGN 

				ENDIF

                END
