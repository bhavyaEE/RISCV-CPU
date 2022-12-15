# iac-riscv-cw-11
## Initial Approach

- We began the project by **planning the tasks**, this included understanding the objectives of the task as a team as well as creating and delegating tasks. 
- Once the tasks had been delegated, **machine code** which would implement the f1 light switch was created and checked by other member of the team.
- After the machine code was created we delegated the tasks of **implementing the machine code**, adding new architecture which is needed for the machine code, based on the pre-built blocks in Lab 4. This included planning the additions to the cpu, implementing the changes and then begugging any issues.
- Next, we **implemented the reference code**, this involed adding a load byte and store byte instruction and testing the reference code against our cpu.
- Finally, we piplined the RISC-V cpu and tested our final design. 

## Planning

### Understanding the Project Brief 

Before doing our separate tasks, we also came together as a team to understand the specification of the project. 
1) We ensured our machine code included a Jump and Link instruction to excute the F1 sequence.
2) We first aimed to complete the F1 program and Reference and then attempt pipeline and cache as challenges.
3) We made sure to include the inputs and outputs to the RISC-V processor below. This include a reset, this resets only the processor to start the program, and is not used to reset counters or a state machine. Addditionally, we implemented a trigger signal used to tell RISC-V when to start the F1 light sequence. **We decided for the trigger signal to be automatic, so thatas soon as the program starts, the F1 light sequence is triggered**. 

<img width="588" alt="Screenshot 2022-12-12 at 16 53 18" src="https://user-images.githubusercontent.com/115703122/207105417-c04ce3ca-88a8-4a5b-9f15-46a6a99fc381.png">

<img width="277" alt="Screenshot 2022-12-12 at 16 53 31" src="https://user-images.githubusercontent.com/115703122/207105457-c1e3dd3a-88f3-4c5f-8582-af2e7824466f.png">

When splitting the tasks we decided to work in pairs for machine code and implementation, then reference and piplining. This ensured that as indivduals we were not making simple mistakes and were constantly being questioned with each decision we made. This is how the tasks were divided:
- Machine Code - Isabel and Ethan
- Implementation of Machine Code - Riya and Bhavya 
- Reference Code implementation - Riya and Bhavya 
- Pipelining - Isabel and Ethan

## Machine Code 

Instructions:

main:               
    
    addi t1 , zero , 0xff  //t1=11111111
    
    JAL  ra , loop         //jump to the loop

    addi a0 , zero , 0     //when jump back, reset all

    addi s0 , zero , 0
       
loop: 
    
    addi a0 , zero , 0      //initialize output a0=0

    addi s0 , zero , 0      //initialize intermediate s0=0
    
    addi zero , zero , 0    //NOP avoiding Data Hazard
    
    addi zero , zero , 0    //NOP

mloop:
   
    slli s0 , s0 , 1       //first left shift s0 by 1 bit
    
    addi zero , zero , 0   //NOP 
    
    addi zero , zero , 0   //NOP
    
    addi s0 , s0 , 1       //then add s0 by 1
    
    addi zero , zero , 0   //NOP
    
    addi zero , zero , 0   //NOP

    addi a0 , s0 , 0       //preserve s0 as output a0

    addi zero , zero , 0   //NOP
 
    addi zero , zero , 0   //NOP
    
    bne  a0 , t1 , mloop   //if a0 does not equal to 11111111, back to mloop
    
    addi zero , zero , 0   //NOP avoiding Control Hazard
    
    addi zero , zero , 0   //NOP
    
    jalr t2 , ra , 0       //exit and return to the next line after JAL instruction
    
Explaination:

To execute F1 starting light program originated from state diagram, an output a0 is set up to be compared with the originial output of each state. To make it display as 1, 11, 111, etc., an intermediate vairable s0 is set up to fist shift to left by 1 bit, and then be added by 1 so that each cycle, it can result in desired value. Then s0 is assigned to a0, which is used to light the lighting program. 

