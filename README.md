# iac-riscv-cw-11
# Instrcutions
main:               
    
    addi t1 , zero , 0xff  //t1=11111111
    
    JAL  ra , loop  //jump to the loop

loop: 
    
    addi s0 , zero, 0  //initialize s0=0

mloop:
   
    slli s0 , s0 , 1  //first left shift s0 by 1 bit
    
    addi s0 , s0 , 1  //then add s0 by 1
    
    bne  s0 , t1 , mloop  //if s0 does not equal to 11111111, back to mloop
    
    ret  //exit
# Machine Code
0ff00313

004000ef

00000413

00141413

00140413

fe641ce3

00008067
