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
/// *   [toggle_on] determines wheather any signals are being transmited over serial 

module control_register(
    input logic clk,
    input logic reset,
    input logic write,
    input logic write_register, 
    output logic toggled_on);
              
    logic control;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            control  <= '0;
            toggled_on <= 0;
        end else if (write) begin
            control <= write_register;
        end
    end
    
    assign toggled_on = control;
    
endmodule
