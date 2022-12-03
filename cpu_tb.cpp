#include "Vcpu.h"   //mandatory header files
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main (int argc, char **argv, char **env){
    int i; //counts the number of clock cycles to simulate
    int clk; //the module clock signal 

    Verilated:: commandArgs (argc, argv);
    //init top verilog instance
    Vcpu* top = new Vcpu;  //instantiate the counter module as Vcounter which is the name of all generated files this is the DUT (device under testing)
    //init trace dump
    Verilated::traceEverOn (true); //turn on signal tracing and tell Verilator to dump waveform data to counter.vcd
    VerilatedVcdC* tfp = new VerilatedVcdC; 
    top->trace (tfp, 99); 
    tfp->open ("cpu.vcd");
   
    //init Vbuddy

    if (vbdOpen()!= 1) return (-1); 
    vbdHeader ("Lab 4: addi");
    vbdSetMode(0); 


    //initialize simulation inputs
    cpu->clk = 1; 
    cpu->rst = 1;  
    //run simulation for many clock cycles
    for (i=0; i < 300; ){ //for loop where simulation happens - i counts clock cycles
        if(!vbdFlag()) {
            continue;
        }

        //dump vars into VCDfile and toggle clock 
        for (clk = 0; clk < 2; clk++){ //for loop to toggle clock and outputs trace for each half of the clock cycle and forces model to evaluate on both edges of clock 
            tfp->dump (2*i+clk);
            cpu->clk = !cpu->clk; 
            cpu->eval(); 
        }

        if (i > 2) {
            cpu->rst = 0;
        }

        // Send Count value to vbuddy
        vbdHex(4, (int(cpu->a0) >> 16) & 0xF);
        vbdHex(3, (int(cpu->a0) >> 8) & 0xF);
        vbdHex(2, (int(cpu->a0) >> 4) & 0xF);
        vbdHex(1, int(cpu->a0) & 0xF);
        vbdCycle(i+1);
  
        if (Verilated::gotFinish()) exit (0);
        i++;
    }

    vbdClose();
    tfp->close(); 
    exit(0);
}

