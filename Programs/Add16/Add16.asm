; Add 16
BEGIN:
	LD	r0, 0x22
	LD	r1, 0x23
	LD	r2, 0x24
	LD	r3, 0x25
	MOV	acc, r2
	ADD	r0
	MOV	r0, out
	JC	CARRY
	LD	r2, 0
	JMP	POST_CARRY
CARRY:
	LD	r2, 1
POST_CARRY:
	MOV	acc, r3	
	ADD	r1
	MOV	r1, out
	MOV	acc, r2
	ADD	r1
	MOV	r1, out
LOOP:
	JMP	LOOP
	
