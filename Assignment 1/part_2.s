.global _start
Array1: .word 183, 207, 128, 30, 109, 0, 14, 52, 15, 210 ,228, 76, 48, 82, 179, 194, 22, 168, 58, 116,228, 217, 180, 181, 243, 65, 24, 127, 216, 118,64, 210, 138, 104, 80, 137, 212, 196, 150, 139,155, 154, 36, 254, 218, 65, 3, 11, 91, 95,219, 10, 45, 193, 204, 196, 25, 177, 188, 170,189, 241, 102, 237, 251, 223, 10, 24, 171, 71,0, 4, 81, 158, 59, 232, 155, 217, 181, 19,25, 12, 80, 244, 227, 101, 250, 103, 68, 46,136, 152, 144, 2, 97, 250, 47, 58, 214, 51
Array2: .word 1,   1,  0,  -1,  -1,0,   1,  0,  -1,   0,0,   0,  1,   0,   0,0,  -1,  0,   1,   0,-1, -1,  0,   1,   1
Array3: .space 400
n1:.word 10
n2:.word 5


_start:
MOV r0,#0  
MOV r1,#0 
MOV r2,#0 
MOV r3,#0 


loop1: 
CMP R0,#10  //r0 is the counter for loop 1, the biggest loop
BEQ end



loop2:

MOV r4,#0
CMP R1,#10  
BEQ BACK1




loop3:
CMP R2,#5

BEQ reg






loop4:
CMP R3,#5
BEQ Back3


ADD r5,r1,r3 //temp1
SUB r5,r5,#2 //temp1
ADD r6,r0,r2 //temp2
SUB r6,r6,#2 //temp2
B firstC



firstC:
CMP r5,#0
BLt Back4
CMP r5,#9
BGt Back4
CMP r6,#0
BLt Back4
CMP r6,#9
BGt Back4
LDR r7,=Array1
MOV r12,#40
MUL r8, r5,r12
MOV r12,#4
MUL R9,R6,r12
ADD r8,r8,r9
ADD r7,r7,r8
LDR r10,[r7]
LDR r7,=Array2
MOV r12,#20
MUL r8, r3,r12
MOV r12,#4
MUL R9,R2,r12
ADD r8,r8,r9
ADD r7,r7,r8
LDR r11,[r7]
MUL r10,r10,r11
ADD r4,r4,r10
B Back4

BACK1:
ADD R0,R0,#1
MOV R1,#0
b loop1
reg:

LDR r7,=Array3
MOV r12,#40
MUL r8,r1,r12
MOV r12,#4
MUL r9,r0,r12
ADD r8,r8,r9
ADD r7,r7,r8
STR r4,[r7]
ADD r1,r1,#1
MOV R2,#0
B loop2
Back3:
add r2,r2,#1
MOV R3,#0
B loop3
Back4:
add r3,r3,#1
B loop4




end: B end



