# iac-riscv-cw-11
## Initial Approach

- We began the project by **planning the tasks**, this included understanding the objectives of the task as a team as well as creating and delegating tasks. 
- Once the tasks had been delegated, **machine code** which would implement the f1 light switch was created and checked by other memeber of the team.
- 

## Planning

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

Jump:

Shift:

Data Memory:

##
