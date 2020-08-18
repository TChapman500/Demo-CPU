# Demo CPU
Processor is Little-Endian and the results of all ALU operations are stored in the output register.  All ALU operations are done with the selected GPR as the A input and the accumulator as the B input.

| Instruction | Description | Opcode (binary) |
| ----------- | ----------- | --------------- |
| `NOP` | Does nothing. | `00000000` |
| `LD acc, imm8` | Copies the immediate byte to the accumulator. | `00000001` |
| `ST imm16, out` | Copies the contents of the output register to the specified RAM address. | `00000010` |
| `LDR acc, imm16` | Copies the contents of RAM at specified address to the accumulator. | `00000011` |
| `MOV acc, out` | Copies the contents of the output register to the accumulator. | `00000100` |
| `MOV acc, outH` | Copies the contents of the upper half of the output register to the accumulator. | `0000101` |
| `ST imm16, outH` | Copies the contents of the upper half of the output register to the specified RAM address. | `0000110` |
| `JMP imm16` | Unconditional jump to specified address. | `00000111` |
| `LD rX, imm8` | Copies the immediate byte to the specified general purpose register (GPR). | `00001xxx` |
| `LDR rX, imm16` | Copies the contents of the specified RAM address to the specified GPR. | `00010xxx` |
| `MOV rX, out` | Copies the contents of the output register to the specified GPR. | `00011xxx` |
| `MOV acc, rX` | Copies the contents of the specified GPR to the accumulator. | `00100xxx` |
| `ST imm16, rX` | Copies the contents of the specified GPR to the specified RAM address. | `00101xxx` |
| `JNE/JNZ imm16` | Jumps to the specified RAM address if the zero flag is cleared/if `A != B`. | `00110000` |
| `JL/JC imm16` | Jumps to the specified RAM address if the carry flag is set/if `A < B`. | `00110001` |
| `JNL/JNC imm16` | Jumps to the specified RAM address if the carry flag is cleared/if `A >= B`. | `00110010` |
| `JE/JZ imm16` | Jumps to the specified RAM address if the zero flag is set/if `A == B`. | `00110011` |
| `JG imm16` | Jumps to the specified RAM address if `A > B`. | `00110100` |
| `JNG imm16` | Jumps to the specified RAM address if `A <= B`.  | `00110101` |
| `JO imm16` | Jumps to the specified RAM address if `A == 0`. | `00110110` |
| `JNO imm16` | Jumps to the specified RAM address if `A == 1`. | `00110111` |
| `MOV rX, outH` | Copies the contents of the upper half of the output register to the specified GPR. | `00111xxx` |
| `ADC rX` | Adds the accumulator and the carry flag to the specified GPR. | `10000xxx` |
| `ADD rX` | Adds the accumulator to the specified GPR. | `10001xxx` |
| `SUB rX` | Subtracts the accumulator from the specified GPR.  | `10010xxx` |
| `NEG rX` | Negates the specified GPR. | `10011xxx` |
| `INC rX` | Increments the specified GPR. | `10100xxx` |
| `DEC rX` | Decrements the specified GPR. | `10101xxx` |
| `MUL rX` | Multiplies the accumulator and the specified GPR together.  Sets the overflow flag if the upper half is greater than 0.  Does not set the carry flag. | `10110xxx` |
| `AND rX` | Logical AND operation with the accumulator and the specified GPR. | `10111xxx` |
| `NAND rX` | Logical NAND operation with the accumulator and the specified GPR. | `11000xxx` |
| `OR rX` | Logical OR operation with the accumulator and the specified GPR. | `11001xxx` |
| `NOR rX` | Logical NOR operation with the accumulator and the specified GPR. | `11010xxx` |
| `NOT rX` | Logical NOT operation of the specified GPR. | `11011xxx` |
| `XOR rX` | Logical XOR operation with the accumulator and the specified GPR. | `11100xxx` |
| `SHR rX` | Logical shift right of the specified GPR by the amount specified by the accumulator. | `11101xxx` |
| `SHL rX` | Logical shift left of the specified GPR by the amount specified by the accumulator. | `11110xxx` |
| `SUB rX` | Subtracts the accumulator and the carry flag from the specified GPR.  | `11111xxx` |
