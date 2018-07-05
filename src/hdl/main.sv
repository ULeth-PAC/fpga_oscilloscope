`timescale 1ns / 1ps

/// This is the top module of the design.
///
/// # Ports
///
/// *   [clk_ref] is the reference clock from the onboard crystal.
/// *   [reset] is the synchronous active high reset signal.
/// *   [rx] is the receiving serial line.
/// *   [tx] is the transmitting serial line.
/// *   [digital] is a bus of digital inputs for the logic analyzer.
/// *   [analog_p] is a bus of positive sides of the anlog inputs.
/// *   [analog_n] is a bus of negative sides of the anlog inputs.
module main(
    input logic clk_ref,
    input logic reset,
    input logic rx,
    output logic tx,
    input logic [7:0] digital,
    input logic [1:0] analog_p,
    input logic [1:0] analog_n);

    // TODO Derive clocks using `clk_ref`. `clk_ref` should not be forwarded to
    //      any other modules because a clock coming from a clock management
    //      tile will have higher stability.

    // TODO Connect the rest of everything up

endmodule
