#include "Vcpu.h" //mandatory header files
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env)
{
    int i;   // counts the number of clock cycles to simulate
    int clk; // the module clock signal
    // int lights = 0;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vcpu *top = new Vcpu; // instantiate the counter module as Vcounter which is the name of all generated files this is the DUT (device under testing)
    // init trace dump
    Verilated::traceEverOn(true); // turn on signal tracing and tell Verilator to dump waveform data to counter.vcd
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("cpu.vcd");

    // init Vbuddy

    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("Lab 4: addi");
    vbdSetMode(0);

    // initialize simulation inputs
    top->clk = 0;
    top->rst = 1;
    // run simulation for many clock cycles
    for (i = 0; i < 100; i++)
    { // for loop where simulation happens - i counts clock cycles
        // if(!vbdFlag()) {
        //     continue;
        // }
        // dump vars into VCDfile and toggle clock

        // dump vars into VCDfile and toggle clock
        for (clk = 0; clk < 2; clk++)
        { // for loop to toggle clock and outputs trace for each half of the clock cycle and forces model to evaluate on both edges of clock
            tfp->dump(2 * i + clk);
            top->clk = !top->clk;
            top->eval();
        }

        top->rst = (i < 3);

        // Send Count value to vbuddy
        vbdHex(4, (int(top->a0) >> 12) & 0xF);
        vbdHex(3, (int(top->a0) >> 8) & 0xF);
        vbdHex(2, (int(top->a0) >> 4) & 0xF);
        vbdHex(1, (int(top->a0)) & 0xF);

        vbdBar(top->a0);

        if (Verilated::gotFinish())
            exit(0);
    }
    vbdClose();
    tfp->close();
    exit(0);
}
