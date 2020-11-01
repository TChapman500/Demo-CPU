; For use with the binary to bcd converter from my logisim library.

; Modify values based on address of binary->bcd converter
BIN_BCD_IN	= 0x1000
BIN_BCD_SIG	= 0x1001

; extern "C" void write_bcd(char value);
write_bcd:
	; Copy stack pointer to output register
	PUSH	r7
	POP	r6
	
	; Preserve flags, r0, and adr
	PUSH	flags
	PUSH	r0
	PUSH	adr
	
	; Retrieve number from stack
	LD	adrh, 8
	LD	r5, 3
	ADD	r6
	MOV	adrl, r6
	
	; Load number from argument
	LD	r0, [adr]
	ST	[BIN_BCD_IN], r0
	LD	r0, 1
	ST	[BIN_BCD_SIG], r0
	
	; Restore r0, flags, and adr
	POP	adr
	POP	r0
	POP	flags
	
	RET
