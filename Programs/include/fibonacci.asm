#include "include/write_bcd.asm"

fibonacci:
	; Preserve r0 and r1
	PUSH	r0
	PUSH	r1

	; Initialize r0 and r1
	LD	r0, 0
	LD	r1, 1
	
.main_loop:
	; z = x + y
	MOV	acc, r1
	ADD	r0
	
	; x = y
	PUSH	r1
	POP	r0
	
	; y = z
	MOV	r1, out
	
	; End Program
	JC	.end
	
	; Output Result
	PUSH	r1
	CALL	write_bcd
	INC	r7
	MOV	r7, out
	
	; Next iteration
	JMP	.main_loop
	
.end:
	; Restore r0 and r1
	POP	r1
	POP	r0
	RET
