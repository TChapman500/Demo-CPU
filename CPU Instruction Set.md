# Demo CPU
Processor is Little-Endian and the results of all ALU operations are stored in the output register.  All ALU operations are done with the selected GPR as the A input and the accumulator as the B input.

| Instruction | Description | Opcode |
| ----------- | ----------- | ------ |
| `NOP` | Does nothing. | `00000000` |
| `LD acc, imm8` | Copies the immediate byte to the accumulator. | `00000001` |
| `ST imm16, out` | Copies the contents of the output register to the specified RAM address. | `00000010` |
| `LDR acc, imm16` | Copies the contents of RAM at specified address to the accumulator. | `00000011` |
| `MOV acc, out` | Copies the contents of the output register to the accumulator. | `00000100` |
| `JMP imm16` | Unconditional jump to specified address. | `00000111` |
| `LD rX, imm8` | Copies the immediate byte to the specified general purpose register (GPR). | `00001xxx` |
| `LDR rX, imm16` | Copies the contents of the specified RAM address to the specified GPR. | `00010xxx` |
| `MOV rX, out` | Copies the contents of the output register to the specified GPR. | `00011xxx` |
| `MOV acc, rX` | Copies the contents of the specified GPR to the accumulator. | `00100xxx` |
| `ST imm16, rX` | Copies the contents of the specified GPR to the specified RAM address. | `00101xxx` |
| `JNE imm16` | Jumps to the specified RAM address if `A != B`. | `00110000` |
| `JL imm16` | Jumps to the specified RAM address if `A < B`. | `00110001` |
| `JG imm16` | Jumps to the specified RAM address if `A > B`. | `00110010` |
| `JE imm16` | Jumps to the specified RAM address if `A == B`. | `00110011` |
| `JC imm16` | Jumps to the specified RAM address if `ADD` or `MUL` overflows. | `00110100` |
| `JB imm16` | Jumps to the specified RAM address if `SUB` was performed with `A < B`.  | `00110101` |
| `JF imm16` | Jumps to the specified RAM address if `A == 0`. | `00110110` |
| `JT imm16` | Jumps to the specified RAM address if `A == 1`. | `00110111` |
| `ADD rX` | Adds the accumulator to the specified GPR. | `10001xxx` |
| `SUB rX` | Subtracts the accumulator from the specified GPR.  | `10010xxx` |
| `NEG rX` | Negates the specified GPR. | `10011xxx` |
| `INC rX` | Increments the specified GPR. | `10100xxx` |
| `DEC rX` | Decrements the specified GPR. | `10101xxx` |
| `MUL rX` | Multiplies the accumulator and the specified GPR together.  Only the lower half of the result is stored in the output register.  The upper half of the result is discarded. | `10110xxx` |
| `AND rX` | Logical AND operation with the accumulator and the specified GPR. | `10111xxx` |
| `NAND rX` | Logical NAND operation with the accumulator and the specified GPR. | `11000xxx` |
| `OR rX` | Logical OR operation with the accumulator and the specified GPR. | `11001xxx` |
| `NOR rX` | Logical NOR operation with the accumulator and the specified GPR. | `11010xxx` |
| `NOT rX` | Logical NOT operation of the specified GPR. | `11011xxx` |
| `XOR rX` | Logical XOR operation with the accumulator and the specified GPR. | `11100xxx` |
| `SHR rX` | Logical shift right of the specified GPR by the amount specified by the accumulator. | `11101xxx` |
| `SHL rX` | Logical shift left of the specified GPR by the amount specified by the accumulator. | `11110xxx` |
| `CMP rX` | Unsigned compare of the specified GPR and the accumulator. | `11111xxx` |
