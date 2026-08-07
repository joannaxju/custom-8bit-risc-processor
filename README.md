# Custom 8-Bit RISC Processor

A custom 8-bit RISC processor designed from the instruction set architecture (ISA) through SystemVerilog RTL implementation, assembly programming, verification, and machine-code generation.

The processor uses a **9-bit fixed-length instruction format** and an **8-bit datapath**, requiring careful instruction encoding and hardware/software co-design within a constrained architecture.

## Overview

This project involved designing and implementing a complete processor architecture, including:

* Custom 9-bit instruction set architecture
* 8-bit datapath
* Multiple instruction formats
* 8 general-purpose registers
* Dedicated constant registers
* Arithmetic Logic Unit (ALU)
* Carry, equal, and less-than flags
* Register file
* Control logic
* Program counter and instruction-fetch unit
* Instruction and data memory
* Register-indirect memory addressing
* PC-relative branching
* Custom assembly language
* Custom assembler for 9-bit machine-code generation
* SystemVerilog RTL implementation
* Questa/ModelSim simulation
* Intel Quartus FPGA development

The ISA was designed around the target computational workloads, balancing instruction encoding constraints with hardware complexity and program requirements.

---

## Target Programs

The processor was designed to execute three computational workloads. Each program is written in the custom assembly language and converted into 9-bit machine code using the [custom assembler](/assembler). The resulting machine code is stored in instruction ROM for execution by the processor.

### 1. Closest and Farthest Hamming Pairs

Finds the minimum and maximum Hamming distances among pairs of signed 16-bit values.

- Input: Array of 32 half-words stored in data memory
- Assembly: [`program1.txt`](assembly_code/program1.txt)
- Machine code: [`machine_code_p1.txt`](machine_code/machine_code_p1.txt)

### 2. Closest and Farthest Arithmetic Pairs

Finds the minimum and maximum absolute arithmetic differences among pairs of signed 16-bit values.

- Input: Array of 32 half-words stored in data memory
- Output: Minimum and maximum differences stored in data memory
- Assembly: [`program2.txt`](assembly_code/program2.txt)
- Machine code: [`machine_code_p2.txt`](machine_code/machine_code_p2.txt)

### 3. 16 × 16-bit Multiplication

Performs signed 16-bit × 16-bit multiplication to produce a 32-bit result.

The multiplication algorithm uses **shift-and-add arithmetic** rather than a dedicated multiplication instruction.

- Input: Two signed 16-bit values
- Output: 32-bit signed product
- Assembly: [`program3.txt`](assembly_code/program3.txt)
- Machine code: [`machine_code_p3.txt`](machine_code/machine_code_p3.txt)

---

## Processor Architecture

![Processor Architecture](/images/processor-architecture.png)

---

## Instruction Set Architecture

The processor uses **9-bit fixed-length instructions** divided into five instruction formats.

| Type | Format                                               | Instructions               |
| ---- | ---------------------------------------------------- | -------------------------- |
| A    | `opcode[8:6] register[5:4] register[3:2] funct[1:0]` | `and`, `xor`, `add`, `adc` |
| B    | `opcode[8:6] register[5:3] register[2:0]`            | `mov`, `lb`, `sb`, `cmp`   |
| C    | `opcode[8:6] register[5:4] immediate[3:0]`           | `addi`                     |
| D    | `opcode[8:6] funct[5:4] unused[3] register[2:0]`     | `shl`, `rlc`, `shr`, `rrc` |
| E    | `opcode[8:6] type[5] offset[4:0]`                    | `ju`, `bge`, `done`        |

### Opcode Map

| Opcode | Instruction Group          |
| ------ | -------------------------- |
| `000`  | `and`, `xor`, `add`, `adc` |
| `001`  | `mov`                      |
| `010`  | `lb`                       |
| `011`  | `sb`                       |
| `100`  | `cmp`                      |
| `101`  | `addi`                     |
| `110`  | `shl`, `rlc`, `shr`, `rrc` |
| `111`  | `ju`, `bge`, `done`        |

For the complete ISA specification, instruction encodings, and examples, see [`ISA.md`](ISA.md).

---

## Register Architecture

The processor contains **eight general-purpose 8-bit registers**, `R1`–`R8`.

### General-Purpose Registers

| Encoding | Register |
| -------- | -------- |
| `000`    | R1       |
| `001`    | R2       |
| `010`    | R3       |
| `011`    | R4       |
| `100`    | R5       |
| `101`    | R6       |
| `110`    | R7       |
| `111`    | R8       |

Some instruction formats use reduced register fields to fit within the 9-bit instruction width.

A-type instructions use 2-bit register fields and therefore access:

