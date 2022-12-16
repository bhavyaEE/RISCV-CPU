## Individual account + reflections - Bhavya Sharma
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Personal Reflection: 
**What I learnt:**

Through this coursework, I thoroughly understood the structure and design to implement a RISC-V instruction set architecture and was able to apply the knowledge from the lectures in practice for the design. I was able to efficiently collaborate in a group, by breaking down tasks to achieve the deliverables, and gained a thorough understanding of processor design and developed better debugging skills through the coursework: 

-	initially the errors were largely to do with combinational loop errors/syntax/bit-width/consistency in naming across all modules but as the design became more complex with more interdependencies of signals per instruction it became more important to use gtkwave to see what was happening in each module and follow the signals along. 

-	Testing each change/instruction in a modular format by creating a dummy set of instructions then expanding to a larger test case and testing with the final machine code. 

-	My approach and mindset towards solving a problem was also enhanced by continuing to probe deeper whilst debugging, looking at every signal, going back and understanding what each value should be vs what it actually is and then digging deeper again to figure out why that is happening to reach the solution; as opposed to changing around a few signals in a trial and error method. 

**What I would've done differently:**

Instead of delegating at the start, I believe it would have been more beneficial for the team to discuss and get a very clear understanding of how each module works collectively. Since the modules had interdependencies on each other, the lack of discussion made the debugging process harder since it was assumed that the inputs and outputs were all named/implemented in a standard format - again, setting a framework for this from the beginning would have been useful. Over the course of the project we became significantly better at communicating as a team, having regular Teams calls with the whole team to update each other on the progress, discuss errors and set internal deadlines. I would also add more commenting to my code - I started doing this a lot more with the latter half of my work than I did at the beginning as it would make it easier when going back over it to undertsand what was done and why. 

**What I would've done with more time:**

If I had more time, I would have liked to spend it to explore stretch goal 2 to implement caching. 

**Contributions:**