Branch not equal compares the a0 with the preset value in t1, which is the last state in the state diagram with output 8'b1. When a0 does not equal to 8'b1, it tunrns out that the lighting needs to continue, so it will branch to the mloop to execute the previous steps again. If, after several executions, a0 finally comes to 8'b1, meaning that all lights are displayed, jalr is executed and it jumps to the instrcution after jal, reseting all the registers.

Since we will implement pipeline without hazrd control unit, we will use two NOP instruction when Data and Control Hazard happens. 

    addi s0 , zero , 0
    slli s0 , 0 , 1
    
For example in loop and mloop we repeatedly used s0 in two consecutive lines which means the s0 value has not been written back to register file before we use it again in second line. 

    bne  a0 , t1 , mloop
    jalr t2 , ra , 0

Another example of Control Hazard happens when we want to branch to mloop if condition satisfies. However we have not decided whether the next line will be return or mloop when the second instruction is fetched therefore we need another two NOP to delay next line by two cycles.
    
Final Machine Code:

    0ff00313
    00c000ef
    00000513
    00000413
    00000513
    00000413
    00000013
    00000013
    00141413
    00000013
    00000013
    00140413
    00000013
    00000013
    00040513
    00000013
    00000013
    fc651ee3
    00000013
    00000013
    000083e7
## Implementation

### Data Memory - Riya
As we had not created a Data Memory as an extention in Lab 4, it was added as a task for the coursework. When trying to implement it the I began by looking at the RISC-V diagram given in lectures to see the input and output signals driving the Data Memory Module:

<img width="702" alt="Screenshot 2022-12-10 at 11 41 44" src="https://user-images.githubusercontent.com/115703122/206853241-c259f26b-9809-438e-953f-8243c735c360.png">

Changes needed for Data Memory:

**Creation of Data Memory module** - In order to create the Data memory module I refered to the final RISC-V diagram. The inputs to the module were the data memory address (ALUout), the write data, write enable, clock, ALUout and read data. 

**Data Memory Address**- The Data Memory address consisted of 32 bits from the ALUout. The ALUout is the addition of rst1 and Immidient sign extended. 

**Write Enable**- According to the RISC-V diagram the write enable comes from a signal within the control unit called MemWrite. I created logic within the control unit to set Memwrite to high if the opcode of the instruction was for a store instruction, as this would require writing to the memory.

**Write Data**- This will take in the data value that will be written into the data memory address if write enable is high (you are implementing a store instruction). Write Data is driven by the value of rst2 from the value within RD2. 

**Clock**- Simillar to the register file, the data memory is clocked. This is important as it avoids writing to an address with trying to read from it, so it is essential that it is clocked logic.

**Read Data**- This would be the output of the Data Memory that gets stored into a register in the regfile (through the regfile write data). The Read data would take the value stored in the data memory from ALUout and only ouput this value into the regfile if Resultsrc signal was high. This signal would be set to high if the opcode for a load was read from the instruction. A mux in the ALU.sv top level module would then select between the ALUout value or the Read Data value depending on if Resultsrc is high. 

Data Memory Module:

<img width="897" alt="Screenshot 2022-12-11 at 12 48 44" src="https://user-images.githubusercontent.com/115703122/206904483-a5761a04-2590-47fc-8ed6-1772a30dd1ad.png">

Control Unit signals:

<img width="230" alt="Screenshot 2022-12-11 at 12 49 05" src="https://user-images.githubusercontent.com/115703122/206904500-1d37ea1b-20be-4251-a516-f166fcc75784.png">

Top Level ALU mux:

In the top level ALU i included the logic for the mux, this will load the read data into the register file if a load instruction is detected (ResultSrc is high), else it will simply output ALUout. 

<img width="471" alt="Screenshot 2022-12-11 at 12 49 28" src="https://user-images.githubusercontent.com/115703122/206904515-cada2c3e-320b-4e9c-85c3-462deaaee4ee.png">

