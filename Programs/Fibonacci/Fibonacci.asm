; Fibonacci
START:
	LD	r0, 0
	LD	r1, 1
LOOP:
	MOV	acc, r1
	ADD	r0
	MOV	r2, out
	JC	START
	ST	[0x19], r1
	ST	[0x1A], r2
	LD	r0, [0x19]
	LD	r1, [0x1A]
	JMP	LOOP
