Personal Statement

My contribution of this coursework includes pipelining the cpu at fetch and execute stage with commit link: 
eb2c7d1de9ac6c705bdb45827113056738eedf33 <br /> 
8c6548aed01527ae6d3d3cfe8f4b8186ed9ec779

and combing five pipeline stages with debugging with commit link:<br />
5ad83aeb2b7d3fd0c21065431f9e57deb4467392 <br />
7b668ee330b969f5823c1e195f6d5089cc3e9594

constructing assembly code and translating to machine code:<br />
b65d0f3a68fe333876e2048fb727d08bbc6947f3

I worked with Isabel on these sessions during the entire coursework. I have only uploaded the main commit I made to illustrate(The commit link does not fully cover the work I mentioned because I commited one task for multiple times)

All of the detail of how we implement and design the cpu with pictures is in our main readme and it explains how we achieved the tasks and special changes we made. In order to avoid repetition, I will focus on talking about the difficulty we faced and how we fix it, the things we learned and what we could have done if we were doing it again

We have divided components in this way rather than working together on the main cpu and then working on pipelining given that we faced quite a lot of obstacles when we worked on reduce RISC-V. The task was divided into ALU, Control Unit, PC and Testbench with toplevel. The implementation of single part was not hard. However, when everything comes together it makes the person who debugged it very difficult. She can hardly understand the logic behind the code. And the slight difference in naming requires frequent questioning to every group member. As two of us are in Gourp B and the other are in Group A which makes the communication time even less.

On the other hand, we learned quite a lot from the first two weeks. We found out a most efficient way to cooperate. Me and Isabel firstly work on the assembly instruction and found out all the instructions that needs to be added into the ALU. While Riya and Bhavya were completing the CPU and debugging. We started writing readme and also constructing 4 pipeline registers on VS code. Once the other two finished their CPU we start adding four reigister and rewrite the top level modules. Finally there were not many errors and warnings that we have not seen given that we learnt lots of types of errors and bebugging technics during the work on reduce RISV-V.

If we were restarting the coursework, the first thing I would do is to spend some time discussing the structure of the CPU we are making, for example, we might share ideas on how everyone will implement their parts. More importantly, we would draw a diagram as I implement my part all along until I get a completed block diagram with all added multiplexers clarifying the names of all inputs, outputs and interconnecting wires when I finish. I think it is crucial becuase every diagram on the pdf has different wire names but not everyone is looking at one diagram, therefore this approach will help people who work on combining top level modules and debugging.
