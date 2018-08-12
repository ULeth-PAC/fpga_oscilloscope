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
              
    always_ff @(posedge clk) begin
        if (reset) begin
            setting0 <= 0;
            setting1 <= 0;
            setting2 <= 0;
            setting3 <= 0;
            setting4 <= 0;
            setting5 <= 0;
            setting6 <= 0;
            setting7 <= 0;
        end else if (write) begin
            setting0 <= write_register[0];
            setting1 <= write_register[1];
            setting2 <= write_register[2];
            setting3 <= write_register[3];
            setting4 <= write_register[4];
            setting5 <= write_register[5];
            setting6 <= write_register[6];
            setting7 <= write_register[7];
        end
    end

endmodule
