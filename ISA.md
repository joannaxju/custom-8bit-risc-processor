# Instruction Set Architecture

## Instruction formats

| **TYPE** | **FORMAT** | **CORRESPONDING INSTRUCTIONS** | 
| -------- | -------- | ----------------- |
| A |  | 'and', 'xor', 'add', 'adc' |
| B |  | 'mov', 'lb', 'sb', 'cmp' |
| C |  | 'addi' |
| D |  | 'shl', 'rlc', 'shr', 'rrc' |
| E |  | 'ju', 'bge' |

---

## Operations

| **NAME** | **TYPE** | **BIT BREAKDOWN** | **EXAMPLE** | **NOTES** |
| -------- | -------- | ----------------- | ----------- | --------- |
| `and` = bitwise and | A | 3 bit opcode (`000`)<br>2 bit register operand (`XX`)<br>2 bit register operand (`XX`)<br>2 bit funct (`00`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br># R3 = R1 AND R2<br>`and R1, R2` ⇔ `000_00_01_00`<br><br># after and instruction, R3 now holds `0b0001_0000` | |
| `xor` = bitwise xor | A | 3 bit opcode (`000`)<br>2 bit register operand (`00`)<br>2 bit register operand (`01`)<br>2 bit funct (`01`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br># R3 = R1 xor R2<br>`xor R1, R2` ⇔ `000_00_01_01`<br><br># after xor instruction, R3 now holds `0b1000_0001` | |
| `add` = addition | A | 3 bit opcode (`000`)<br>2 bit register operand (`XX`)<br>2 bit register operand (`XX`)<br>2 bit funct (`10`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br># R3 = R1 + R2<br>`add R1, R2` ⇔ `000_00_01_10`<br><br># after add instruction, R3 now holds `0b1010_0001` and carry flag is set to 0 | |
| `adc` = add with carry | A | 3 bit opcode (`000`)<br>2 bit register operand (`XX`)<br>2 bit register operand (`XX`)<br>2 bit funct (`11`) | # Assume R1 has `0b1111_1111`<br># Assume R2 has `0b0000_0001`<br># Assume carry is 1<br><br># R3 = R1 + R2 + carry<br>`adc R1, R2` ⇔ `000_00_01_11`<br><br># after adc instruction, R3 now holds `0b0000_0001` and carry flag is set to 1 | |
| `mov` = move | B | 3 bit opcode (`001`)<br>3 bit source register (`XXX`)<br>3 bit destination register (`XXX`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br>`mov R1, R2` ⇔ `001_000_001`<br><br># after mov instruction, R2 now holds `0001_0001` | |
| `lb` = load byte | B | 3 bit opcode (`010`)<br>3 bit source register (`XXX`)<br>3 bit destination register (`XXX`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br>`lb R1, R2` ⇔ `010_000_001`<br><br># after lb instruction, R2 now holds mem[R1] | |
| `sb` = store byte | B | 3 bit opcode (`011`)<br>3 bit source register (`XXX`)<br>3 bit destination register (`XXX`) | # Assume R1 has `0b0001_0001`<br># Assume R4 has `0b1001_0000`<br><br>`sb R1, R2` ⇔ `011_000_001`<br><br># after sb instruction, mem[R2] now holds R1 | |
| `cmp` = compare | B | 3 bit opcode (`100`)<br>3 bit register operand (`XXX`)<br>3 bit register operand (`XXX`) | # Assume R1 has `0b0001_0001`<br># Assume R2 has `0b1001_0000`<br><br>`cmp R1, R2` ⇔ `100_000_001`<br><br># after cmp instruction, equal flag is set to 0 and less than flag is set to 0 | |
| `addi` = add immediate | C | 3 bit opcode (`101`)<br>2 bit register operand (`XX`)<br>4 bit immediate (`XXXX`) | # Assume R1 has `0b0001_0001`<br><br>`addi R1, 3` ⇔ `101_00_0011`<br><br># after addi instruction, R1 now holds `0001_0100` | |
| `shl` = shift left | D | 3 bit opcode (`110`)<br>2 bit funct (`00`)<br>1 bit not used (`0`)<br>3 bit register (`XXX`) | # Assume R1 has `0b1011_0011`<br><br># R1 = R1 << 1<br>`shl R1` ⇔ `110_00_0_000`<br><br># after shl instruction, R1 now holds `0b0110_0110` and carry flag is set to 1 | |
| `rlc` = rotate left through carry | D | 3 bit opcode (`110`)<br>2 bit funct (`01`)<br>1 bit not used (`0`)<br>3 bit register (`XXX`) | # Assume R1 has `0b1011_0011`<br># Assume carry flag is 1<br><br># R1 = R1 << 1<br>`rlc R1` ⇔ `110_01_0_000`<br><br># after rlc instruction, R1 now holds `0b0110_0111` and carry flag is set to 1 | |
| `shr` = shift right | D | 3 bit opcode (`110`)<br>2 bit funct (`10`)<br>1 bit not used (`0`)<br>3 bit register (`XXX`) | # Assume R1 has `0b1011_0011`<br><br># R1 = R1 >> 1<br>`shr R1` ⇔ `110_10_0_000`<br><br># after shr instruction, R1 now holds `0b0101_1001` and carry flag is set to 1 | |
| `rrc` = rotate right through carry | D | 3 bit opcode (`110`)<br>2 bit funct (`11`)<br>1 bit not used (`0`)<br>3 bit register (`XXX`) | # Assume R1 has `0b1011_0011`<br># Assume carry flag is 0<br><br># R1 = R1 >> 1<br>`rrc R1` ⇔ `110_11_0_000`<br><br># after rrc instruction, R1 now holds `0b0101_1001` and carry flag is set to 1 | |
| `ju` = jump up | E | 3 bit opcode (`111`)<br>1 bit type (`0`)<br>5 bit offset (`XXXXX`) | `ju 7` ⇔ `111_0_00111`<br><br># after ju instruction, program counter now holds pc - 7 | |
| `bge` = branch if greater than or equal | E | 3 bit opcode (`111`)<br>1 bit type (`1`)<br>5 bit offset (`XXXXX`) | `bge 7` ⇔ `111_1_00111`<br><br># after bge instruction and less than flag is 0, program counter now holds pc + 7 | |
| `done` = signal done flag | E | 3 bit opcode (`111`)<br>1 bit type (`0`)<br>5 bit offset (`00000`) | `done` ⇔ `111_0_00000`<br><br># after done instruction, done flag is set to 1 | |

---

# Internal Operands

The processor supports eight general-purpose 8-bit registers named R1–R8 for most instructions. However, some instruction formats use reduced register encodings to simplify hardware and conserve instruction bits.

In A-type instructions, only four registers are accessible: R1, R2, RL, and RM. RL and RM are special constant registers that are read-only and permanently store the values `0b0000_0001` and `0b1000_0000`, respectively.

**R3 acts as the processor's accumulator.** A-type instructions such as `and`, `xor`, `add`, and `adc` write their result directly to R3.

These constant registers simplify common arithmetic and bit manipulation operations without requiring immediate fields.

---

# Control Flow (Branches)

The processor supports unconditional jumps and conditional branches using PC-relative addressing.

Conditional branches rely on the equal, less than, and carry flags, which are updated by comparison, arithmetic, and shift instructions.

Branch target addresses are calculated relative to the current program counter by adding or subtracting the branch offset.

The branch offset allows the processor to perform short-range relative jumps. Larger jumps can be accommodated by chaining multiple jump instructions together or restructuring code into smaller branch regions.

This relative branching approach simplifies the hardware because the processor does not require full absolute jump addresses.

---

# Addressing Modes

The processor primarily supports register and indirect memory addressing modes.

### Register Addressing

Arithmetic and logical instructions operate directly on register operands.

```asm
add R1, R2
```

### Register-Indirect Addressing

The `lb` and `sb` instructions use register indirect addressing, where the contents of a register are interpreted as a memory address.

```asm
lb R1, R2
```

loads the byte stored at memory address R1 into R2.

```asm
sb R1, R2
```

stores the value in R1 into memory location R2.

### Immediate Addressing

Immediate addressing is supported through the `addi` instruction, which adds a 4-bit unsigned immediate value directly to a register.

```asm
addi R1, 3
```

### PC-Relative Addressing

Branch instructions use PC-relative addressing, where the branch offset is added to or subtracted from the current program counter to determine the next instruction address.