| Encoding | Register | Value           |
| -------- | -------- | --------------- |
| `00`     | R1       | General-purpose |
| `01`     | R2       | General-purpose |
| `10`     | RL       | `0b0000_0001`   |
| `11`     | RM       | `0b1000_0000`   |

`RL` and `RM` are read-only constant registers that provide frequently used values without requiring immediate operands.

A-type instructions write their result to **R3**, giving this instruction group accumulator-like behavior.

---

## Instruction Set

### Arithmetic & Logical Operations

| Instruction | Description                     |
| ----------- | ------------------------------- |
| `and`       | Bitwise AND                     |
| `xor`       | Bitwise XOR                     |
| `add`       | Addition with carry flag update |
| `adc`       | Addition with carry             |

Example:

```asm
and R1, R2
```

If:

```text
R1 = 00010001
R2 = 10010000
```

then:

```text
R3 = 00010000
```

---

### Data Movement & Memory

| Instruction | Description                    |
| ----------- | ------------------------------ |
| `mov`       | Move a value between registers |
| `lb`        | Load a byte from memory        |
| `sb`        | Store a byte to memory         |

Example:

```asm
mov R1, R2
```

Register-indirect memory operations use a register as the memory address:

```asm
lb R1, R2
```

```text
R2 ← memory[R1]
```

and:

```asm
sb R1, R2
```

```text
memory[R2] ← R1
```

---

### Comparison

`cmp` compares two register values and updates the comparison flags.

```asm
cmp R1, R2
```

The less-than flag is determined from the unsigned comparison of the operands.

---

### Immediate Arithmetic

`addi` adds a 4-bit unsigned immediate value to a register.

```asm
addi R1, 3
```

Example:

```text
R1 = 00010001

addi R1, 3

R1 = 00010100
```

---

### Shift & Rotate

| Instruction | Description                |
| ----------- | -------------------------- |
| `shl`       | Shift left                 |
| `rlc`       | Rotate left through carry  |
| `shr`       | Shift right                |
| `rrc`       | Rotate right through carry |

Example:

```asm
shl R1
```

Shift and rotate operations interact with the carry flag to support multi-byte arithmetic.

---

## Control Flow

The processor uses **PC-relative addressing** for control-flow instructions.

### `ju`

Unconditionally modifies the program counter relative to its current position.

```asm
ju 7
```

### `bge`

Branches based on the processor's comparison state.

```asm
bge 7
```

### `done`

Signals that program execution has completed.

```asm
done
```

`done` is encoded as a `ju` with a zero offset.

---

## Addressing Modes

The processor supports several addressing mechanisms.

### Register Addressing

Arithmetic and logical operations operate directly on register operands.

```asm
add R1, R2
```

### Register-Indirect Addressing

Memory operations use the contents of a register as a memory address.

```asm
lb R1, R2
sb R1, R2
```

### Immediate Addressing

`addi` provides a 4-bit unsigned immediate operand.

```asm
addi R1, 3
```

### PC-Relative Addressing

Jump and branch instructions calculate their target relative to the current program counter.

---

### Custom Assembler

A custom assembler was developed to convert assembly source files into **9-bit machine-code files** used by the processor's instruction ROM.

The [`custom assembler`](assembler.py) automates the conversion from assembly language to machine code. It:

* Reads an assembly text file as input
* Parses assembly instructions and operands
* Converts each instruction into its corresponding 9-bit machine-code encoding
* Resolves labels and calculates the required **PC-relative branch offsets**
* Outputs the resulting machine code to a text file for use in the instruction ROM

```text
Assembly Source (.txt)
        ↓
[Custom Assembler](assembler.py)
        ↓
9-bit Machine Code (.txt)
        ↓
Instruction ROM
        ↓
Processor
```

**Branch chaining is handled manually in the assembly programs.** Because the ISA has a limited branch offset field, long-distance control flow is implemented by chaining multiple branches together. The assembler automatically calculates the offsets for each branch based on the resolved label locations.

---

## Hardware (SystemVerilog) Implementation

The processor is implemented in **SystemVerilog** using modular RTL components. The `top_level.sv` module integrates the datapath, control logic, register file, memory, and program-control components into the complete processor.

### Architecture Specifications

| **Component**         | **Specification**                             |
| --------------------- | --------------------------------------------- |
| **Datapath**          | 8-bit                                         |
| **Instruction Width** | 9-bit                                         |
| **Data Memory**       | `2^8` bytes (256 bytes)                       |
| **Instruction ROM**   | `2^10` instructions (1024 instructions)       |
| **Register File**     | `2^3` registers (8 general-purpose registers) |

### Processor Modules

