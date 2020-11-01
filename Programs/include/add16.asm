; add16 function
; extern "C" unsigned short add16(char al, char ah, char bl, char bh);
; use #include "add16.asm"

;	push bh
;	push bl
;	push ah
;	push al
;	CALL add16
;	ld	r5, 4
;	add	r7
;	mov	r7, out
add16:
	; Copy stack pointer to r6
	PUSH	r7
	POP	r6
	
	; Preserve registers that will be used here
	PUSH	adr
	
	; Load adr with the address of the first argument
	LD	adrh, 8
	LD	r5, 3
	ADD	r6
	MOV	adrl, r6
	
	; Load al into r0
	LD	r0, [adr]
	
	; Increment stack pointer by 2
	ADD	r6
	MOV	adrl, r6
	
	; Load bl into acc
	LD	r5, [adr]
	
	; Add and store result into r0
	ADD	r0
	MOV	r0, out
	
	; Preserve flags register
	PUSH	flags
	
	; reload r6 from adrl
	MOV	r6, adrl
	DEC	r6
	MOV	adrl, r6
	
	; Load ah into r1
	LD	r1, [adr]
	
	; Increment stack pointer by 2
	LD	r5, 2
	ADD	r6
	MOV	adrl, r6
	
	; Load bh into acc
	LD	r5, [adr]
	
	; Restore flags register
	POP	flags
	
	; ah + bh + carry
	ADC	r1
	MOV	r1, out
	
	; Restore address register
	POP	adr
	
	; Done
	RET
