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
    output logic control[7:0]);

    // TODO

endmodule
