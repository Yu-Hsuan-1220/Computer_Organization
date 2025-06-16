# Assembly Language & CPU Component Units Lab

## Lab1 Slide
[CO2025_lab1_slide](<https://docs.google.com/presentation/d/1U3eBYWhgzu3JpwWNcfbryPxrTzjgh2a2/edit?usp=drive_link&ouid=110416110109267348957&rtpof=true&sd=true>)

## Intro.

This lab is divided into two parts. The first part will focus on getting familiar with basic RISC-V assembly instructions and implementing some simple functions. In the second part, you will dive deeper into understanding and implementing key components of the processor, specifically the ALUCtrl and the ALU itself. These components are crucial for understanding how instructions are processed and executed in a RISC-V pipeline.<br/>

By the end of this lab, you will have a better grasp of assembly language programming and how the ALU and control signals interact in a processor.<br/>


## Part 1: Basic Assembly Functions

Before you start to write this lab, we will quickly introduce some basic instructions in RISC-V and what do they actually do. Please don't be nervous, take a deep breath and we will start to dive into assembly language. <br/>

There are three basic functions you have to implement with assembly code. We have prepared the template of both c code and assembly code of these three functions and you have to filled the absence of assembly code in order to fulfill those three functions. You may check simply check whether your code is correct by the output of c code or using ripes. <br/>

- xor_trick
- dynamic programming
- fibonacci

### Brief Tutorial of assembly language

In this part, we will quickly go through some common instructions and introduce them to you. <br/>

**add**<br/>
```
add rd, rs1, rs2
```
This instruction will add the value that stored inside register rs1 and register rs2 together and store it into register rd.<br/>

**sub**<br/>
```
sub rd, rs1, rs2
```
This instruction will subtract the value that stored inside register rs1 and register rs2 then store it into register rd.<br/>

**addi**<br/>
```
addi rd, rs1, imm1
```
This instruction will add the value of register rs1 and immediate imm1 together then store the result into register rd. <br/>

**mv**<br/>
```
mv rd, rs1
```
In fact, mv(move) is the pseudo-instruction, and it is equal to addi rd, rs1, 0. So this instruction is actually just move or better to say copy from rs1 to rd.<br/>

**li**<br/>
```
li rd, imm1
```
Same as above, li is also a pseudo-instruction; however, it's hard to explain, so we will skip it. This instruction will copy the immediate imm1 to register rd.<br/>

**lw**<br/>
```
lw rd, rs1, imm1
# Assume we store the array a[0] address in reg. a1
lw a0, 0(a1)    # this instruction will load a[0] to reg. a0
lw a0, 4(a1)    # this instruction will load a[1] to reg. a0
```
lw instruction will load the value of address "rs1 + imm1" to rd. In execution, you should be careful of the memory maintainence. If you miscalculate the address, it may lead to a horrible error. <br/>

**sw**<br/>
```
sw rs2, rs1, imm1
# Assume we store the array a[0] address in reg. a1
sw a0, 0(a1)
# this instruction will store the value of reg. a0 into a[0]
sw a0, 4(a1)
# this instruction will store the value of reg. a0 into a[1]
```
sw instruction will store the value of reg. rs2 into address "rs1 + imm1". <br/>

**beq**<br/>
```
beq rs1, rs2, imm1
# Example code
entry:
    addi a3, x0, 0
    addi a4, x0, 0
    beq a3, a4, entry
# since the value of a3 and a4 reg. are both, beq will branch to entry, so it will form an infinite loop
```
beq will compare the value of reg. rs1 and reg. rs2, if the value equals to each other, then branch to the address "PC + imm1". <br/>

**bge**<br/>
```
bge rs1, rs2, imm1
# Example code
entry:
    li a3, 4
    li a5, 7
    bge a3, a5, entry
# since the value of reg. a3 is smaller than a5, so it will not branch to entry
```
bge will compare the value of reg. rs1 and reg. rs2, if the value of reg. rs1 is larger or equal to that of reg. rs2, then branch to the address "PC + imm1". <br/>

**blt**<br/>
```
blt rs1, rs2, imm1
# Example code
entry:
    li a2, 3
    li a4, 4
    blt a2, a4, entry
# since the value of reg. a2 is less than reg. a4, so it will form an infinite loop
```
blt will compare the value of reg. rs1 and reg. rs2, if the value of reg. rs1 is less than that of reg. rs2, then branch to the address "PC + imm1". <br/>

**j**<br/>
```
# Example code
entry:
    li a0, 1
    j second_process    # this line will jump to second_process
    addi a0, a0, 1
second_process:
    ...
# because the line "addi ..." will not be executed, so the value of reg. a0 is 1 not 2
```
j is also a pseudo-instruction. j is a kind of unconditional branch instruction, so when j is executed, it will directly jump to the destination.

**jal**<br/>
```
jal rd, imm
```
jal is jump and link. In the cpu, jal will have two step to execute. First step, rd = pc + 4. Second, pc = pc + imm. This instruction is really important when you are implementing 
things with function call.<br/>

**slli**<br/>
```
slli rd, rs1, imm1
# Example code
addi a1, x0, 1  # a1 -> 1
slli a2, a1, 2  # a2 -> 100(binary) -> 4(decimal)
# In this instruction, slli will move the value in reg. rs1 imm1 bits left, then store the value into reg. rd
```

### Problem 1(xor_trick):<br/>
Description:<br/>
Given an array ``arr``, you have to return the result after every element xor with each other.<br/> 

Example 1:<br/>
Input: arr = [1, 2, 3]<br/>
Output: 0<br/>
Explanation: 1(01) xor 2(10) => 3(11), 3(11) xor 3(11) => 0(00)<br/>

Example 2:<br/>
Input: arr = [1, 3, 7]<br/>
Output: 5<br/>
Explanation: 1(001) xor 3(011) => 2(010), 2(010) xor 7(111) => 5(101)<br/>

If you are still confused of how xor work, the link below explain xor in detail:<br/>
<https://medium.com/@berastis/demystifying-xor-the-power-of-the-exclusive-or-in-programming-1d581f914a68>

Constraints of the testcase:
- 0 < arr.length < 200
- for all i, 1,000,000,000 > arr[i] > 0, arr[i] is always an integer

### Problem 2(dp):<br/>
Description:<br/>
You are given an array ``charge`` and a variable ``T``. In the same row of the array, the first element represent the length of the timber, and the second element is the corresponding rewards. For example, ``charge = [ [1, 2], [2, 5] ]`` means that in this condition you will gain 5 rewards if you cut a timber with lenght 2, and you will gain 2 rewards if you have a timber which length is 1. The variable ``T`` is the total length of timber you got, and what you have to do is to return the maximum rewards under the given array and total length. <br/>

Example 1:<br/>
Input: charge = [ [1, 2], [2, 5] ], T = 5<br/>
Output: 12<br/>
Explanation: 5 = 2 + 2 + 1, maximum rewards = 5 + 5 + 2 = 12<br/>

Example 2:<br/>
Input: charge = [ [3, 9], [4, 9] ], T = 12<br/>
Output: 36<br/>
Explanation: 12 = 3 + 3 + 3 + 3, maximum rewards = 9 + 9 + 9 + 9 = 36<br/>

FYI, this is a classic problem that can be solved with dynamic programming.<br/>

Constraint of the testcase:
- for all i, j, charge[i][j] >= 0
- for all i, charge[i].length == 2
- 0 < charge.length < 40
- 0 < T < 1,000

### Problem 3(recursive):
Description:<br/>
You are given the variable ``term`` and you have to return the term ``term`` of the fibonacci sequence. <br/>

Fibonacci sequence:
F0 = 0, F1 = 1, Fn = Fn-1 + Fn-2, for all n>=2 and n is integer<br/>

Example 1:<br/>
Input: term = 5<br/>
Output: 5<br/>
Explanation: fibonocci sequence: 0, 1, 1, 2, 3, 5...<br/>

Example 2:<br/>
Input: term = 10<br/>
Output: 55<br/>
Explanation: fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55...<br/>

Constraint of the testcase:<br/>
- 0 <= term <= 30

### Registers' list:<br/>
![register list](https://i.sstatic.net/2xdbB.png)
You may have to look carfully in this image, since you might have to use the correct register so as to implement the assembly without error. <br/>

### Here are some hints for you:<br/>
1. Make sure you completely understand the difference between caller register and callee register.<br/>
2. Make sure you know which register is safe to use in your code.
3. Make sure you have totally understanding each register's function. 

## Part 2: ALU Control and ALU Implementation
In this section, you will focus on the inner workings of a RISC-V processor, specifically the ALU Control and ALU units. These components are responsible for determining how operations are performed based on control signals from the Control Unit.<br/>
**Note**: This lab only requires the implementation of ALUCtrl and ALU. However, to facilitate understanding of the overall concept, suggestions for writing the Control unit are also provided.<br/>
### How to Write Control
- First, understand the ISA and what each field represents (OPcode, funct3, funct7, etc.).
- Choose an instruction to implement.
- Check whether the OPcode is unique among all the instructions you need to implement.
- If it is unique, you can directly use the OPcode to identify the instruction.
- If not, use funct3 to assist in identifying the instruction.
- Once the instruction is identified, it will output unique control signals depending on the instruction (PCSel, ALUOp, regWrite, memWrite, etc.).
- For example, for the `sw` instruction, regWrite should be 0, and memWrite should be 1 (no need to write to the register, but memory needs to be written to).
- ALUOp (for reference only)

| Type | ALUOp |
| -------- | -------- |
| lw, sw     | 00     |
|branch| 01|
| R-type|10|
|I-type| 11|

### How to Write ALUCtrl
- ALUCtrl will receive ALUOp from the control unit, along with funct3 and funct7.
- These inputs are used to determine which ALUCtrl signal (control signal) to output in order to control the ALU's operation.
- The control signals can be customized as long as the final computation results are correct.
- ALUCtrl (for reference only)

| Type | ALUCtrl |
| -------- | -------- |
| add     | 0010     |
|sub| 0110|
| and|0000|
|or| 0001|
|slt|0111|

### How to Write ALU
- After receiving ALUCtrl, determine the operation to be performed.
- Execute the operation based on the determination.

## Requirement
1. **Assembly Code Implementation** :
    Implement xor, dp, and recursive with assembly language. To notice that your result of c and assembly should be the same.
1. **ALU and Control Logic**
  - Implement the ALUCtrl and ALU modules in Verilog.
  - Your ALUCtrl must correctly interpret ALUOp, funct3, and funct7 to output the correct ALU control signals.
  - Your ALU must perform operations based on the control signals provided by ALUCtrl and output the correct result.
  - Control signals for operations such as add, sub, and, or, slt must be correctly defined and interpreted.

## Reference:<br/>
[Stackoverflow](https://stackoverflow.com/questions/74094483/why-temporary-registers-and-saved-registers-in-risc-v-are-not-numbered-sequentia)