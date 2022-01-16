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

valid:
STRB r4,[r0]
mov r0,#1
pop {r3-r6,lr}
bx lr


notValidData:
mov r0,#0
pop {r3-r6,lr}
bx lr

@ TODO: adapt this function to draw a real-life flag of your choice.
draw_real_life_flag:
         push    {r4, lr}
        sub     sp, sp, #8
        ldr     r3,.flags_real_flag
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #320
        mov     r1, #0
        mov     r0, r1
        bl      draw_rectangle
        ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #20
        mov     r1, #50
        mov     r0, #30
        bl      draw_star
		 ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #10
        mov     r1, #20
        mov     r0, #60
        bl      draw_star
		 ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #10
        mov     r1, #40
        mov     r0, #80
        bl      draw_star
		 ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #10
        mov     r1, #70
        mov     r0, #80
        bl      draw_star
		 ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #10
        mov     r1, #90
        mov     r0, #60
        bl      draw_star
 
        add     sp, sp, #8
        pop     {r4, pc}
.flags_real_flag:
        
        .word   63491
        .word   65507
@ TODO: adapt this function to draw an imaginary flag of your choice.
draw_imaginary_flag:
         push    {r4, lr}
        sub     sp, sp, #8
		 ldr     r3,.flags_imaginary_flag+4
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #320
        mov     r1, #0
        mov     r0, r1
        bl      draw_rectangle
        ldr     r3, .flags_imaginary_flag
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #60
        mov     r1, #0
        mov     r0, #130
        bl      draw_rectangle
		 ldr     r3, .flags_L32
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #40
        mov     r1, #0
        mov     r0, #40
        bl      draw_rectangle
		 ldr     r3,.flags_real_flag+4
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #40
        mov     r1, #0
        mov     r0, #240
        bl      draw_rectangle
		
		 ldr     r3,.flags_imaginary_flag
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #40
        mov     r1, #0
        mov     r0, #0
        bl      draw_rectangle
		 ldr     r3,.flags_L32
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #40
        mov     r1, #0
        mov     r0, #280
        bl      draw_rectangle
		 ldr     r4, .flags_L32+4
        mov     r3, r4
        mov     r2, #30
        mov     r1, #120
        mov     r0, #160
        bl      draw_star
		 ldr     r4, .flags_real_flag+4
        mov     r3, r4
        mov     r2, #40
        mov     r1, #120
        mov     r0, #40
        bl      draw_star
			 ldr     r4,.flags_real_flag
        mov     r3, r4
        mov     r2, #20
        mov     r1, #120
        mov     r0, #40
        bl      draw_star
			 ldr     r4, .flags_L32
        mov     r3, r4
        mov     r2, #20
        mov     r1, #120
        mov     r0, #260
        bl      draw_star
		
      
        add     sp, sp, #8
        pop     {r4, pc}
		
.flags_imaginary_flag:
        
        .word   63491
		.word   65535
        .word   65507

draw_texan_flag:
       push    {r4, lr}
        sub     sp, sp, #8
        ldr     r3, .flags_L32
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #106
        mov     r1, #0
        mov     r0, r1
        bl      draw_rectangle
        ldr     r4, .flags_L32+4
        mov     r3, r4
        mov     r2, #43
        mov     r1, #120
        mov     r0, #53
        bl      draw_star
        str     r4, [sp]
        mov     r3, #120
        mov     r2, #214
        mov     r1, #0
        mov     r0, #106
        bl      draw_rectangle
        ldr     r3, .flags_L32+8
        str     r3, [sp]
        mov     r3, #120
        mov     r2, #214
        mov     r1, r3
        mov     r0, #106
        bl      draw_rectangle
        add     sp, sp, #8
        pop     {r4, pc}
.flags_L32:
        .word   2911
        .word   65535
        .word   45248

