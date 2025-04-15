# Demo CPU
This is an enhanced version of my original CPU.  This enhancement adds stack management, function call and return instructions, and more data transfer instructions.  It also lays the framework for implementing system interrupts. For this CPU to work, you will need the latest version of [Logisim Evolution (Holy Cross Edition)](https://github.com/kevinawalsh/logisim-evolution) (4.0.4+).  The DemoCPU.cpu file is for use with [customasm](https://github.com/hlorenzi/customasm).

BIN files are raw binary files that can be loaded directly into RAM through the "Load Memory Image..." option.  HEX files hold the exact same data in text format so that it's easier to see what's in it.  ASM files hold a human-readable assembly code of said program.

If you would like to support my work, you can do so through [Patreon](https://www.patreon.com/TChapman500), [SubscribeStar](https://www.subscribestar.com/tchapman500), or [PayPal](https://www.paypal.com/paypalme/tchapman500).

# Architecture
This is an 8-bit processor with an 8-bit data bus and a 16-bit address bus.  There are 5, 8-bit general purpose registers, 3, 8-bit specialty registers, and 5, 16-bit address registers.  Some of these registers overlap with other registers.  The processor is also little-endian.

## Address Registers
There are 5, 16-bit address registers.

### Address Register (adr)
This register points to a memory location for reading or writing.  Some instructions will copy the pointer in this register to the temporary register in order to preserve the value of this register during the execution of said instruction.  This register is accessed in an `LD`, `ST`, or `MOV` instruction by using `adr` to address the entire register, or `adrl` and `adrh` to access only the lower and upper half of the register respectively.

### Temporary Register
This register points to a memory location for reading, writing, or executing code.  This register is loaded whenever preservation of the address register is required, when the instruction in question does not need to use the address register, or when loading the address of the next instruction to execute.  The contents of this register are considered invalid after the instruction that is using it finishes executing.  This register cannot be accessed by software.

### Program Counter
This register points to the location of the next instruction to be executed.  It is loaded through the data bus through a `RET` or `RTI` instruction, or from the Interrupt Service System or Temporary Register, or it is incremented.  This register cannot be accessed directly though software, but only indirectly through the `Jxx`, `CALL`, `RET`, or `RTI` instructions, which set the program counter's value, then resumes execution at the new address.

### Interrupt Service System (ISS)
This register points to the first instruction of the Interrupt Service Reoutine (ISR).  This register can only be written to through an `ISR` instruction.  There is no way to read the value of the ISS.  The ISS also contains a 17th bit to determine if interrupts are enabled.  The `INT` instruction will either set or clear this bit depending on the 1-bit embeded operand.

### Stack Pointer
This register points to the top of the stack.  Calling functions, using the `PUSH` and `POP` instructions, and using interrupts will all modify the stack pointer.  The lower half of the stack pointer can be accessed directly as `r7` for both reading, writing, and arithmetic.  The upper half of the stack pointer is hardwired to a value of `0x08`.

## General Purpose Registers (rX)
There are 5, 8-bit registers that do not have a special function attached to them.  And 8, 8-bit registers that can be accessed with the `rX` operand, where `X` is a number from 0-7.  Values of `X` from 0-4 address the 5 registers that do not have a special function attached to them.

### Accumulator (acc)
The accumulator can be accessed through the operand `r5` and/or `acc` depending on the instruction.  This register is always the second operand of an ALU operation, though it can also be used as the first operand.  All registers that can be accessed through the `rX` operand of an instruction can be copied into this register.

### Output Register (out)
The output register can be accessed through the operand `r6` and/or `out` depending on the instruction.  ALU output is stored in this register.  Data from this register can be copied to all registers that can be accessed through the `rX` operand of an instruction.

## Flags Register (flags)
The flags register is written to whenever an ALU operation is performed.  The output goes to the control unit which then evaluates the flags based on the jump condition specified by a `Jxx` instruction.  This register can only be accessed through the use of `PUSH` or `POP` instructions by specifying `flags` in the operand.

## Interrupts
Interrupts are disabled by default, by `INT 0` instructions, and by entry into the interrupt service reoutine (ISR).  Interrupts are enabled by `INT 1` or `RTI` instructions.  When interrupts are enabled, the interrupt signal must be held high until an instruction finishes executing.  After that, the processor will enter the ISR.

Upon entry into the ISR, the program counter is pushed onto the stack followed by the value of the flags register.  When an `RTI` instruction is executed, the flags register is popped from the stack followed by the program counter.  The user must push any additional registers that he/she intends to use onto the stack at the begining of the ISR, and then pop those registers from the stack in the reverse order before the `RTI` instruction.  The ISR must end with the `RTI` instruction.  Enabling interrupts from inside the ISR is not recommended.

## Peripherals
The Demo CPU has no peripherals or instructions to access peripherals.  Peripherals must be mapped to specific addresses in such a way as to not conflict with each other or the stack pointer (mapped to `0x0800-0x08FF`).  These peripherals would then be accessed in software through `LD` and `ST` instructions to read from and write to the peripherals respectively.  At the bare minimum, RAM must be mapped to addreses `0x0800-0x08FF` to accommodate the stack, and a ROM must be mapped at least to address `0x0000` to accomodate the start of execution of the program.  If the program is a BIOS, then the entirety of the BIOS should fit within the first 2k of addressable memory, including the variables used by the BIOS.

# Instruction Set
This processor is Little-Endian and the results of all ALU operations are stored in the output register.  All ALU operations are done with 'rX' as the A input and the accumulator as the B input.  This instruction set is incompatible with the restored version of the CPU, though some instructions will still work with it.

`imm8` is a one-byte number that immediately follows the opcode.  `imm16` is a two-byte number that immediately follows the opcode (little endian order).  `rX` is a general purpose register where `X` is a 3-bit number from 0-7.  These 3 bits make up the 3 least-significant bits of the opcode.  `flags` refers to the flags register, `adr` refers to the address register, and `adrl` and `adrh` refer to the lower half and upper half of the address register respectively.

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

## Instruction Matrix

|          | xxxxx000         | xxxxx001         | xxxxx010         | xxxxx011         | xxxxx100          | xxxxx101         | xxxxx110         | xxxxx111          |
| -------- | ---------------- | ---------------- | ---------------- | ---------------- | ----------------- | ---------------- | ---------------- | ----------------- |
| 00000xxx | `NOP`            | `ISR imm16`      | `INT 0`          | `INT 1`          | `RTI`             | `CALL imm16`     | `RET`            | `PUSH flags`      |
| 00001xxx | `POP flags`      | `LD adrl, imm8`  | `LD adrh, imm8`  | `LD adr, imm16`  | `LD adr, [imm16]` | `LD adr, [adr]`  | `POP adr`        | `ST [imm16], adr` |
| 00010xxx | `ST [adr], adr`  | `PUSH adr`       | `HLT`            |                  |                   |                  |                  |                   |
| 00011xxx | `JMP imm16`      | `JNE/JNZ imm16`  | `JE/JZ imm16`    | `JL/JC imm16`    | `JNL/JNC imm16`   | `JG imm16`       | `JNG imm16`      |                   |
| 00100xxx | `LD r0, imm8`    | `LD r1, imm8`    | `LD r2, imm8`    | `LD r3, imm8`    | `LD r4, imm8`     | `LD r5, imm8`    | `LD r6, imm8`    | `LD r7, imm8`     |
| 00101xxx | `LD r0, [imm16]` | `LD r1, [imm16]` | `LD r2, [imm16]` | `LD r3, [imm16]` | `LD r4, [imm16]`  | `LD r5, [imm16]` | `LD r6, [imm16]` | `LD r7, [imm16]`  |
| 00110xxx | `LD r0, [adr]`   | `LD r1, [adr]`   | `LD r2, [adr]`   | `LD r3, [adr]`   | `LD r4, [adr]`    | `LD r5, [adr]`   | `LD r6, [adr]`   | `LD r7, [adr]`    |
| 00111xxx | `POP r0`         | `POP r1`         | `POP r2`         | `POP r3`         | `POP r4`          | `POP r5`         | `POP r6`         | `POP r7`          |
| 01000xxx | `ST [imm16], r0` | `ST [imm16], r1` | `ST [imm16], r2` | `ST [imm16], r3` | `ST [imm16], r4`  | `ST [imm16], r5` | `ST [imm16], r6` | `ST [imm16], r7`  |
| 01001xxx | `ST [adr], r0`   | `ST [adr], r1`   | `ST [adr], r2`   | `ST [adr], r3`   | `ST [adr], r4`    | `ST [adr], r5`   | `ST [adr], r6`   | `ST [adr], r7`    |
| 01010xxx | `PUSH r0`        | `PUSH r1`        | `PUSH r2`        | `PUSH r3`        | `PUSH r4`         | `PUSH r5`        | `PUSH r6`        | `PUSH r7`         |
| 01011xxx | `MOV acc, r0`    | `MOV acc, r1`    | `MOV acc, r2`    | `MOV acc, r3`    | `MOV acc, r4`     | `MOV acc, r5`    | `MOV acc, r6`    | `MOV acc, r7`     |
| 01100xxx | `MOV r0, out`    | `MOV r1, out`    | `MOV r2, out`    | `MOV r3, out`    | `MOV r4, out`     | `MOV r5, out`    | `MOV r6, out`    | `MOV r7, out`     |
| 01101xxx | `MOV r0, adrl`   | `MOV r1, adrl`   | `MOV r2, adrl`   | `MOV r3, adrl`   | `MOV r4, adrl`    | `MOV r5, adrl`   | `MOV r6, adrl`   | `MOV r7, adrl`    |
| 01110xxx | `MOV r0, adrh`   | `MOV r1, adrh`   | `MOV r2, adrh`   | `MOV r3, adrh`   | `MOV r4, adrh`    | `MOV r5, adrh`   | `MOV r6, adrh`   | `MOV r7, adrh`    |
| 01111xxx | `MOV adrl, r0`   | `MOV adrl, r1`   | `MOV adrl, r2`   | `MOV adrl, r3`   | `MOV adrl, r4`    | `MOV adrl, r5`   | `MOV adrl, r6`   | `MOV adrl, r7`    |
| 10000xxx | `MOV adrh, r0`   | `MOV adrh, r1`   | `MOV adrh, r2`   | `MOV adrh, r3`   | `MOV adrh, r4`    | `MOV adrh, r5`   | `MOV adrh, r6`   | `MOV adrh, r7`    |
| 10001xxx |                  |                  |                  |                  |                   |                  |                  |                   |
| 10010xxx | `ADC r0`         | `ADC r1`         | `ADC r2`         | `ADC r3`         | `ADC r4`          | `ADC r5`         | `ADC r6`         | `ADC r7`          |
| 10011xxx | `ADD r0`         | `ADD r1`         | `ADD r2`         | `ADD r3`         | `ADD r4`          | `ADD r5`         | `ADD r6`         | `ADD r7`          |
| 10100xxx | `SUB r0`         | `SUB r1`         | `SUB r2`         | `SUB r3`         | `SUB r4`          | `SUB r5`         | `SUB r6`         | `SUB r7`          |
| 10101xxx | `NEG r0`         | `NEG r1`         | `NEG r2`         | `NEG r3`         | `NEG r4`          | `NEG r5`         | `NEG r6`         | `NEG r7`          |
| 10110xxx | `INC r0`         | `INC r1`         | `INC r2`         | `INC r3`         | `INC r4`          | `INC r5`         | `INC r6`         | `INC r7`          |
| 10111xxx | `DEC r0`         | `DEC r1`         | `DEC r2`         | `DEC r3`         | `DEC r4`          | `DEC r5`         | `DEC r6`         | `DEC r7`          |
| 11000xxx | `TEST r0`        | `TEST r1`        | `TEST r2`        | `TEST r3`        | `TEST r4`         | `TEST r5`        | `TEST r6`        | `TEST r7`         |
| 11001xxx | `AND r0`         | `AND r1`         | `AND r2`         | `AND r3`         | `AND r4`          | `AND r5`         | `AND r6`         | `AND r7`          |
| 11010xxx | `OR r0`          | `OR r1`          | `OR r2`          | `OR r3`          | `OR r4`           | `OR r5`          | `OR r6`          | `OR r7`           |
| 11011xxx | `NOT r0`         | `NOT r1`         | `NOT r2`         | `NOT r3`         | `NOT r4`          | `NOT r5`         | `NOT r6`         | `NOT r7`          |
| 11100xxx | `XOR r0`         | `XOR r1`         | `XOR r2`         | `XOR r3`         | `XOR r4`          | `XOR r5`         | `XOR r6`         | `XOR r7`          |
| 11101xxx | `SHR r0`         | `SHR r1`         | `SHR r2`         | `SHR r3`         | `SHR r4`          | `SHR r5`         | `SHR r6`         | `SHR r7`          |
| 11110xxx | `SHL r0`         | `SHL r1`         | `SHL r2`         | `SHL r3`         | `SHL r4`          | `SHL r5`         | `SHL r6`         | `SHL r7`          |
| 11111xxx | `CMP r0`         | `CMP r1`         | `CMP r2`         | `CMP r3`         | `CMP r4`          | `CMP r5`         | `CMP r6`         | `CMP r7`          |