| **Module**                                                                                                               | **Description**                                                            |
| ------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| [`top_level.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/top_level.sv)         | Top-level processor module integrating all datapath and control components |
| [`alu.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/alu.sv)                     | Arithmetic and logic operations                                            |
| [`shifter.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/shifter.sv)             | Shift and rotate operations                                                |
| [`compare.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/compare.sv)             | Compares register operands and generates comparison flags                  |
| [`flags.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/flags.sv)                 | Stores and manages processor status flags                                  |
| [`reg_file.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/reg_file.sv)           | General-purpose register file                                              |
| [`reg_lut.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/reg_lut.sv)             | Register lookup / constant register mapping                                |
| [`pc.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/pc.sv)                       | Program counter                                                            |
| [`ir.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/ir.sv)                       | Instruction register                                                       |
| [`control.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/control.sv)             | Instruction decoding and processor control signals                         |
| [`branch_jump.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/branch_jump.sv)     | Branch and jump address/control logic                                      |
| [`data_memory.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/data_memory.sv)     | Data memory interface and storage                                          |
| [`alu_src_mux.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/alu_src_mux.sv)     | Selects ALU input sources                                                  |
| [`c_src_mux.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/c_src_mux.sv)         | Selects carry/input source                                                 |
| [`data_src_mux.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/data_src_mux.sv)   | Selects data source for the datapath                                       |
| [`reg_w_src_mux.sv`](https://github.com/joannaxju/custom-8bit-risc-processor/blob/main/processor_files/reg_w_src_mux.sv) | Selects the value written back to the register file                        |

---

## Verification

Verification was performed at both the **module level** and **processor level** using **Questa/ModelSim** simulation and waveform analysis. The SystemVerilog design was also synthesized and tested in **Intel Quartus** for FPGA development.

### Module-Level Verification

Individual SystemVerilog modules were tested to verify:

* ALU operations and arithmetic results
* Register-file reads and writes
* Carry flag behavior
* Shift and rotate operations
* Program-counter updates
* Instruction fetching
* Branch and jump behavior
* Data memory read/write operations
* Control and datapath signal behavior

### Processor-Level Verification

The integrated processor was verified by executing the three target programs using dedicated testbenches:

* **Program 1:** Closest and Farthest Hamming Pairs
* **Program 2:** Closest and Farthest Arithmetic Pairs
* **Program 3:** 16 × 16-bit Multiplication

When switching between programs, the **instruction ROM contents must be updated with the corresponding machine-code file** so that the processor executes the intended program.

All processor testbenches are available in the [`testbenches`](testbenches/) directory.

Verification included:

* Executing custom assembly programs through the complete datapath
* Confirming correct instruction decoding and execution
* Checking register and flag updates
* Verifying memory reads and writes
* Confirming branch and jump behavior
* Comparing program outputs against expected results

### FPGA Development

The SystemVerilog files were imported into **Intel Quartus** for FPGA development and synthesis. The resulting hardware architecture was inspected using the Quartus **RTL Viewer**.

![RTL Viewer](/images/processor-architecture.png)

---

## Key Design Challenges

### Limited Branch Offset Bits

The initial branch design used only **3 offset bits**, which severely limited the reachable branch distance and resulted in extensive instruction chaining—over 1,000 chained branches for each program. The offset field was expanded to **5 bits**, making better use of the available 9-bit instruction space and substantially reducing the amount of branch chaining required.

### 9-bit Instruction Constraint

The fixed 9-bit instruction width required careful allocation of bits between opcodes, register fields, function fields, immediate values, and branch offsets.

### Hardware/Software Co-Design

The ISA and assembly programs were developed together. Changes to instruction encoding directly affected the datapath, control logic, assembler, and software running on the processor.

### Limited Register Encoding

Different instruction formats use different register-field widths. A-type instructions use **2-bit register fields**, while B-type instructions use **3-bit register fields**, allowing access to the full eight-register file.

### Multi-byte Arithmetic

The 8-bit datapath required multi-byte algorithms for the 16-bit and 32-bit workloads. Carry-aware operations such as `adc` and rotate-through-carry instructions were important for implementing these algorithms.

### Compact Control Flow

PC-relative branching allows loops and conditional execution without requiring large absolute address fields, keeping the instruction format compact while maximizing the limited instruction width.

---

## Tools & Technologies

| Category     | Technologies                           |
| ------------ | -------------------------------------- |
| HDL          | SystemVerilog                          |
| Simulation   | Questa / ModelSim                      |
| FPGA Design  | Intel Quartus                          |
| Hardware     | Cyclone IV FPGA                        |
| Programming  | Assembly, C++                          |
| Architecture | Custom RISC ISA                        |
| Verification | RTL simulation, testbenches, waveforms |

---

## Project Outcome

Designed and implemented a complete custom 8-bit RISC processor, from ISA definition and instruction encoding through SystemVerilog RTL implementation, assembly programming, machine-code generation, simulation, and FPGA development.

The project demonstrates the complete hardware/software development flow from **instruction-set design to executable programs running on a custom processor**.
