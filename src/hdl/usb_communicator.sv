`timescale 1ns / 1ps

// TODO Docs

/// This module handles all USB communication. It implements a full-duplex
/// communication which can be used to externally control the system and
/// retrieve data.
///
/// # Ports
///
/// *   [clk] is the system clock.
/// *   [reset] is the synchronous active high reset signal.
/// *   [data] is a 32-bit bus of data to be sent over serial.
/// *   [rx] is the receiving serial line.
/// *   [tx] is the transmitting serial line.
/// *   [control] is a 8-bit bus which is the new value for the control signal.
module usb_communicator(
    input logic clk,
    input logic reset,
    input logic [31:0] data,
    input logic rx,
    output logic tx,
    output logic [7:0] control);

    // TODO

endmodule
