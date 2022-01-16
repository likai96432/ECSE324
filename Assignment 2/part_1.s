.global _start

// Sider Switches Driver
// returns the state of slider switches in R0
.equ SW_MEMORY, 0xFF200040
/* The EQU directive gives a symbolic name to a numeric constant,
a register-relative value or a PC-relative value. */
read_slider_switches_ASM:
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
    BX  LR

// LEDs Driver
// writes the state of LEDs (On/Off state) in R0 to the LEDs memory location
.equ LED_MEMORY, 0xFF200000
write_LEDs_ASM:
    LDR R1, =LED_MEMORY
    STR R0, [R1]
    BX  LR


//Hex diplay
.equ HEX_3_0_MEMORY,  0xFF200020  //ACCESS THE 0-3 SEGMENT DISPLAYS
.equ HEX_5_4_MEMORY,  0xFF200030   //ACCES THE 4-5 SEGEMENT DISPLAYS



HEX_clear_ASM:
push {r1-r5,lr}
MOV R1,#1 // BIT TO BE COMPARE WITH
MOV R2,#0 //COUNTER FOR THE LOOP
mov r3,#0x00 //value use to clear the hex
LDR r4,=HEX_3_0_MEMORY //first part of the display
LDR r5,=HEX_5_4_MEMORY// second part of the display

B clear_HEX_LOOP_0_3


HEX_flood_ASM:
push {r1-r5,lr}
MOV R1,#1 // BIT TO BE COMPARE WITH
MOV R2,#0 //COUNTER FOR THE LOOP
mov r3,#0xffffffff //value use to clear the hex
LDR r4,=HEX_3_0_MEMORY //first part of the display
LDR r5,=HEX_5_4_MEMORY// second part of the display

B clear_HEX_LOOP_0_3

clear_HEX_LOOP_0_3:
TST r0,r1
Bgt clear1
ADD r4,r4,#1
LSL R1,#1
add r2,r2,#1
cmp r2,#4

BEQ clear_HEX_LOOP_4_5
cmp r2,#6
BLE clear_HEX_LOOP_0_3



clear1:
STRB r3,[r4]
ADD r4,r4,#1
LSL R1,#1
add r2,r2,#1
cmp r2,#4
BEQ clear_HEX_LOOP_4_5
B clear_HEX_LOOP_0_3

clear_HEX_LOOP_4_5:
TST r0,r1
Bgt clear2
ADD r5,r5,#1
LSL R1,#1
add r2,r2,#1
cmp r2,#6
beq end
B clear_HEX_LOOP_4_5

clear2:
STRB R3,[R5]
ADD r5,r5,#1
LSL R1,#1
add r2,r2,#1
CMP R2,#6
beq end
B clear_HEX_LOOP_4_5

end: 
pop {r1-r5,lr}
Bx lr





HEX_write_ASM:
push {r2-r12,lr}
mov r2,#0
mov r3,#1 //bit to compare
LDR r4,=HEX_3_0_MEMORY //first part of the display
LDR r5,=HEX_5_4_MEMORY// second part of the display

B NumberToWrite


NumberToWrite:
CMP r1,#0
BEQ display0
CMP r1,#1
BEQ display1
CMP r1,#2
BEQ display2
CMP r1,#3
BEQ display3
CMP r1,#4
BEQ display4
CMP r1,#5
BEQ display5
CMP r1,#6
BEQ display6
CMP r1,#7
BEQ display7
CMP r1,#8
BEQ display8
CMP r1,#9
BEQ display9
CMP r1,#10
BEQ display10
CMP  r1,#11
BEQ display11
CMP r1,#12
BEQ display12
CMP r1,#13
BEQ display13
CMP r1,#14
BEQ display14
CMP r1,#15
BEQ display15

display0:
mov R6, #0x0000003F
B Loop_write
display1:
mov R6, #0x00000006
B Loop_write
display2:
mov R6, #0x0000005B
B Loop_write
display3:
mov R6, #0x0000004f
B Loop_write
display4:
mov R6, #0x00000066
B Loop_write
display5:
mov R6, #0x0000006d
B Loop_write
display6:
mov R6,#0x0000007d
B Loop_write
display7:
mov R6,#0x00000007
B Loop_write
display8:
mov R6,#0x0000007f
B Loop_write
display9:
mov R6,#0x0000006F
B Loop_write
display10:
mov R6,#0x00000077
B Loop_write
display11:
mov R6,#0x0000007C
B Loop_write
display12:
mov R6,#0x00000039
B Loop_write
display13:
mov R6,#0x0000005E
B Loop_write
display14:
mov R6,#0x00000079
B Loop_write
display15:
mov R6,#0x00000071
B Loop_write

Loop_write:
TST r0,r3
Bgt write1
ADD r4,r4,#1
LSL R3,#1
add r2,r2,#1
cmp r2,#4
BEQ Loop_write2
B Loop_write



write1:
STRB r6,[r4]
ADD r4,r4,#1
LSL R3,#1
add r2,r2,#1
cmp r2,#4
BEQ Loop_write2
B Loop_write

Loop_write2:
TST r0,r3
Bgt write2
ADD r5,r5,#1
LSL R3,#1
add r2,r2,#1
cmp r2,#6
beq endwrite
B Loop_write2

write2:
STRB R6,[R5]
ADD r5,r5,#1
LSL R3,#1
add r2,r2,#1
CMP R2,#6
beq endwrite
B Loop_write2
 
 
 endwrite:
pop {r2-r12,lr}
BX lr
.equ DATA_REGISTER, 0xFF200050
.equ INTERRUPTMASK_REGISTER, 0xFF200058
.equ EDGECAPTURE_REGISTER, 0xFF20005C

read_PB_data_ASM:
		
	LDR R2 , =DATA_REGISTER
	LDR R0 , [R2]
	
	BX LR

PB_data_is_pressed_ASM:
LDR R2,=DATA_REGISTER
ldr r1,[r2]
TST R0, R1
BGT pressed
BLE notpressed

pressed:
MOV R1,#1
BX LR
notpressed:
MOV R1,#0
BX LR

read_PB_edgecp_ASM:
	
	
	LDR R0, =EDGECAPTURE_REGISTER
	LDR R3, [R0]
	STR R3, [R0]
	MOV R0 , R3
		
	
	BX LR
PB_edgecp_is_pressed_ASM:
LDR R2,=EDGECAPTURE_REGISTER
ldr r1,[r2]
TST R0, R1
BGT pressed
BLE notpressed
PB_clear_edgecp_ASM:
LDR R1,=EDGECAPTURE_REGISTER
MOV R0, #0
STR R0, [R1]
enable_PB_INT_ASM:
LDR R1,=INTERRUPTMASK_REGISTER
MOV R0, #15
STR R0, [R1]
bx lr

disable_PB_INT_ASM:
LDR R1,=INTERRUPTMASK_REGISTER
MOV R0, #0
STR R0, [R1]
BX LR

_start:
	

LOOP:
BL read_slider_switches_ASM
BL write_LEDs_ASM
mov R1,R0
MOV R0 , #0x00000020
BL HEX_flood_ASM
MOV R0 , #0x00000010
BL HEX_flood_ASM
BL read_PB_data_ASM 
BL read_PB_edgecp_ASM
bl HEX_write_ASM
	
B LOOP