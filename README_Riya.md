# Riya Chard Personal Statement

## Summary of Contribution

For my contribution to the coursework, I contributed in 5 ways to the final RISC-V cpu:

1) During Lab 4 I was tasked with implementing the programme counter and next pc blocks.
2) For the Lab 5 brief I was tasked with implementing the Data memory in order to implement the reference programme.
3) I also implemented the artitecture for a shift slli instructure.
4) I worked with Bhavya to understand and implementing the changes indeeded to execute the reference programme. This included the changes indeed to implement load byte and store, implementing adding registers and load upper immidient. 
5) As we had implemented the reference additions before pipelining, I merged the working reference code cpu with the pipelined f1, to produce our final working Pipelined RISC-V F1 and Reference.

### Lab 4 - Programme Counter and Control Unit/Sign Extend Debugging

In order to create a working single cycle RISC-V, the tasks were split into 4 for Lab 4. We randomly allocated the tasks and I was allocated task 1, which consisted of changing the PC counter to either increment by 4 or be the addition of the immOP and PC depending on the PCsrc from the control unit.I implemented this using a separate countmux.sv modules which represented the multiplexer switching between the jump and branch. Finally i created a top module called toppc.sv which would combine both modules to take in the current pc and ImmOp and output the new PC depending on PCsrc.

<img width="269" alt="Screenshot 2022-12-15 at 14 02 04" src="https://user-images.githubusercontent.com/115703122/207880649-84a1fce2-fc5a-4fc1-a381-cdecb43f95fd.png">

Changes made:

- When completing the coursework I made the decision to move the mux from a separate module into the top level pc module, as if was more clear and having a module for only a mux was unnecessary. 
- Additionally, when adding jump logic it was required to change the mux from choosing branch pc if PCSrc was high and would instead choose PCTarget for Jump and Branch instructions.
- Finally, in order to pipeline the PC, the PC was moved into a fetch module where it could connect to the instruction module. Inside the Pipelinefetch module was the PCIncr or PCTarget mux and a flip flop to change PCF to PCD. 

Below is the final design used for the toppc.sv module:

Non-Pipelined:

<img width="418" alt="Screenshot 2022-12-15 at 14 14 18" src="https://user-images.githubusercontent.com/115703122/207883287-d4ed7611-b9a8-43d5-ad15-cda16028997c.png">

What I'd do differently:

- I made many small naive errors, such as not setting PC to 32 bits or not adding connecting wires inside top modules, this couldn't been avoided and was due to the fact this was my first task working on the RISC-V CPU.
- At the beginning the design was confusing and not clean as I made additional mux's which was not needed and later changed.

### Data Memory 

When splitting the tasks for F1 we decided that 2 of the team would make the machine code, while the other two would implement it by adding the needed changes to the RISC-V Single Cycle. The new instructions needed were, data memory (load and store word) as we had not done it in Lab4, Shift and Jump. I was in charge of implementing load and store word, as well as logical shift left. When trying to implement it the I began by looking at the RISC-V diagram given in lectures to see the input and output signals driving the Data Memory Module:

<img width="702" alt="Screenshot 2022-12-10 at 11 41 44" src="https://user-images.githubusercontent.com/115703122/206853241-c259f26b-9809-438e-953f-8243c735c360.png">

I began by first understanding how the data memmory module worked, understanding that the address was the addition of the value in RD1 and ImmOp which represented the value within RD1 + Offset. Additionally, tracing the signals ResultSrc and Memwrite from the control unit to enable writing and loading from the data memory. Finally, using the diagram, I knew I'd need to add a Mux to the ALU.sv top level module to switch between load and other operations. 

<img width="957" alt="Screenshot 2022-12-11 at 12 36 28" src="https://user-images.githubusercontent.com/115703122/206903936-efe057d0-ee8c-4eb2-89d9-1cedbbcad260.png">

Next, I made sure to understand the instructon format. As load and store are register addressed, in order to test I would first have to load values into registers using addi instructions. Additionally, the store instruction introduced the S type instruction, which would require changes to the sign extend module.

