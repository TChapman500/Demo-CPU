```
Chapman CPU	BasicP 1x8Cxxxx
		[NumCores]x[BusWidth]C[MHz]

 A OP  S SEL
+-+---+-+---+
|0|xxx|y|zzz|	Normal Operation
+-+---+-+---+
| |000|0|000|	No Operation
+-+---+-+---+
| |000|y|zzz|	General Instruction
+-+---+-+---+
| |   |0|zzz|	Set A
+-+---+-+---+
| |   | |001|	Load Number to ACC
| |   | |010|	Load Number from Address to ACC
| |   | |011|	Output ALU to Address
| |   | |100|	Move ALU to ACC
| |   | |101|	Call
| |   | |110|	Return
| |   | |111|	Unconditional Jump
+-+---+-+---+
| |   |1|zzz|	Set B
+-+---+-+---+
| |   | |001|	Interrupt Return
| |   | |010|	Set Interrupt Addresses
+-+---+-+---+
| |001|y|zzz|	Load To GPR
+-+---+-+---+
| |   |0|   |	Number
| |   |1|   |	From Address
+-+---+-+---+
| |010|y|zzz|	Move
+-+---+-+---+
| |   |0|   |	ALU to GPR
| |   |1|   |	GPR to ACC
+-+---+-+---+
| |011|0|zzz|	Conditional Jump
+-+---+-+---+
| |   | |000|	JNE
| |   | |001|	JL
| |   | |010|	JG
| |   | |011|	JE
| |   | |100|	JC
| |   | |101|	JB
| |   | |110|	JF
| |   | |111|	JT
+-+---+-+---+
| |011|1|zzz|	Output GPR to Address
+-+---+-+---+
| |100|y|zzz|	GPIO Set as Input
+-+---+-+---+
| |   |0|   |	Standard Input
| |   |1|   |	Interrupt Input
+-+---+-+---+
| |101|y|zzz|	GPIO Set as Output
+-+---+-+---+
| |   |0|   |	Standard Output
| |   |1|   |	Clock Output
+-+---+-+---+
| |110|y|zzz|	GPIO Jump
+-+---+-+---+
| |   |0|   |	Jump if False
| |   |1|   |	Jump if True
+-+---+-+---+
| |111|y|zzz|	GPIO Set Value
+-+---+-+---+
| |   |0|   |	Set to False
| |   |1|   |	Set to True
+-+---+-+---+

 A  OP  GPR
+-+----+---+
|1|xxxx|yyy|	ALU Operation
+-+----+---+
| |0000|   |	Illegal Operation/Divide (on some CPUs)
| |0001|   |	Add
| |0010|   |	Subtract
| |0011|   |	Negate
| |0100|   |	Increment
| |0101|   |	Decrement
| |0110|   |	Multiply
| |0111|   |	And
| |1000|   |	Nand
| |1001|   |	Or
| |1010|   |	Nor
| |1011|   |	Not
| |1100|   |	Xor
| |1101|   |	Shift Right
| |1110|   |	Shift Left
| |1111|   |	Compare
+-+----+---+
```
