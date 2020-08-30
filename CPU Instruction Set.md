# Demo CPU Enhanced Instruction Set
Processor is Little-Endian and the results of all ALU operations are stored in the output register.  All ALU operations are done with the selected GPR as the A input and the accumulator as the B input.

| Instruction | Description | Opcode (binary) |
| ----------- | ----------- | --------------- |
| `NOP` | Does nothing. | `00000000` |
| `LD acc, imm8` | Copies the immediate byte to the accumulator. | `00000001` |
| `ST imm16, out` | Copies the contents of the output register to the specified RAM address. | `00000010` |
| `LDR acc, imm16` | Copies the contents of RAM at specified address to the accumulator. | `00000011` |
| `MOV acc, out` | Copies the contents of the output register to the accumulator. | `00000100` |
| `CALL imm16` | Calls a function located at the specified immediate address. | `00000101` |
| `RET` | Returns from a function. | `00000110` |
| `JMP imm16` | Unconditional jump to specified immediate address. | `00000111` |
| `LD rX, imm8` | Copies the immediate byte to the specified general purpose register (GPR). | `00001xxx` |
| `LDR rX, imm16` | Copies the contents of the specified RAM address to the specified GPR. | `00010xxx` |
| `MOV rX, out` | Copies the contents of the output register to the specified GPR. | `00011xxx` |
| `MOV acc, rX` | Copies the contents of the specified GPR to the accumulator. | `00100xxx` |
| `ST imm16, rX` | Copies the contents of the specified GPR to the specified RAM address. | `00101xxx` |
| `JNE/JNZ imm16` | Jumps to the specified RAM address if the zero flag is cleared/if `A != B`. | `00110000` |
| `JE/JZ imm16` | Jumps to the specified RAM address if the carry flag is set/if `A == B`. | `00110001` |
| `JL/JC imm16` | Jumps to the specified RAM address if the carry flag is cleared/if `A < B`. | `00110010` |
| `JNL/JNC imm16` | Jumps to the specified RAM address if the zero flag is set/if `A >= B`. | `00110011` |
| `JG imm16` | Jumps to the specified RAM address if `A > B`. | `00110100` |
| `JNG imm16` | Jumps to the specified RAM address if `A <= B`.  | `00110101` |
| `LD rX, [adr]` | Loads the value stored at the address pointed to by the address register into the specified GPR. | `00111xxx` |
| `ST [adr], rX` | Stores the value in the specified GPR at the address pointed to by the address register. | `01000xxx` |
| `PUSH rX` | Decrements r7 and then stores the specified register at the address specified by `0x08[r7]`. | `01001xxx` |
| `POP rX` | Loads the value stored at address `0x08[r7]` into the specified GPR and increments r7. | `01010xxx` |
| `MOV adrl, rX` | Copies the value in the specified GPR into the lower byte of the address register. | `01011xxx` |
| `MOV adrh, rX` | Copies the value in the specified GPR into the upper byte of the address register. | `01100xxx` |
| `LD adrl, imm8` | Loads the immediate byte into the lower byte of the address register. | `01101000` |
| `LD adrh, imm8` | Loads the immediate byte into the upper byte of the address register. | `01101001` |
| `MOV adrl, out` | Copies the value in the output register to the lower byte of the address register. | `01101010` |
| `MOV adrh, out` | Copies the value in the output register to the upper byte of the address register. | `01101011` |
| `ISR imm16` | (NOT IMPLEMENTED) Sets the interrupt service routine to the specified address. | `01101100` |
| `INT imm8` | (NOT IMPLEMENTED) If `imm8 = 0`, disables interrupts.  If `imm8 = 1`, enables interrupts. | `01101101` |
| `LD adr, imm16` | Loads the immediate word (2 bytes) into the address register. | `01101110` |
| `LD acc, [adr]` | Copies the value at the address specified by the address register into the accumulator. | `01101111` |
| `ADC rX` | Adds the accumulator and the carry flag to the specified GPR.  The result is stored in the output register. | `10000xxx` |
| `ADD rX` | Adds the accumulator to the specified GPR.  The result is stored in the output register. | `10001xxx` |
| `SUB rX` | Subtracts the accumulator from the specified GPR.  The result is stored in the output register.  | `10010xxx` |
| `NEG rX` | Negates the specified GPR.  The result is stored in the output register. | `10011xxx` |
| `INC rX` | Increments the specified GPR.  The result is stored in the output register. | `10100xxx` |
| `DEC rX` | Decrements the specified GPR.  The result is stored in the output register. | `10101xxx` |
| `TEST rX` | Sets the zero flag if the specified GPR is zero.  Does not set the carry flag. | `10110xxx` |
| `AND rX` | Logical AND operation with the accumulator and the specified GPR.  The result is stored in the output register. | `10111xxx` |
| `NAND rX` | Logical NAND operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11000xxx` |
| `OR rX` | Logical OR operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11001xxx` |
| `NOR rX` | Logical NOR operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11010xxx` |
| `NOT rX` | Logical NOT operation of the specified GPR.  The result is stored in the output register. | `11011xxx` |
| `XOR rX` | Logical XOR operation with the accumulator and the specified GPR.  The result is stored in the output register. | `11100xxx` |
| `SHR rX` | Logical shift right of the specified GPR by the amount specified by the accumulator.  The result is stored in the output register. | `11101xxx` |
| `SHL rX` | Logical shift left of the specified GPR by the amount specified by the accumulator.  The result is stored in the output register. | `11110xxx` |
| `CMP rX` | Subtracts the accumulator and the carry flag from the specified GPR, setting the zero and carry flags and discarding the results.  | `11111xxx` |
