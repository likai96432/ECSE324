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
pop {r2,lr}
BX LR
notpressed:
MOV R1,#0
pop {r2,lr}
BX LR

read_PB_edgecp_ASM:
	
		PUSH {R1}
	LDR R0, =EDGECAPTURE_REGISTER
	LDR R1, [R0]
	
	MOV R0 , R1
	POP {R1}	
	
	BX LR
PB_edgecp_is_pressed_ASM:
push {r2,LR}
MOV R2,R0
bL read_PB_edgecp_ASM
tst r0,r2
BGT pressed
Ble notpressed



BNE pressed
BEQ notpressed
PB_clear_edgecp_ASM:
PUSH {R2,R3}
LDR R3, =EDGECAPTURE_REGISTER
LDR R2, [r3]
STR R2, [r3]
POP {R2,R3}
BX LR
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


.equ Timer_Load, 0xFFFEC600
.equ Timer_Counter, 0xFFFEC604
.equ Timer_Control, 0xFFFEC608
.equ Timer_Interrupt, 0xFFFEC60C

ARM_TIM_config_ASM:
	PUSH {r4}
	LDR r4, =Timer_Load
	STR R0, [r4]
	LDR r4, =Timer_Control
	STR R1, [V4]
	POP {r4}
	BX LR
	
/*
	Reads the interrupt status in
	the corresponding register.
	
	Returns result via R0.
*/
ARM_TIM_read_INT_ASM:
	LDR R0, =Timer_Interrupt
	LDR R0, [R0]

		BX LR
		

/*
	Clears the interrupt status in
	the corresponding register.
*/
ARM_TIM_clear_INT_ASM: 
LDR R0, =Timer_Interrupt
LDR R0, [R0]
cmp r0,#1
BEQ clearTIM
BNE Done
clearTIM:
push {r2}
ldr r2,=Timer_Interrupt
str r0, [r2]
pop {r2}
B Done
Done:bx lr
frequency: .word 0x30D40
_start:
 //set the load to 2000000
mov r2,#0
mov r3,#0
mov r4,#0
mov r5,#0
mov r6,#0
mov r7,#0
mov r8,#0
mov r9,#0
mov r10,#0
LDR R0, frequency
mov r1,#0
Bl ARM_TIM_config_ASM


loop:
ifinterrupt:
BL ARM_TIM_read_INT_ASM
CMP R0, #1
BEQ  update10ms
BNE checkButton


setenable1:
ldr r1,=Timer_Control
mov r9,#3
STR r9,[r1]
B update10ms

setenable2:
ldr r1,=Timer_Control
mov r9,#2
STR r9,[r1]
B loop

setenable3:
mov r1,#0
mov r0,#0x00000001
BL HEX_write_ASM
mov r0,#0x00000002
BL HEX_write_ASM
mov r0,#0x00000004
BL HEX_write_ASM
mov r0,#0x00000008
BL HEX_write_ASM
mov r0,#0x00000010
BL HEX_write_ASM
mov r0,#0x00000020
BL HEX_write_ASM
mov r2,#0
mov r3,#0
mov r4,#0
mov r5,#0
mov r6,#0
mov r7,#0
mov r8,#0
mov r9,#0
mov r10,#0
B loop



B checkInterrupt
update10ms:

add r11,r11,#1
cmp r11,#10
BEQ updateHEX0


B checkInterrupt

updateHEX0:
mov r11,#0
add r2,r2,#1
cmp r2,#10
BEQ updateHEX1
mov r1,r2
mov r0,#0x00000001
BL HEX_write_ASM

B checkInterrupt

updateHEX1:
mov r1,#0
mov r0,#0x00000001
mov r2,#0
add r3,r3,#1
cmp r3,#10
BEQ updateHEX2
mov r1,r3
mov r0,#0x00000002
BL HEX_write_ASM

B checkInterrupt
updateHEX2:
mov r1,#0
mov r0,#0x00000002
BL HEX_write_ASM
mov r3,#0
add r4,r4,#1
cmp r4,#10
BEQ updateHEX3
mov r1,r4
mov r0,#0x00000004
BL HEX_write_ASM

B checkInterrupt
updateHEX3:
mov r1,#0
mov r0,#0x00000004
BL HEX_write_ASM
mov r4,#0
add r5,r5,#1
cmp r5,#6
BEQ updateHEX4
mov r1,r5
mov r0,#0x00000008
BL HEX_write_ASM

B checkInterrupt
updateHEX4:
mov r1,#0
mov r0,#0x00000008
BL HEX_write_ASM
mov r5,#0
add r6,r6,#1
cmp r6,#10
BEQ updateHEX5
mov r1,r6
MOV R0 , #0x00000010
BL HEX_write_ASM

B checkInterrupt
updateHEX5:
mov r1,#0
mov r0,#0x000000020
mov r6,#0
add r7,r7,#1
cmp r7,#10
BEQ checkInterrupt
mov r1,r7
mov r0,#0x00000020
BL HEX_write_ASM

B checkInterrupt
checkInterrupt:
BL ARM_TIM_clear_INT_ASM
B checkButton
checkButton:
Bl read_PB_edgecp_ASM
Bl PB_clear_edgecp_ASM
cmp r0,#1
BEQ setenable1
cmp r0,#2
beq setenable2
cmp r0,#4
beq setenable3

B loop