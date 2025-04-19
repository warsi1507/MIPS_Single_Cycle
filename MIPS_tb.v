`timescale 1ns / 1ps

module MIPS_tb;

    // Inputs
    reg clk;
    reg reset;

    // Output
    wire done;

    // Instantiate the Unit Under Test (UUT)
    MIPS_TOP uut (
        .clk(clk),
        .reset(reset),
        .done(done)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset for some time
        #20;
        reset = 0;

        // Wait for 'done' to go high
        wait(done);

        // Allow a few more cycles after done
        #20;

        $finish;
    end

    // Optional: Dump waveform and monitor signals
    initial begin
        $display("Starting MIPS simulation...");
        $monitor("Time = %0t | Reset = %b | Done = %b", $time, reset, done);

        #5000;
        $display("Simulation ended due to timeout");
        $finish;
    end

endmodule