Debugging:

**Control Unit Combinational loop** 

<img width="829" alt="Screenshot 2022-12-12 at 16 36 22" src="https://user-images.githubusercontent.com/115703122/207101510-95409f50-b201-404f-8d7c-8752aa1a0576.png">

The biggest issue with debugging was a combinational loop occuring in the control unit, because EQ depended on additional signals such as ALUsrc or Immsrc but this sigals also depended on EQ. Our first attempt to resolve this was to put EQ in a separate case statement however this meant that the default values set to zero would conflict with the signals in the second case block. In the end we resolved the warning by creating a separate combinational block for EQ which only depended on PCsrc. We also encountered other simple errors, such as syntax and not leaving a line after endmodule and the machine code. Most errors were debugged by reviewing the signals in GTKwave and establishing which outputs were incorrect and then reviewing the code to see why that occured and how to correct it. Additionally, I had machine code errors not realising the right format for a load store instruction which was fixed by reviewing the instructions and understanding how they were written below:

<img width="778" alt="Screenshot 2022-12-11 at 12 33 46" src="https://user-images.githubusercontent.com/115703122/206903806-44b003a9-796e-47ed-85c2-a78859dd1e46.png">

Testing:

In order to test the load and store word instructions, I first had to understand the instruction format. As load and store are register addressed I had to load values into a register using an addi instruction. Then I stored that value into a data memory location, sw t1 0(t2). This stored the value with register t1 (0x001 from previous addi instruction) into the data memory address 0(t2), this means the value in register t2+0 offset so that would store in data memory location 0x1000 from previous addi instruction. In was important that i only accessed memory from the allowed range of data memory addresses from the project brief. 

<img width="957" alt="Screenshot 2022-12-11 at 12 36 28" src="https://user-images.githubusercontent.com/115703122/206903936-efe057d0-ee8c-4eb2-89d9-1cedbbcad260.png">

**Creating Test Machine Code**- 

<img width="310" alt="Screenshot 2022-12-11 at 12 36 58" src="https://user-images.githubusercontent.com/115703122/206903955-2511d995-40f7-4358-8edf-4eab3ec93772.png">

**Output**- 

The output was 0x001 into a0 which was as expected proving the lw and sw instruction worked.

<img width="526" alt="Screenshot 2022-12-11 at 12 37 16" src="https://user-images.githubusercontent.com/115703122/206903968-30cd4bf0-a8a6-4c4b-aa8c-ae1ee53187ce.png">

### Shift - Riya 
When creating the shift I made an orirginal version, which consisted of adding an additional module which would take RD1 into a shift module, and if shift select was high then RD1 would be shifted to the left by one bit. The diagram and implementation of the first version of shift is shown below:

For our F1 machine code we used a slli instruction which was a logical shift left, in order to implement this orginallly I added the shift instruction to the control signal, so that for the shift opcode and function 3 a shift select would be set high which would set a multiplexer at the end of the cpu to the value in RD1 concanticated one bit to the left.

<img width="531" alt="Screenshot 2022-12-14 at 11 36 42" src="https://user-images.githubusercontent.com/115703122/207585153-2d7e218a-1049-4e5e-987d-cef1c89cb810.png">

Here is the new control unit instruction:

<img width="402" alt="Screenshot 2022-12-14 at 13 11 29" src="https://user-images.githubusercontent.com/115703122/207604251-1c1998ff-5d54-4f6c-9636-bb893e520146.png">

Shift select added to the control unit used for shift mux:

<img width="365" alt="Screenshot 2022-12-14 at 13 24 19" src="https://user-images.githubusercontent.com/115703122/207606945-d095c82e-d004-4752-88de-143084632712.png">

**Inside Shift Module:**

The Shift module takes in the value of RD1 and concatinates the 32 bits in order to implement the shift.