draw_rectangle:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        ldr     r7, [sp, #32]
        add     r9, r1, r3
        cmp     r1, r9
        popge   {r4, r5, r6, r7, r8, r9, r10, pc}
        mov     r8, r0
        mov     r5, r1
        add     r6, r0, r2
        b       .flags_L2
.flags_L5:
        add     r5, r5, #1
        cmp     r5, r9
        popeq   {r4, r5, r6, r7, r8, r9, r10, pc}
.flags_L2:
        cmp     r8, r6
        movlt   r4, r8
        bge     .flags_L5
.flags_L4:
        mov     r2, r7
        mov     r1, r5
        mov     r0, r4
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        cmp     r4, r6
        bne     .flags_L4
        b       .flags_L5
should_fill_star_pixel:
        push    {r4, r5, r6, lr}
        lsl     lr, r2, #1
        cmp     r2, r0
        blt     .flags_L17
        add     r3, r2, r2, lsl #3
        add     r3, r2, r3, lsl #1
        lsl     r3, r3, #2
        ldr     ip, .flags_L19
        smull   r4, r5, r3, ip
        asr     r3, r3, #31
        rsb     r3, r3, r5, asr #5
        cmp     r1, r3
        blt     .flags_L18
        rsb     ip, r2, r2, lsl #5
        lsl     ip, ip, #2
        ldr     r4, .flags_L19
        smull   r5, r6, ip, r4
        asr     ip, ip, #31
        rsb     ip, ip, r6, asr #5
        cmp     r1, ip
        bge     .flags_L14
        sub     r2, r1, r3
        add     r2, r2, r2, lsl #2
        add     r2, r2, r2, lsl #2
        rsb     r2, r2, r2, lsl #3
        ldr     r3, .flags_L19+4
        smull   ip, r1, r3, r2
        asr     r3, r2, #31
        rsb     r3, r3, r1, asr #5
        cmp     r3, r0
        movge   r0, #0
        movlt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L17:
        sub     r0, lr, r0
        bl      should_fill_star_pixel
        pop     {r4, r5, r6, pc}
.flags_L18:
        add     r1, r1, r1, lsl #2
        add     r1, r1, r1, lsl #2
        ldr     r3, .flags_L19+8
        smull   ip, lr, r1, r3
        asr     r1, r1, #31
        sub     r1, r1, lr, asr #5
        add     r2, r1, r2
        cmp     r2, r0
        movge   r0, #0
        movlt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L14:
        add     ip, r1, r1, lsl #2
        add     ip, ip, ip, lsl #2
        ldr     r4, .flags_L19+8
        smull   r5, r6, ip, r4
        asr     ip, ip, #31
        sub     ip, ip, r6, asr #5
        add     r2, ip, r2
        cmp     r2, r0
        bge     .flags_L15
        sub     r0, lr, r0
        sub     r3, r1, r3
        add     r3, r3, r3, lsl #2
        add     r3, r3, r3, lsl #2
        rsb     r3, r3, r3, lsl #3
        ldr     r2, .flags_L19+4
        smull   r1, ip, r3, r2
        asr     r3, r3, #31
        rsb     r3, r3, ip, asr #5
        cmp     r0, r3
        movle   r0, #0
        movgt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L15:
        mov     r0, #0
        pop     {r4, r5, r6, pc}
.flags_L19:
        .word   1374389535
        .word   954437177
        .word   1808407283
draw_star:
        push    {r4, r5, r6, r7, r8, r9, r10, fp, lr}
        sub     sp, sp, #12
        lsl     r7, r2, #1
        cmp     r7, #0
        ble     .flags_L21
        str     r3, [sp, #4]
        mov     r6, r2
        sub     r8, r1, r2
        sub     fp, r7, r2
        add     fp, fp, r1
        sub     r10, r2, r1
        sub     r9, r0, r2
        b       .flags_L23
.flags_L29:
        ldr     r2, [sp, #4]
        mov     r1, r8
        add     r0, r9, r4
        bl      VGA_draw_point_ASM
.flags_L24:
        add     r4, r4, #1
        cmp     r4, r7
        beq     .flags_L28
.flags_L25:
        mov     r2, r6
        mov     r1, r5
        mov     r0, r4
        bl      should_fill_star_pixel
        cmp     r0, #0
        beq     .flags_L24
        b       .flags_L29
.flags_L28:
        add     r8, r8, #1
        cmp     r8, fp
        beq     .flags_L21
.flags_L23:
        add     r5, r10, r8
        mov     r4, #0
        b       .flags_L25
.flags_L21:
        add     sp, sp, #12
        pop     {r4, r5, r6, r7, r8, r9, r10, fp, pc}
input_loop:
        push    {r4, r5, r6, r7, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      draw_texan_flag
        mov     r6, #0
        mov     r4, r6
        mov     r5, r6
        ldr     r7, .flags_L52
        b       .flags_L39
.flags_L46:
        bl      draw_real_life_flag
.flags_L39:
        strb    r5, [sp, #7]
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .flags_L39
        cmp     r6, #0
        movne   r6, r5
        bne     .flags_L39
        ldrb    r3, [sp, #7]    @ zero_extendqisi2
        cmp     r3, #240
        moveq   r6, #1
        beq     .flags_L39
        cmp     r3, #28
        subeq   r4, r4, #1
        beq     .flags_L44
        cmp     r3, #35
        addeq   r4, r4, #1
.flags_L44:
        cmp     r4, #0
        blt     .flags_L45
        smull   r2, r3, r7, r4
        sub     r3, r3, r4, asr #31
        add     r3, r3, r3, lsl #1
        sub     r4, r4, r3
        bl      VGA_clear_pixelbuff_ASM
        cmp     r4, #1
        beq     .flags_L46
        cmp     r4, #2
        beq     .flags_L47
        cmp     r4, #0
        bne     .flags_L39
        bl      draw_texan_flag
        b       .flags_L39
.flags_L45:
        bl      VGA_clear_pixelbuff_ASM
.flags_L47:
        bl      draw_imaginary_flag
        mov     r4, #2
        b       .flags_L39
.flags_L52:
        .word   1431655766