Once, I had done initial planning. In order to implement load and store word instructions, I did the following:

1)**Creating the Data Memory module** - The data memory required the following inputs: data memory address (ALUout), the write data, write enable, clock, ALUout and read data. The width of the data coming into the data memory was 32 bits, as its the addition of RD1 and Immidient Extended. I decided to set the address width as 2^17-1:0 as in the Project brief we were told Data Memory could only use registers 0x0001FFFF to 0x00001000.

<img width="897" alt="Screenshot 2022-12-11 at 12 48 44" src="https://user-images.githubusercontent.com/115703122/206904483-a5761a04-2590-47fc-8ed6-1772a30dd1ad.png">

2)**Changing the Control Unit**- I added load and store word to our control unit case block, making sure to set Resultsrc and Memwrite high when store and load used.

<img width="230" alt="Screenshot 2022-12-11 at 12 49 05" src="https://user-images.githubusercontent.com/115703122/206904500-1d37ea1b-20be-4251-a516-f166fcc75784.png">

3) Finally, I **Added additional mux after data memory for load instruction** - This was implemented in the ALU.sv top level module,  this will load the read data into the register file if a load instruction is detected (ResultSrc is high), else it will simply output ALUout. 

<img width="471" alt="Screenshot 2022-12-11 at 12 49 28" src="https://user-images.githubusercontent.com/115703122/206904515-cada2c3e-320b-4e9c-85c3-462deaaee4ee.png">

#### Design Decisions and Changes:

**Control Unit changes to remove Combinational loop** 

<img width="829" alt="Screenshot 2022-12-12 at 16 36 22" src="https://user-images.githubusercontent.com/115703122/207101510-95409f50-b201-404f-8d7c-8752aa1a0576.png">

The biggest issue with debugging was a combinational loop occuring in the control unit, because EQ depended on additional signals such as ALUsrc or Immsrc but this signals also depended on EQ. Our first attempt to resolve this was to put EQ in a separate case statement, however this meant that the default values set to zero would conflict with the signals in the second case block. In the end I resolved the warning by creating a separate combinational block for EQ which only depended on PCsrc. I also encountered other simple errors, such as syntax and not leaving a line after endmodule and the machine code. Most errors were debugged by reviewing the signals in GTKwave and establishing which outputs were incorrect and then reviewing the code to see why that occured and how to correct it. Additionally, I had machine code errors not realising the right format for a load store instruction which was fixed by reviewing the instructions and understanding how they were written below:

<img width="778" alt="Screenshot 2022-12-11 at 12 33 46" src="https://user-images.githubusercontent.com/115703122/206903806-44b003a9-796e-47ed-85c2-a78859dd1e46.png">

**Changing ResultSrc from 1 to 2 bits**

Another big change to the data memory architecture was changing ResultSrc from 1 bit to 2 bits. This was changed after trying to implement jump. Orginally, the way I hoped to implement it was by having to multiplexers so that the value going into WD3 in the reg file could be determined by whether ResultSrc was high or if a trigger signal Jal_sel was high (this went high if a jal instruction was present). Bhavya and I decided to change this as ResultSrc could be used to idenify both jumps and load instructions by extending it to 2 bits and setting the values in the control unit. This method made it easier to pipeline and made the code cleaner, without requiring an extra jal_sel in the writeback section. 


**Creating Test Machine Code**- 

<img width="310" alt="Screenshot 2022-12-11 at 12 36 58" src="https://user-images.githubusercontent.com/115703122/206903955-2511d995-40f7-4358-8edf-4eab3ec93772.png">

**Output**- 

The output was 0x001 into a0 which was as expected proving the lw and sw instruction worked.

<img width="526" alt="Screenshot 2022-12-11 at 12 37 16" src="https://user-images.githubusercontent.com/115703122/206903968-30cd4bf0-a8a6-4c4b-aa8c-ae1ee53187ce.png">

What I'd do differently: 

If I was to do this again, I would ensure the control unit was correct and robust instead of making short term fixes such as removing signals and making multiple if else statements, as the control unit was essential for later changes. Not ensuring the control unit was correct at the beginning resulting in much more time debugging.

