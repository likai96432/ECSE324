.global _start
_start:
MOV r1,#7  //r1 will be the input para
BL Fibonacci //call the function
MOV r0,r1   //get the value of r1 into r0
SUB R1,R1
SUB R2,R2
SUB R3,R3
SUB R4,R4
end: B end  //infinite loop

Fibonacci:
push {r2,r3,lr}  //push the param into the stack
CMP r1,#3  //compare to see if r1 reach the base case
Blt baseCase 
MOV r2,r1
SUB r1,r2,#1
BL Fibonacci
MOV r3,r1
SUB r1, r2,#2
BL Fibonacci
ADD r1,r1,r3
B return





baseCase:
MOV r1,#1
B return

return:
pop {r2,r3,lr}
BX lr



