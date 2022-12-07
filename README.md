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
    
    JAL  ra , loop  //jump to the loop
    
    
    
    

loop: 
    
    addi s0 , zero, 0  //initialize s0=0
    
    addi zero, zero, 0  //NOP avoiding Data Hazard
    
    addi zero, zero, 0  //NOP

mloop:
   
    slli s0 , s0 , 1  //first left shift s0 by 1 bit
    
    addi zero, zero, 0  //NOP 
    
    addi zero, zero, 0  //NOP
    
    addi a0 , s0 , 1  //then add s0 by 1 and output it as a0
    
    addi zero, zero, 0  //NOP
    
    addi zero, zero, 0  //NOP
    
    bne  a0 , t1 , mloop  //if a0 does not equal to 11111111, back to mloop
    
    addi zero, zero, 0  //NOP avoiding Control Hazard
    
    addi zero, zero, 0  //NOP
    
    ret  //exit and return to the next line after JAL instruction
    
Explaination:

Since we will implement pipeline without hazrd control unit, we will use two NOP instruction when Data and Control Hazard happens. 

    addi s0 , zero, 0
    slli s0 , s0 , 1
    
For example in loop and mloop we repeatedly used s0 in two consecutive lines which means the s0 value has not been written back to register file before we use it again in second line. 

    bne  a0 , t1 , mloop
    ret

Another example of Control Hazard happens when we want to branch to mloop if condition satisfies. However we have not decided whether the next line will be return or mloop when the second instruction is fetched therefore we need another two NOP to delay next line by two cycles.
    
Final Machine Code:

0ff00313

004000ef

00000413

00000013

00000013

00141413

00000013

00000013

00140513

00000013

00000013

fe651ce3

00000013

00000013

00008067

## Implementation

Jump:

Shift:

Data Memory:

##
