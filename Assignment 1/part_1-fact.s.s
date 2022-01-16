.global _start

testing:.word 3
_start:
MOV r1,#10
BL factorial
MOV r0,r1
end: B end

factorial:
push {r2,lr}
CMP r1,#1
BEQ baseCase
MOV r2,r1
SUB r1,r1,#1
BL factorial
MUL r1,r1,r2
B return


baseCase:
MOV r1,#1
B return

return:
pop {r2,lr}
BX lr





