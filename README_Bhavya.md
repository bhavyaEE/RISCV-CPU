## Individual account + reflections - Bhavya Sharma

**Reference Program Instructions (LBU + SB) design choices:**

The diagram below outlines how I visualised the memory to be split up into bytes from a word. Once we realised that the only way to implement these instructions was to make the data memory byte addressed, it was quite clear that the specific byte to be addressed would simply be the value of the Immediate + RS1 in the case of an LBU. 

![image](https://user-images.githubusercontent.com/107200668/207979183-85bfd8e8-b6cb-4563-91b3-6078d16bddd5.png)

The main design choices came into play for selecting a word either to be loaded into a register or a word to be stored into memory since the instruction: Imm + RS1 would still give a number which corresponds to a byte. 
Therefore to select a word, 2 possible design choices were considered: 

1.	Start at the byte specified and offset from there by 1,2 and 3 to concatenate consecutive bytes to form a word, i.e. if Imm + Rs1 = 5: 
Corresponding Word: Bytes {5,6,7,8}
2.	Regardless of which byte was selected, the word selected should correspond to the word indicated in the table above; since this matched the previous word addressing format this option was selected.
If Imm + Rs1 = 5:  
Corresponding Word: Bytes {4,5,6,7}
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
