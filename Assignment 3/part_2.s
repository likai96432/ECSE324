.global _start
.equ pix_buffer, 0xC8000000
.equ cha_buffer, 0xC9000000
.equ ps_data,0xff200100
_start:
        bl      input_loop
end:
        b       end

@ TODO: copy VGA driver here.
VGA_draw_point_ASM:
push {r3-r6,lr}
mov r3,r0 //x pixel
mov r4,r1 //y pixel
ldr r5,=pix_buffer
mov r6,r2 //get the color
LSL r3,#1
LSL r4,#10
ADD r3,r3,r4
add r5,r5,r3
strh r6,[r5]
pop {r3-r6,lr}

bx lr


VGA_clear_pixelbuff_ASM:
push {r0-r4,lr}
mov r0,#0 //x
mov r1,#1 //y
mov r2,#0
mov r3,#0

CXLOOP:
cmp r0,#320
BEQ endClear
add r0,r0,#1
mov r1,#0
B CYLOOP

CYLOOP:
cmp r1,#240
beq CXLOOP
bl VGA_draw_point_ASM
add r1,r1,#1
B CYLOOP

endClear:
pop {r0-r4,lr}
BX lr

VGA_write_char_ASM:
push {r3-r7,lr}
cmp r0,#-1
BLE notValid
cmp r0,#80
BGE notValid
cmp r1,#-1
ble notValid
cmp r1,#60
bge notValid
mov r3,r0 //x
mov r4,r1 //y
mov r5,r2 //char
ldr r6,=cha_buffer
lsl r4,#7
add r3,r3,r4
add r3,r3,r6
strb r5,[r3]

notValid:
pop {r3-r7,lr}
bx lr

VGA_clear_charbuff_ASM:
push {r0-r4,lr}
mov r0,#0 //x
mov r1,#1 //y
mov r2,#0
mov r3,#0

CXLOOPC:
cmp r0,#80
BEQ endClear
add r0,r0,#1
mov r1,#0
B CYLOOP

CYLOOPC:
cmp r1,#60
beq CXLOOP
bl VGA_write_char_ASM
add r1,r1,#1
B CYLOOP

endClearC:
pop {r0-r4,lr}
BX lr
@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
push {r3-r6,lr}
ldr r3,=ps_data
ldr r4,[r3]
mov r5,r4
ASR R5,R5,#15
TST R5,#1
Beq notValidData
STRB r4,[r0]
mov r0,#1
pop {r3-r6,lr}
bx lr




notValidData:
mov r0,#0
pop {r3-r6,lr}
bx lr



write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}