### Shift Instruction

In addition to implementing the data memory, I also implemented the changed needed for the slli. I made an original version, which consisted of adding an additional module which would take RD1 into a shift module, and if shift select was high then RD1 would be shifted to the left by one bit. The diagram and implementation of the first version of shift is shown below:

<img width="531" alt="Screenshot 2022-12-14 at 11 36 42" src="https://user-images.githubusercontent.com/115703122/207585153-2d7e218a-1049-4e5e-987d-cef1c89cb810.png">

Here is the new control unit instruction, shift select added to the control unit used for shift mux.:

<img width="402" alt="Screenshot 2022-12-14 at 13 11 29" src="https://user-images.githubusercontent.com/115703122/207604251-1c1998ff-5d54-4f6c-9636-bb893e520146.png"> 

In order to implement a shift, I added to things to the CPU:

1)**Shift Module:** - The Shift module takes in the value of RD1 and concatinates the 32 bits in order to implement the shift.

<img width="744" alt="Screenshot 2022-12-14 at 13 12 43" src="https://user-images.githubusercontent.com/115703122/207604517-a5f3ea9a-3937-448a-93ca-e99a150fdfce.png">

2)**Shift Mux:** - For our F1 machine code we used a slli instruction which was a logical shift left, in order to implement this orginallly I added the shift instruction to the control signal, so that for the shift opcode and function 3 a shift select would be set high which would set a multiplexer at the end of the cpu to the value in RD1 concanticated one bit to the left.

<img width="710" alt="Screenshot 2022-12-14 at 13 25 22" src="https://user-images.githubusercontent.com/115703122/207607143-8e7fa74f-7c37-4c1e-a3b4-112494272a73.png">

**Issues with this version:**
- Using a shift module meant that the were additions to the architecture such as mux's and a shift module which are unnecessary and overly compilicated.
- The architecture could only implement a shift by 1 bit and did not fufil the requirements of the instruction to shift by ImmOp.
- Using a concantination to shift was inefficient and its better to use the inbuilt shift operator.
- It was difficult to combine this shift implementation with the jump additions.

#### Design Decisions and Changes:
After trying to merge this version of shift I realised that the inclusion of a flipflop inside the shift module to implement a shift would have knock on affects to other instructions and that there was a better way to approach the design for a shift which was more in line with our current RISC-V architecture:

**Final version:**
The final version involed setting ALUctrl in s shift operation to 001 so that the shift can be implemented inside the ALU module.

Control Unit:

<img width="265" alt="Screenshot 2022-12-14 at 13 26 21" src="https://user-images.githubusercontent.com/115703122/207607342-1b7eec38-041a-4b77-b00f-f64b46fada1c.png">

ALU module:

<img width="322" alt="Screenshot 2022-12-14 at 13 26 40" src="https://user-images.githubusercontent.com/115703122/207607411-6416d5a6-537a-430e-8a3a-38ffc78ad610.png">

Benifts of new design:
- Ultilizes the fact that there are free bits in ALUctrl to implement a shift instruction inside the ALU module.
- No changes required to architecture as shift occurs in ALU.
- As we use the shift operator we can shift by different amounts using Immop.

**Testing:**

I created simple machine code to load the value 0xFF into s0 and then shift the value left by 1 simillar to the shifts in our F1 machine code:

<img width="279" alt="Screenshot 2022-12-14 at 13 38 36" src="https://user-images.githubusercontent.com/115703122/207609911-9e457f30-ad90-4579-a3b3-ae5daaebb3f9.png">

**Output:**

The ouput resulted in a0 outputting a value of 0xFF shifted by 1 with a 0 last bit, as expected, proving the slli shift instruction now worked.

<img width="688" alt="Screenshot 2022-12-14 at 13 39 55" src="https://user-images.githubusercontent.com/115703122/207610175-908ba567-748c-4df3-916c-630dc6e71d46.png">

What I'd do differently:

