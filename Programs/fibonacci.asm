#include "include/base.asm"
#include "include/fibonacci.asm"

main:
.app_loop:
	CALL	fibonacci
	JMP	.app_loop
	RET

