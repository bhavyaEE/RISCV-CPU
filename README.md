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

mloop:
   
    slli s0 , s0 , 1  //first left shift s0 by 1 bit
    
    addi a0 , s0 , 1  //then add s0 by 1 and output it as a0
    
    bne  a0 , t1 , mloop  //if a0 does not equal to 11111111, back to mloop
    
    ret  //exit
    
Explaination:

    
Final Machine Code:

0ff00313

004000ef

00000413

00141413

00140513

fe651ce3

00008067

## Implementation

Jump:

Shift:

Data Memory:

##
