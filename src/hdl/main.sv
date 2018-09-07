`timescale 1ns / 1ps

/// This is the top module of the design.
///
/// # Ports
///
/// *   [clk_ref] is the reference clock from the onboard crystal.
/// *   [reset] is the synchronous active high reset signal.
/// *   [rx] is the receiving serial line.
/// *   [tx] is the transmitting serial line.
/// *   [analog_p] is a bus of positive sides of the anlog inputs.
/// *   [analog_n] is a bus of negative sides of the anlog inputs.
module main(
    input logic clk_ref,
    input logic reset,
    input logic rx,
    output logic tx,
    input logic [1:0] analog_p,
    input logic [1:0] analog_n);
    
    logic [23:0] data;
    logic settings;
    logic toggled_on;
    logic write_ready;
    
    usb_communicator usb_communicator (
        .clk(clk_ref),
        .reset(reset),
        .toggled_on(toggled_on),
        .data(data),
        .rx(rx),
        .tx(tx),
        .control(settings)
    );
    
    control_register control_register(
        .clk(clk_ref),
        .reset(reset),
        .write(write_ready),
        .write_register(settings),
        .toggled_on(toggled_on)
    );
    
    signal_reader signal_reader(
        .clk(clk_ref),
        .reset(reset),
        .analog_p(analog_p),
        .analog_n(analog_n),
        .ready(write_ready),
        .analog_out(data)
    );
    
endmodule
