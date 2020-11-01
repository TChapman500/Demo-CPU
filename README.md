# Ehanched Demo CPU
This is an enhanced version of my original CPU.  This enhancement adds stack management, function call and return instructions, and more data transfer instructions.  It also lays the framework for implementing system interrupts. For this CPU to work, you will need the latest version of [Logisim Evolution (Holy Cross Edition)](https://github.com/kevinawalsh/logisim-evolution) (4.0.4+).  The DemoCPU.cpu file is for use with [customasm](https://github.com/hlorenzi/customasm).

BIN files are raw binary files that can be loaded directly into RAM through the "Load Memory Image..." option.  HEX files hold the exact same data in text format so that it's easier to see what's in it.  ASM files hold a human-readable assembly code of said program.

# Instruction Set
Processor is Little-Endian and the results of all ALU operations are stored in the output register.  All ALU operations are done with the selected GPR as the A input and the accumulator as the B input.  This instruction set is incompatible with the restored version of the CPU, though some instructions will still work with it.

`imm8` is a one-byte number that immediately follows the opcode.  `imm16` is a two-byte number that immediately follows the opcode (little endian order).  `rX` is a general purpose register where `X` is a 3-bit number from 0-7.  These 3 bits make up the 3 least-significant bits of the opcode.  `flags` refers to the flags register, `adr` refers to the address register, and `adrl` and `adrh` refer to the lower half and upper half of the flags register respectively.

| Instruction | Description | Opcode (binary) |
| ----------- | ----------- | --------------- |
| `NOP` | Does nothing. | `00000000` |
| `ISR imm16` | Sets the address of the interrupt service routine. | `00000001` |
| `INT 0` | Disables interrupts. | `00000010` |
| `INT 1` | Enables interrupts. | `00000011` |
| `RTI` | Returns from interrupt service routine. | `00000100` |
| `CALL imm16` | Calls a function at the immediate address. | `00000101` |
| `RET` | Returns from a function. | `00000110` |
| `PUSH flags` | Pushes the flags register to the stack. | `00000111` |
| `POP flags` | Pops the flags register from the stack. | `00001000` |
| `LD adrl, imm8` | Loads the immediate byte into the lower half of the address register. | `00001001` |
| `LD adrh, imm8` | Loads the immediate byte into the upper half of the address register. | `00001010` |
| `LD adr, imm16` | Loads the immediate address into the address register. | `00001011` |
| `LD adr, [imm16]` | Loads the address at the immediate address into the address register. | `00001100` |
| `LD adr, [adr]` | Loads the address at the address in the address register into the address register. | `00001101` |
| `POP adr` | Pops the address register from the stack. | `00001110` |
| `ST [imm16], adr` | Stores the value of the address register at the immediate address. | `00001111` |
| `ST [adr], adr` | Stores the value of the address register at address in the address register. | `00010000` |
| `PUSH adr` | Pushes the address register to the stack. | `00010001` |
| `HLT` | Halts the processor until a reset signal is received. | `00010010` |
| `JMP imm16` | Unconditional jump to immediate address. | `00011000` |
| `JNE/JNZ imm16` | Jumps to the immediate address if the zero flag is cleared. | `00011001` |
| `JE/JZ imm16` | Jumps to the immediate address if the zero flag is set. | `00011010` |
| `JL/JC imm16` | Jumps to the immediate address if the carry flag is set. | `00011011` |
| `JNL/JNC imm16` | Jumps to the immediate address if the carry flag is cleared. | `00011100` |
| `JG imm16` | Jumps to the immediate address if the zero and carry flags are cleared. | `00011101` |
| `JNG imm16` | Jumps to the immediate address if the zero or carry flags are set. | `00011110` |
| `LD rX, imm8` | Loads the immediate byte into the specified register. | `00100xxx` |
| `LD rX, [imm16]` | Loads the byte at the immediate address into the specified register. | `00101xxx` |
| `LD rX, [adr]` | Loads the value stored at the address in the address register into the specified register. | `00110xxx` |
| `POP rX` | Pops the specified register from the stack. | `00111xxx` |
| `ST [imm16], rX` | Stores the value in the specified register at the immediate address. | `01000xxx` |
| `ST [adr], rX` | Stores the value in the specified register at the address in the address register. | `01001xxx` |
| `PUSH rX` | Pushes the specified register onto the stack.. | `01010xxx` |
| `MOV acc, rX` | Copies the value in the specified register into the accumulator. | `01011xxx` |
| `MOV rX, out` | Copies the value in the output register into the specified register. | `01100xxx` |
| `MOV rX, adrl` | Copies the value in the lower half of the address register into the specified register. | `01101xxx` |
| `MOV rX, adrh` | Copies the value in the upper half of the address register into the specified register. | `01110xxx` |
| `MOV adrl, rX` | Copies the value in the specified register into the lower byte of the address register. | `01111xxx` |
| `MOV adrh, rX` | Copies the value in the specified register into the upper byte of the address register. | `10000xxx` |
| `ADC rX` | Adds the accumulator and the carry flag to the specified GPR.  The result is stored in the output register. | `10010xxx` |
| `ADD rX` | Adds the accumulator to the specified GPR.  The result is stored in the output register. | `10011xxx` |
| `SUB rX` | Subtracts the accumulator from the specified GPR.  The result is stored in the output register.  | `10100xxx` |
| `NEG rX` | Negates the specified GPR.  The result is stored in the output register. | `10101xxx` |
| `INC rX` | Increments the specified GPR.  The result is stored in the output register. | `10110xxx` |
| `DEC rX` | Decrements the specified GPR.  The result is stored in the output register. | `10111xxx` |
| `TEST rX` | Sets the zero flag if the specified GPR is zero.  Does not set the carry flag. | `11000xxx` |
| `AND rX` | Logical AND operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11001xxx` |
| `OR rX` | Logical OR operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11010xxx` |
| `NOT rX` | Logical NOT operation of the specified GPR.  The result is stored in the output register. | `11011xxx` |
| `XOR rX` | Logical XOR operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11100xxx` |
| `SHR rX` | Logical shift right of the specified GPR by the amount specified by the accumulator.  The result is stored in the output register. | `11101xxx` |
| `SHL rX` | Logical shift left of the specified GPR by the amount specified by the accumulator.  The result is stored in the output register. | `11110xxx` |
| `CMP rX` | Subtracts the accumulator and the carry flag from the specified GPR, setting the zero and carry flags and discarding the results.  | `11111xxx` |
