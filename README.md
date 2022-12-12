# iac-riscv-cw-11
## Initial Approach

- We began the project by **planning the tasks**, this included understanding the objectives of the task as a team as well as creating and delegating tasks. 
- Once the tasks had been delegated, **machine code** which would implement the f1 light switch was created and checked by other memeber of the team.
- After the machine code was created we delegated the tasks of **implementing the machine code**, adding new architecture needed for the machine code. This included planning the additions to the cpu, implementing the changes and then begugging any issues.
- Next, we **implemented the reference code**, this involed adding a load byte and store byte instruction and testing the reference code against our cpu.
- Finally, we piplined the RISC-V cpu and tested our final design. 

## Planning

###Understanding the Project Brief 

<img width="588" alt="Screenshot 2022-12-12 at 16 53 18" src="https://user-images.githubusercontent.com/115703122/207105417-c04ce3ca-88a8-4a5b-9f15-46a6a99fc381.png">

<img width="277" alt="Screenshot 2022-12-12 at 16 53 31" src="https://user-images.githubusercontent.com/115703122/207105457-c1e3dd3a-88f3-4c5f-8582-af2e7824466f.png">

When splitting the tasks we decided to work in pairs for machine code and implementation, then reference and piplining. This ensured that as indivduals we were not making simple mistakes and were constantly being questioned with each decision we made. This is how the tasks were divided:
- Machine Code - Isabel and Ethan
- Implementation of Machine Code - Riya and Bhavya 
- Reference Code implementation - Riya and Bhavya 
- Piplining - Isabel and Ethan

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

### Jump - Bhavya

### Merging Jump and Shift

Final diagram of working F1 cpu:

## Reference Program - Bhavya and Riya

## Piplining - Ethan and Isabel