<img width="744" alt="Screenshot 2022-12-14 at 13 12 43" src="https://user-images.githubusercontent.com/115703122/207604517-a5f3ea9a-3937-448a-93ca-e99a150fdfce.png">

**Shift Mux:**

<img width="710" alt="Screenshot 2022-12-14 at 13 25 22" src="https://user-images.githubusercontent.com/115703122/207607143-8e7fa74f-7c37-4c1e-a3b4-112494272a73.png">

**Issues with this version:**
- Using a shift module meant that the were additions to the architecture such as mux's and a shift module which are unnessary and overly compilicated.
- The architecture could only implement a shift by 1 bit and did not fufil the requirements of the instruction to shift by ImmOp.
- Using a concantination to shift was inefficient and its better to use the inbuilt shift operator.
- It was difficult to combine this shift implementation with the jump additions.

**Final version:**
The final version involed setting ALUctrl in s shift operation to 001 so that the shift can be implemented inside the ALU module.

Control Unit:

<img width="265" alt="Screenshot 2022-12-14 at 13 26 21" src="https://user-images.githubusercontent.com/115703122/207607342-1b7eec38-041a-4b77-b00f-f64b46fada1c.png">

ALU module:

<img width="322" alt="Screenshot 2022-12-14 at 13 26 40" src="https://user-images.githubusercontent.com/115703122/207607411-6416d5a6-537a-430e-8a3a-38ffc78ad610.png">

- Ultilizes the fact that there are free bits in ALUctrl to implement a shift instruction inside the ALU module.
- No changes required to architecture as shift occurs in ALU.
- As we use the shift operator we can shift by different amounts using Immop.

**Testing:**

I created simple machine code to load the value 0xFF into s0 and then shift the value left by 1 simillar to the shifts in our F1 machine code:

<img width="279" alt="Screenshot 2022-12-14 at 13 38 36" src="https://user-images.githubusercontent.com/115703122/207609911-9e457f30-ad90-4579-a3b3-ae5daaebb3f9.png">

**Output:**

The ouput resulted in a0 outputting a value of 0xFF shifted by 1 with a 0 last bit, as expected, proving the slli shift instruction now worked.

<img width="688" alt="Screenshot 2022-12-14 at 13 39 55" src="https://user-images.githubusercontent.com/115703122/207610175-908ba567-748c-4df3-916c-630dc6e71d46.png">

### Jump - Bhavya

### Merging Jump and Shift

Once the new arcitecture for data memory, jump and shift were created on separate branches we then had to merge all the branches together. This included the following changes:

1) We decided to change the format of the sign extension module to better match the instructions. Inside of labelling the extention by instruction we labelled them by instruction type. This was implemented after realising the sign extend for store was wrong and that Jalr and addi should have the same sign extend as they were boh type I instructions.

<img width="998" alt="Screenshot 2022-12-14 at 17 12 59" src="https://user-images.githubusercontent.com/115703122/207662203-13b204ae-0880-4d8d-ba20-571a7436636e.png">

2) Next, we added the Jump logic to set PCSrc high inside the control unit. 

<img width="353" alt="Screenshot 2022-12-14 at 16 52 29" src="https://user-images.githubusercontent.com/115703122/207657793-dea2a320-9ca8-4c67-8de6-23b1afa3db2b.png">

3) We also added the Data Memory module to the top level and connected it into the cpu at the end of the diagram. 

<img width="149" alt="Screenshot 2022-12-14 at 16 52 39" src="https://user-images.githubusercontent.com/115703122/207657840-756ca4d2-8097-44b7-b9eb-893f681bb747.png">

4) Finally, in order to test we added a vbdBar function into our test bench to record the F1 light sequence on the LED's. 

<img width="109" alt="Screenshot 2022-12-14 at 16 52 54" src="https://user-images.githubusercontent.com/115703122/207657901-a9522942-7ceb-4962-9399-b3c52a1e34f9.png">

**Final diagram of working F1 cpu:**



**Testing**

