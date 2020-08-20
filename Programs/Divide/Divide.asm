; Divide

; Initialize
INIT:
	LD	r0,	0		; Clear Remainder
	LD	r1,	75		; Numerator
	LD	r2,	5		; Denominator
	LD	r3,	8		; Counter
	LD	r6,	1		; Shift Left Amount (always 1)
	LD	r7,	7		; Shift Right Amount (always 7)
	
DIVIDE_TOP:
	; Shift upper half
	MOV	acc,	r6
	SHL	r0
	MOV	r0,	out
	MOV	acc,	r7
	SHR	r1
	MOV	acc,	out
	OR	r0
	MOV	r0,	out
	
	; Shift lower half
	MOV	acc,	r6
	SHL	r1
	MOV	r1,	out
	
	; Compare
	MOV	acc,	r2
	CMP	r0
	
	; r0 < r2, can't subtract
	JL	DEC_COUNTER
	
	; r0 >= r2, subtract
	SUB	r0
	MOV	r0,	out
	INC	r1
	MOV	r1,	out
	
DEC_COUNTER:
	; Decrement counter, then check to see if r3 > 0
	DEC	r3
	MOV	r3,	out
	CMP	r3
	JT	DIVIDE_TOP
	
END_PROGRAM:
	JMP	END_PROGRAM