- I would have looked into the RISC-V artictecture at the beginning to see if there were any signals (such as ALUctrl) which could have been used to implement a shift within the current artictecture, instead of first trying to add new modules and multiplxers which is not needed and messy.

### Reference Programme 

Bhavya and I were tasked with completing the additions needed to execute the reference programme. We started by implementing the LBU (load byte) and SB (store byte) instructions. The first stage of implementing the instruction was planning the changes needed:

1) First I realised that data memory was byte addressed and not word address, this would require changing the design of the data memory module. This meant that if I implemented byte addressing, store and load byte would be simple as I would take from addresses which byte was required. However, to still implement load word and store word, this would require concatinating 4 bytes (addresses) together to output a 32 bit value.

<img width="629" alt="Screenshot 2022-12-15 at 16 38 48" src="https://user-images.githubusercontent.com/115703122/207917478-9d45770a-4d02-4ca3-9ffd-e227f2c136b4.png">

2) Additionally, then we had to decide which values we would take for a store and load word. If we loaded in the address 0x0005 for a store word would we store bytes in addresses 0x0005, 0x0006,0x0007 and 0x0008 OR 0x0004,0x0005, 0x0006 and 0x0007. We believed this was in the mind of the programmer and decided that every load word should always store or load from an address that was a mulitiple of 4. To do this we added the additional var inputs to set every address to the last muliple of 4, then concatinate.

<img width="905" alt="Screenshot 2022-12-15 at 16 47 37" src="https://user-images.githubusercontent.com/115703122/207919274-d630d3cb-cec7-497e-8396-fbb6d5b7dfa4.png">

3) As we needed different functions for store byte and store word and loads and stores, we had to feed funct3 into the data memory module. Funct3 would determine a byte or word instruction and Resultsrc would determine a load, while Memwrite determined a store.

<img width="1048" alt="Screenshot 2022-12-15 at 16 49 43" src="https://user-images.githubusercontent.com/115703122/207919761-ff6be36b-ec35-42f0-a1f4-c8619ab03710.png">

### Pipeline Adding Reference Programme

Debugging LUI:

In order to implement the Reference programme in the pipelined cpu, we had to pipeline the funct3 signal as it was generated in the decode stage but executed in the memory stage. Additionally, I added the reference instructions into the control unit and added the lbu and sb data memory module.

There were two main issues when trying to debug:

1) I belived that if the LUI_En was fed into the regfile it wasn't nessecary to carry it into the Writeback, however I didn't realise the fact that Immop was being written into WD3 which occurs in the Writeback stage. Therefore I needed to add an additional flipflop around the LUI_EN and ImmOpExt signals in order to make sure LUI_EN and ImmOpExt were high at the same time to write into a register.

<img width="254" alt="Screenshot 2022-12-15 at 17 02 10" src="https://user-images.githubusercontent.com/115703122/207922498-9eb5f6da-3db9-4fa6-a7f7-3c525887ac45.png">

2) The second issue I debugged was realising a function inside the testbench was cutting the plot off before it could end. This was used in the non-pipelined reference code to speed up the time to simulate. However, as the pipelined version included NOP's this meant that the values had not all been written into a0. This was fixed by removing the function from the testbench. 

<img width="182" alt="Screenshot 2022-12-16 at 00 50 38" src="https://user-images.githubusercontent.com/115703122/207997108-3daef2bf-ab10-456a-8f51-c568e63fc6a4.png">

## Conclusion

Through the course of the project, I learnt how to implement architecture for a cpu, debugging techniques and how to plan and work with a team to produce a working CPU. In particular, I learnt how to use the issues caused in debugging (after analysing the waveforms) to improve my designs and to create designs that were clear and simple. For example, when implementing shift I changed my design to utilise the free bits in ALUctrl to implement shift in the ALU. At the beginning I made simple syntax and common errors (like forgetting an additional line when writing in machine code). Towards the end of the project, my mistake became more design based and meant I had to do serveral tests and look at waveforms to see where inputs and outputs were wrong and how I could fix the issue. If I had more time I would have liked to try and implement cache, as well as neaten the flipflop that pipelines LUI signals in the pipeline_decode module.