In order to test the F1 light sequence cpu, we ran the machine code (shown in above section) and analysed the gtkwave output. Once we were happy with the waveforms generated, we added the vbdBar function and saw the correct leight sequence on the Vbuddy. The LED's went up from 1 to 11111111 and then back to zero, as we were expecting. 

<img width="769" alt="Screenshot 2022-12-14 at 17 21 01" src="https://user-images.githubusercontent.com/115703122/207663885-e1881895-b64a-4a49-9de8-7a6443d2d550.png">

## Reference Program - Bhavya and Riya

## Pipelining - Ethan and Isabel

![3901671112433_ pic](https://user-images.githubusercontent.com/69693952/207876411-630165c6-5249-4d3d-bbbc-494151a4d382.jpg)

Pipelining was divided into two parts, firstly we created **four individual pipeline registers**, as shown on the diagram. On each clock cycle, signals move from stage to stage with the same purpose but different instructions. They are distinguished by different suffixes, e.g. D, E, to indicate which stage the signal has reached. In modules, the output signals are given with the input signals synchronously on rising edge of the CLK. In pipe2, control unit was kept the same except that all the control signals are also be pipelined, to arrive in synchrony to the datapath. This ensures that control signals can travel with the data, providing the correct signal to control each stage.

After completing the registers, the **five stages** were creating as top level modules with all blocks and pipeline registers inserted.

In the first fetch stage, we moveed the adder and multiplexer from execute stage with inputs PCE, ImmExtE, ALUout from datapath since they are combinational logic. This indicates whether the next instruction is branched, jumped or returned.

<img width="400" alt="Screenshot 2022-12-13 1" src="https://user-images.githubusercontent.com/69693952/207877364-756c3478-1979-444a-872e-34bfd6e2bed4.png">

We also have slight changes on control path. Rather than implementing AND, OR gates, we have combined branch and jump select inside the control unit with an EQ input to a single PCsrc output. PCsrc then is used to indicate the next Program address. A seperated jalrsel is added in the control unit which go along with the control path and is used in execute stage to choose PCE + ImmExtE if it is jalr instruction.

<img width="800" alt="Screenshot 2022-12-13 2" src="https://user-images.githubusercontent.com/69693952/207880674-1e6c49e6-68e9-418d-b78b-9486eb7fdd6b.png">

We have noticed that we need to change the posedge clk to negedge while writing register file. This is because in order to make it efficient we do not want to add another pipeline register with register file and we can simply write data at negative clock edge.

<img width="200" alt="Screenshot 2022-12-13 3" src="https://user-images.githubusercontent.com/69693952/207884431-a861f3b0-1ae1-4e30-a5b4-98f30428d540.png">

There was a change in Write back stage multiplexer as well. Our ResultSrc was only one bit originally therefore we tried to implement two multiplexers with one bit selects: jalsel and Resultsrc as following image.

<img width="550" alt="image" src="https://user-images.githubusercontent.com/69693952/207888024-d0452559-32c9-47a6-abe1-60bc14ae994a.png">

There were no problematic errors when we test the pipeline implementation, nearly all of them are repeated errors which were mentioned above.

*Hazard*:

To avoid pipelining hazard, instead of adding hazard unit, we chose to add NOP instructions to ensure that register values have already be written back to register file, and the next instruction has been decided (in **Branch** situation). This is shown in detail in **Machine Code Explaination** previously.

## Pipelining Debugging and Combining with Reference Code - Riya and Bhavya 

Final Cpu Diagram:

<img width="615" alt="Screenshot 2022-12-14 at 13 35 47" src="https://user-images.githubusercontent.com/115703122/207609285-6f8e4b49-bb37-4e66-ad20-fb92056c159e.png">

<img width="286" alt="Screenshot 2022-12-14 at 13 36 04" src="https://user-images.githubusercontent.com/115703122/207609362-1d8a8493-8773-4a83-9381-67c95edb2343.png">



