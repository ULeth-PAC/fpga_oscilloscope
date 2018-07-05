`timescale 1ns / 1ps

module main_tb();

    logic clk = 0;

    always begin
        clk = #5 ~clk;
    end

    // Something can be tested here using this 100MHz clock

endmodule
