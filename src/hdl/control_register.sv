`timescale 1ns / 1ps
`include "fixed_point.svh"
`define REG_UA (7'h1C)
`define REG_UB (7'h1D)

/// This module stores and manages a control register.
///
/// # Ports
///
///    [std] standard module interface.
///    [ready] asserted for one clk cycle when conversion sequence is completed
///    [tp] two phase signals being sampled
///    [vaux] auxiliary analog inputs.
module control_register(

    IStd.in std,
    IVaux.in vaux,
    output logic ready,
    ITwoPhase.out tp
);
    logic [6:0] daddr;
    logic den;
    logic [15:0] di;
    logic dwe;
    
    logic busy;
    logic [4:0] channel;
    logic [15:0] do_out;
    logic drdy;
    logic eoc;
    logic eos;
    
// Instantiation of the ADc
xadc_wiz_0 xadc_wiz (
  .di_in(di),              // input wire [15 : 0] di_in
  .daddr_in(daddr),        // input wire [6 : 0] daddr_in
  .den_in(den),            // input wire den_in
  .dwe_in(dwe),            // input wire dwe_in
  .drdy_out(drdy),        // output wire drdy_out
  .do_out(do_out),            // output wire [15 : 0] do_out
  .dclk_in(std.clk),          // input wire dclk_in
  .reset_in(std.reset),        // input wire reset_in
  .vp_in(1'b0),              // input wire vp_in
  .vn_in(1'b0),              // input wire vn_in
  .vauxp4(vaux.p4),            // input wire vauxp4
  .vauxn4(vaux.n4),            // input wire vauxn4
  .vauxp5(vaux.p5),            // input wire vauxp5
  .vauxn5(vaux.n5),            // input wire vauxn5
  .channel_out(channel),  // output wire [4 : 0] channel_out
  .eoc_out(eoc),          // output wire eoc_out
  .alarm_out(/* Unused */),      // output wire alarm_out
  .eos_out(eos),          // output wire eos_out
  .busy_out(busy)        // output wire busy_out
);

assign daddr [6:5] = '0;
assign daddr [4:0] = channel [4:0];
assign den =eoc;
assign di = '0;
assign dwe = drdy;

logic [11:0] ua_code;
logic [11:0] ub_code;

logic [4:0] prev_channel;

always_ff @ (posedge std.clk) begin
    if(std.reset) begin
        ua_code <= '0;
        ub_code <= '0;
        prev_channel <= '0;
    end 
    else if (eoc) begin
        prev_channel <= channel;
        case (prev_channel)
            `REG_UA: ua_code <= do_out[15:4];
            `REG_UB: ub_code <= do_out[15:4];
        endcase
    end
end

logic ready_one_cycle;

//Writes stored ouput when eos is high  in order for the values to be updated at the same time.
always_ff @ (posedge atd.clk) begin
    if (std.reset) begin
        ready_one_cycle <= 0;
        tp.ua <= `FIX2420_invalid;
        tp.ub <= `FIX2420_invalid;
    end else if (eos) begin
        ready_one_cycle <=  1;
        tp.ua.num [23:20] <= {4{ua_code[11]}};
        tp.ua.num [19:8] <= ua_code;
        tp.ua.valid <= 1;
        tp.ub.num [23:20] <= {4{ua_code[11]}};
        tp.ub.num [19:8] <= ub_code;
        tp.ub.valid <= 1;
    end else begin
    ready_one_cycle <= 0;
    end
end

// hold ready signal high for 2 std.clk in order to be read by a clock at half the speed
hold #(.CYCLES(2)) hold_ready(.std(std), .a(ready_one_cycle), .high(ready));

endmodule
