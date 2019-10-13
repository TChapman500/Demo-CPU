; Add 16
BEGIN:
	LDR	r0, 22H
	LDR	r1, 23H
	LDR	r2, 24H
	LDR	r3, 25H
	MOV	acc, r2
	ADD	r0
	MOV	r0, out
	JC	17H
	LDR	r2, 0
	JMP	19H
CARRY:
	LDR	r2, 1
POST_CARRY:
	MOV	acc, r3	
	ADD	r1
	MOV	r1, out
	MOV	acc, r2
	ADD	r1
	MOV	r1, out
LOOP:
	JMP	1FH
	