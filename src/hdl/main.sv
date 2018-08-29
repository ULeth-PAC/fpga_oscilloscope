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
    logic [7:0] settings;
    logic [3:0][7:0] send_data;
    logic write_ready;
    logic send_ready;
    
    assign send_data[0][7:0] = settings;
    assign send_data[1][7:0] = data[7:0];
    assign send_data[2][7:0] = data[15:8];
    assign send_data[3][7:0] = data[23:16];
    
    usb_communicator usb_communicator (
        .clk(clk_ref),
        .reset(reset),
        .data(send_data),
        .rx(rx),
        .tx(tx),
        .control(settings)
    );
    
    control_register control_register(
        .clk(clk_ref),
        .reset(reset),
        .write(write_ready),
        .write_register(settings),
        .setting0(settings[0]),
        .setting1(settings[1]),
        .setting2(settings[2]),
        .setting3(settings[3]),
        .setting4(settings[4]),
        .setting5(settings[5]),
        .setting6(settings[6]),
        .setting7(settings[7])
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