- Lab 4: Testbench and Top Level CPU module - although making the testbench was quite simple based on previous labs since I was testing the final program I spent a considerable amount of time debugging the errors from the individual modules; the vast majority of these were based on syntax errors and signals that were common across modules and some logic errors which enabled me to get a deep dive into the functionality and logic of every module. For the top level module I made a diagram understanding the inputs and outputs from every module that were going into another module to ensure I had covered all of the cases: 
![image](https://user-images.githubusercontent.com/107200668/208176121-a1457d27-4064-424a-9bcc-054ea2c65f1a.png)


- Testbenches for Coursework: continuining the thread from Lab 4, I made the necessary adjustments to the basic testbench for the F1 and Pipelined PDF cases. In the latter case it was simply increasing number of cycles and only plotting when there was value in a0 rather than plotting every cycle to reduce compiling time. 

- Implementing Machine Code for F1 Light sequence with additional instructions not covered in Lab 4
 
- Implementing additional changes for Reference code: LUI, LBU, SB instructions (and LW + SW) 

- Testing + Debugging for the above tasks and for the pipelined CPU
 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Design Choices:


## 1. F1 Program Instructions (Jump)

The basic JAL implementation is outlined in the main README of adding signals to control unit. 
In this section, I will describe the issues/ideas considered during implementation. 

**Each stage was realised through creating small machine code instructions to check if jumps were happening and viewing on gtk wave to see which signals were going high/low compared to what should happen to understand what further changes were required.**

1. I started off by looking at the ISA to understand how the bits were split in the instruction:
![image](https://user-images.githubusercontent.com/107200668/208124106-0283f30e-d1f9-4f10-a43d-9f772161a078.png)
![image](https://user-images.githubusercontent.com/107200668/208124353-d531664e-167c-4e5d-933e-8d7b643d9937.png)


![image](https://user-images.githubusercontent.com/107200668/208124598-67978c8a-a19a-4644-8fad-2a9bc515fa35.png)
![image](https://user-images.githubusercontent.com/107200668/208124618-998f48ed-5d6f-4771-8b09-7f04b19a8fc8.png)

I was unsure of the bits used to offset when looking at the ISA in the two pictures above for the instruction bits used to make the immediate and the immediate bits used in the instruction. Hence, why the earlier commits have the extra lines in Sign Extend: 
![image](https://user-images.githubusercontent.com/107200668/208125201-e54cc067-f7a6-4dc7-bedf-e14523555a5c.png)

In the next commit: "added correct offset and extra signals" I understood the correct way to encode the immediate in order to offset the PC for the jump which was to take the specified bits in the instruction: 
![image](https://user-images.githubusercontent.com/107200668/208126775-be3312e4-1ce1-4247-9cb2-c703f46eaf1e.png)

2. The value from the jalr offset was outputted through ALUOut since it is Imm + RS1 and needed to be fed into PC so I added a 'sum' wire to link the two modules in the top level. For the purposes of RET this may not have been required since the offset is usually zero, but in order to follow the function of a JALR I took the output from the ALU. 
3. In order to set the value of PC equal to the addresses from the jal/jalr/bne instructions I added the following logic in the top level PC module:
![image](https://user-images.githubusercontent.com/107200668/208202828-e9f773d7-757d-4ff3-bcca-b708038205e1.png)

4. The final addition made was to write the correct value to the register in a JAL to store the address of the next instruction; this required changing the input to WD3 input in Regfile in top level ALU module to equal 'PC + 4' or ALUOut (additional jal enable signal added to serve as select line in this mux). 

![image](https://user-images.githubusercontent.com/107200668/208129726-c685facf-17c4-4877-9693-0d425db5867e.png)


## 2. Reference Program Instructions (LBU + SB)

The diagram below outlines how I visualised the memory to be split up into bytes from a word. Once we realised that the only way to implement these instructions was to make the data memory byte addressed, it was quite clear that the specific byte to be addressed would simply be the value of the Immediate + RS1 in the case of an LBU. 

![image](https://user-images.githubusercontent.com/107200668/207979183-85bfd8e8-b6cb-4563-91b3-6078d16bddd5.png)

The main design choices came into play for selecting a word either to be loaded into a register or a word to be stored into memory since the instruction: Imm + RS1 would still give a number which corresponds to a byte. 
Therefore to select a word, 2 possible design choices were considered: 

1.	Start at the byte specified and offset from there by 1,2 and 3 to concatenate consecutive bytes to form a word, i.e. **if Imm + Rs1 = 5: 
Corresponding Word: Bytes {5,6,7,8}**
2.	Regardless of which byte was selected, the word selected should correspond to the word indicated in the table above; since this matched the previous word addressing format this option was selected.
**If Imm + Rs1 = 5:  
Corresponding Word: Bytes {4,5,6,7}**
In order to implement Option 2, an algorithm/formula was needed to always start from byte 0,4,8,12 etc. to concatenate the correct bytes to form a word. 

I enabled this as follows: 

ALUOut = Imm + Rs1

Var1 = ALUout % 4

Var2 = ALUOut – var1 (to offset backwards by the remainder found by the modulus function) 

Example: 
Let ALUOut = 7; var1 = 3; var2 = 7-3 = 4

Thus, addressing is as follows: [var2 (byte 4)] + [var2 + 1 (byte 5)] + [var2 + 2 (byte 6)] + [var2 + 3 (byte 7)]
![image](https://user-images.githubusercontent.com/107200668/207979275-3957d3a6-3f22-44ce-aef2-8191b07912bf.png)

The final input regarding concatenation lies in load word; it begins from the offset of 3 and decreases. The reason for this is demonstrated through the diagram below; this helped me to understand the idea of design implementation regarding how the computer reads data/how it is visualised in the programmer’s mind. 

![image](https://user-images.githubusercontent.com/107200668/207979469-b00fde20-1a0d-4ed4-b4dc-08f12ce2dd11.png)

Illustrated through outputs on gtkwave: 

![image](https://user-images.githubusercontent.com/107200668/208199609-0209ef12-737f-4c5f-9146-b75e20492e97.png)

![image](https://user-images.githubusercontent.com/107200668/208199619-8b982243-6206-474d-8861-81707ed0db37.png)


I also realised that due to the reset while i<3 condition in the testbench, I needed a NOP before an addi instruction otherwise, it would keep repeating thrice as PC would not increment. 

![image](https://user-images.githubusercontent.com/107200668/208199010-66317afa-4367-491f-a705-e84a139b1fa5.png)

![image](https://user-images.githubusercontent.com/107200668/208202452-a7be20d7-1709-458a-a2b1-22205f2c7c01.png)

Correct output after NOP: 

![image](https://user-images.githubusercontent.com/107200668/208202424-543e1f4f-ae37-4382-8466-a76a6d009f97.png)


**ADD Instruction** 
As outlined in the main, we realised during Reference Program testing that we had only implemented an ADDI instruction and not an ADD. 
A key observation I made during this implementation was that: the zero register was actually being written to in a jalr instruction and when I used the zero register to test the ADD instruction for the Reference Program, the outputs were incorrect. 

Initially an assign statement was used to set reg_array[0] = 0; however, I remembered from work in the previous labs that the 'assign' would not mean that the zero register doesn't get overwritten so I changed the condition for writing to a register from only dependent on WE HIGH to WE HIGH & AD3 !=0 meaning if the register to be written to was ever x0 then a write operation would NOT take place. 

- ![image](https://user-images.githubusercontent.com/107200668/208074780-41c5ba6d-0db8-4af1-a18b-9c52c6f91f49.png)

To add new instructions key changes were made to the Control Unit and Sign extend module. 

## 3. Pipelining F1 + Reference Program - Debugging Process

Key changes: 

1. When using the make file reference command to generate the pdf.hex file, the instructions had to be read in the opposite order to how we were reading them earlier versions where the Instruction file was generated from the assembler (same concept as how programmer views/how computer reads). 
2. Jump logic changes: the jump logic was amended to match the diagram on the MAIN README (from Lecture slides on Pipelining) by moving all the relevant multiplexers to the to the execute stage/modules to feed into PCTargetE which was going directly into the PC module

![image](https://user-images.githubusercontent.com/107200668/208191516-ab497ece-12b7-4198-aafa-28ab89f7dd3e.png)
![image](https://user-images.githubusercontent.com/107200668/208193443-18f6ed7e-e072-468f-9925-7ff01eb8163f.png)

3. Again to match the pipelined diagram, the AND/OR logic to feed into PCSrcE was added along with BranchSel and JumpSel signals; this also meant EQ was no longer governing PCsrc inside the Control Unit enabling that module to be tidied up. 
 
![image](https://user-images.githubusercontent.com/107200668/208192009-2afd334d-5ca5-4099-9779-1aeaf3ffefcc.png)
![image](https://user-images.githubusercontent.com/107200668/208193466-b5e27d97-6a81-436b-925e-f45822d795a4.png)

The rest of the debugging was mostly ensuring all relevant trigger signals were carried across to all stages, and ensuring consistency in the module hierarchies of inputs/outputs. 
