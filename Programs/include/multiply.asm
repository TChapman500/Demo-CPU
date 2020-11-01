; extern "C" unsigned short multiply(unsigned char a, unsigned char b);
multiply:
	; Copy stack pointer to r6
	PUSH	r7
	POP	r6
	
	; Preserve registers that will be used here
	PUSH	adr
	PUSH	r2		; A
	PUSH	r3		; B
	PUSH	r4		; counter
	
	; Initialize counter
	LD	r4, 8
	
	; Initialize Shift Registers (r0 and r1)
	LD	r0, 0
	LD	r1, 0
	
	; Load adr with the address of the first argument
	LD	adrh, 8
	LD	r5, 3
	ADD	r6
	MOV	adrl, r6
	
	; First Argument
	LD	r2, [adr]	; Local copy of first argument
	
	; Get second argument
	INC	r6
	MOV	adrl, r6
	
	; Second Argument
	LD	r3, [adr]
.mul_loop:
	; Check if B0 is 1
	LD	r5, 1		; Mask for B
	AND	r3
	JZ	.shift
	
	; Add A to upper half if B0 is 1.
	MOV	acc, r2
	ADD	r1
	MOV	r1, out
	
.shift:
	; Preserve Flags Register
	PUSH	flags

	; shift lower half right 1 bit.
	LD	r5, 1
	SHR	r0
	MOV	r0, out		; r0 = r0 >> 1
	
	; Shift upper half left 7 bits.
	LD	r5, 7
	SHL	r1		; r6 = r1 << 7
	
	; Or with lower half.
	MOV	acc, r0
	OR	r6
	MOV	r0, out		; r0 = (r1 << 7) | (r0 >> 1)
	
	; Shift upper half right 1 bit.
	LD	r5, 1
	SHR	r1
	MOV	r1, out		; r1 = r1 >> 1
	
	; Restore flags register and bring in carry bit.
	POP	flags
	JNC	.post_shift
	LD	r5, 128
	OR	r1
	MOV	r1, out
	
.post_shift:
	; Shift Second Argument right 1 bit.
	LD	r5, 1
	SHR	r3
	MOV	r3, out		; B = B >> 1
	
	; Decrement Counter
	DEC	r4
	MOV	r4, out		; counter = counter - 1
	JNZ	.mul_loop
	
	; Restore original register values and return.
	POP	r4
	POP	r3
	POP	r2
	POP	adr
	RET
