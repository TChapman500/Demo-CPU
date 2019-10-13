# Enhanced Demo CPU
This is an enhancement of the restored Demo CPU.  This CPU modifies several of the jump conditions (maintaining backwards compatibility on most of them) and the flags.  It also adds a second output to the ALU for retrieving the upper half of a multiply operation.  You will be able to access this register with `ST imm16, outH`, `MOV acc, outH`, and `MOV rX, outH` instructions.  Two new ALU operations are also included:  `ADC rX` and `SBB rX`, which adds or subtracts the carry flag.

For this CPU to work, you will need the latest version of [Logisim Evolution (Holy Cross Edition)](https://github.com/kevinawalsh/logisim-evolution) (4.0.1+).

DAT files are raw binary files that can be loaded directly into RAM through the "Load Memory Image..." option.  PROG files hold the exact same data in text format so that it's easier to see what's in it.  ASM files hold a human-readable assembly code of said program.
