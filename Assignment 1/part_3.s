.global _start
n: .word 5
Array: .word -1,23, 0,12,-7
_start:




LDR r0,=n
LDR r1,[r0] //r1 hold the length of the array as well as the a counter for the outer loop


outer_loop: 
MOV r4, r1  //r4 will be the counter for the inner loop
SUBS r1,r1,#1 //decrease 
BEQ end //branch to end if the outerloop counter reached 0
ADD r3, r0,#4//r3 points to the first element in the array
ADD r5,r3,#4 //r5 points to the second element in the array
B inner_loop

inner_loop:
SUBS r4,r4,#1
BEQ outer_loop
LDR r6,[r3] //r6 hold the value stored in the address that r3 hold
LDR r8,[r5] //r8 hold the second element
CMP r6,r8
BGT swap //swap if r6 is greater than r8
ADD r3,r3,#4
ADD r5,r5,#4
B inner_loop



swap:
MOV r2,r8
MOV r8,r6
MOV r6,r2
STR r6,[r3]
STR r8,[r5]
ADD r3,r3,#4
ADD r5,r5,#4
B inner_loop







end: B end