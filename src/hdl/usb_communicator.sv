`timescale 1ns / 1ps

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
/// *   [control] is the value that determines wheather data will be transmitted.
module usb_communicator(
    input logic clk,
    input logic reset,
    input logic toggled_on,
    input logic [23:0] data,
    input logic rx,
    output logic tx,
    output logic control);

    localparam int DIVIDER = 4;
    logic recieve_ready;
    
    
    // recieving data over serial
    uart_receive #(.DIVIDER(DIVIDER)) uart_receive(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(control),
        .ready(recieve_ready)
    );
    
    // data being sent over serial
    logic [3:0][7:0] send_data;
    
    // Assigning values to the first two bits in 4 bytes that will hold the data, 
    // first being used to determine the start of a set of data obtained from the two analog channels,
    // and the second being used as a parity bit to detect any abnormalities in the transmited signal using odd parity.
    // The other 6 bits in each byte holds the data obtained from the two analog signals
    always_ff @(posedge clk) begin
        if (reset) begin
            send_data <= '0;
            tx <= 0;
            control <= 0;
            recieve_ready <= 0;
        end else if ( !toggled_on) begin
            recieve_ready <= 0;
        end else begin
                // upper bits of channel 2
            send_data[3][7] <= 0;
            send_data[3][6] <= ~^(data[23:18]);
            send_data[3][5:0] <= data[23:18];
            
                // lower bits of channel 2
            send_data[2][7] <= 1;
            send_data[2][6] <= ~^(data[17:12]);
            send_data[2][5:0] <= data[17:12];
            
                // upper bits of channel 1    
            send_data[1][7] <= 1;
            send_data[1][6] <= ~^(data[11:6]);
            send_data[1][5:0] <= data[11:6];
            
                // lower bits of channel 1    
            send_data[0][7] <= 1;
            send_data[0][6] <= ~^(data[5:0]);
            send_data[0][5:0] <= data[5:0];
        end
    end
    // sending data over serial unless setting is set to 0
    uart_transmit #(.DIVIDER(DIVIDER)) uart_transmit(
        .clk(clk),
        .reset(reset),
        .data(send_data),
        .send(recieve_ready),
        .ready(/* Not Connected */),
        .tx(tx)
    );
endmodule
