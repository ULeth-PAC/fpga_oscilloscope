`timescale 1ns / 1ps

/// This module stores and manages a control register.
///
/// # Ports
///
/// *   [clk] is the system clock.
/// *   [reset] is the synchronous active high reset signal.
/// *   [write] is a signal which on the rising edge causes [write_register] to
///     be latched and written to the control register.
/// *   [write_register] is the value to be written to the control regiater when
///     the [write] signal rises.
/// *   [control] is the current value of the control register.

module control_register(
    input logic clk,
    input logic reset,
    input logic write,
    input logic [7:0] write_register,
    //                 TEMPORARY NAMES    
    output logic [1:0] setting0, 
                       setting1, 
                       setting2, 
                       setting3, 
                       setting4, 
                       setting5, 
                       setting6,
                       setting7 );
              
    logic [7:0] control;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            control  <= '0;
        end else if (write) begin
            control <= write_register;
        end
    end
    
    assign setting0 = control[0];
    assign setting1 = control[1];
    assign setting2 = control[2];
    assign setting3 = control[3];
    assign setting4 = control[4];
    assign setting5 = control[5];
    assign setting6 = control[6];
    assign setting7 = control[7];
    
endmodule
