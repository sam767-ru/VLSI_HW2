`timescale 1ns/1ps
`include "FSM.v"   

module FSM_testbench;
    wire fsm_Out_test;
    reg  clk_test, rst_n_test, in_test;
    reg  [1:28] data     = 28'b0100110010100101011011011011; // example input
    reg  [1:28] expected = 28'b1000011100000110001100010001; // example output
    reg  [1:28] actual;
    integer i = 1, k, errors = 0;

    FSM uut (.fsm_Out(fsm_Out_test), .clk(clk_test), .rst_n(rst_n_test), .in(in_test));

    initial begin
        in_test = 0; clk_test = 0; rst_n_test = 0;  // reset on: FSM goes to S0
        #10 rst_n_test = 1;                         // reset off
        forever #5 clk_test = ~clk_test;            // period 10
    end

    always @(posedge clk_test) if (rst_n_test) begin
        #1;                                         
        if (i > 1) actual[i-1] = fsm_Out_test;     
        if (i == 29) begin
            $display("Input:    %b", data);
            $display("Expected: %b", expected);
            $display("Actual:   %b", actual);
            for (k = 1; k <= 28; k = k + 1)
                if (actual[k] !== expected[k]) begin
                    $display("Bit %0d: FAILED (expected %b, got %b)", k, expected[k], actual[k]);
                    errors = errors + 1;
                end
            if (errors == 0) $display("PASSED");
            else             $display("FAILED: %0d mismatches", errors);
            $finish;
        end
        else begin
            in_test <= data[i];
            i <= i + 1;
        end
    end
endmodule