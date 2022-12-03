# Lab-4 #

## Task 1 ##
- My part of the task included changing the PC counter to either increment by 4 or be the addition of the immOP and PC depending on the PCsrc from the control unit.

<img width="183" alt="Screenshot 2022-11-18 at 14 14 54" src="https://user-images.githubusercontent.com/115703122/202724692-5ec34e20-0deb-4f49-b339-d776053a95d1.png">

- I implemented this using a separate countmux.sv modules which represented the multiplexer switching between the jump and branch 

<img width="404" alt="Screenshot 2022-11-18 at 14 16 52" src="https://user-images.githubusercontent.com/115703122/202725124-5b1a6931-cb4d-41c4-ae95-71b827388c60.png">

- I also created a Reg module so that the new PC instruction is stored within the register and can be implemented in the next clock cycle. 

<img width="356" alt="Screenshot 2022-11-18 at 14 18 55" src="https://user-images.githubusercontent.com/115703122/202725619-91bbf6bd-3da0-42fd-a07f-8672386e3217.png">

-Finally i created a top module called toppc.sv which would combine both modules to take in the current pc and ImmOp and output the new PC depending on PCsrc.

<img width="345" alt="Screenshot 2022-11-18 at 14 19 55" src="https://user-images.githubusercontent.com/115703122/202725825-0e48c253-7150-44a9-b6e8-913eeab03f1f.png">

<img width="281" alt="Screenshot 2022-11-18 at 14 20 07" src="https://user-images.githubusercontent.com/115703122/202725867-8e97cd96-9412-4e2c-a99a-1f9e722216bd.png">

What could have been done differently:
- I could have created the mux within the top level insted of creating a new module.

## Task 2 ##
- My task includes 

<img width="483" alt="image" src="https://user-images.githubusercontent.com/69693952/203307667-b80a3274-2c20-43a5-8693-e9df571463fb.png">


## Task 3 



## Task 4 ##


## Challenge ## 
Hex code for lw instruction: 0005a503
replace in line 7 of Lab4.mem file


