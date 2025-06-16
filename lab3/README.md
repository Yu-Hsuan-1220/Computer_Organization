# Lab 3 Simple Pipeline CPU
[Spec PPT](https://docs.google.com/presentation/d/1L2WPA3udtcyLymdMj6JigZINcVENxMENIG3D9noC5mM/edit?usp=sharing)
## Introduction
In Lab1 and Lab2, we finished the simple single-cycle CPU. We need to make the CPU more efficient, so in Lab3, we will implement the **pipeline cpu**. We don't need to consider data hazards and control hazards for now.

The pipeline registers module should be implemented by yourself; it stores inter-staged signals at the posedge of the clock. Consider parameter modules.

## Lab Source Code
As for other modules, TAs think you should finish lab3 based on your lab2 submission, so there is no template.

# Pipeline Cycle CPU

## Reference Architecture
As long as it works successfully, it is not necessary to implement it according to the architecture diagram.
![image](https://github.com/nycu-caslab/CO2025/blob/main/Lab3/CO_Lab3_architecture.png)



## Instruction
Your CPU should be able to support the following RISC-V ISA.
- add, addi, sub, and, andi, or, ori
- slt, slti
- lw, sw

## Requirement
- implement pipeline register to store data of previous stage
- Don't need to consider data hazard or control hazard in this lab.

## Submission
Please submit your source code as a zip file to **E3**.

The name of the zip file should be <student_id>.zip, and the structure of the file should be as the following:

**⚠️Please rename the file `SingleCycleCPU.v` to `PipelineCPU.v`.**


```
<stduent_id>.zip
    |- <student_id>/
        |- ...(your source codes)
```

## Hint
- Read the textbook first and understand each submodule's functionality.
- Debugging with waveform makes your life easier.
- Try to generate your risc-v machine code with Ripe; you can write a simple assembly to verify if your code runs as expected.


## Reference
- Computer Organization and Design RISC-V Edition, CH4
- [Ripes](https://github.com/mortbopet/Ripes)
- [RISC-V Reader](http://riscvbook.com/)
- [riscv-isa-pages](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html)
