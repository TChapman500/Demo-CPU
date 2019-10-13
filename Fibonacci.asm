; Fibonacci
START:
	LD	r0, 0
	LD	r1, 1
LOOP:
	MOV	acc, r1
	ADD	r0
	MOV	r2, out
	JC	0
	ST	19H, r1
	ST	1AH, r2
	LDR	19H, r0
	LDR	1AH, r1
	JMP	4
