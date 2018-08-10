`timescale 1ns / 1ps

`define REG_UA (7'h1C)
`define REG_UB (7'h1D)

/// This module controls the on-chip ADC and monitors the incoming digital
/// lines. The module is responsible for sampling the data at a reasonable rate.
///
/// # Ports
///
/// *   [clk] is the system clock.
/// *   [reset] is the synchronous active high reset signal.
/// *   [analog_p] is a bus of positive sides of the anlog inputs.
/// *   [analog_n] is a bus of negative sides of the anlog inputs.
/// *   [analog_out] is a bus of sampled 12-bit ADC values on the analog
///     channels. This only valid while [ready] is high.
/// *   [ready] indicates that the analog values have been sampled
///     and written to [analog_out]. The [ready] signal is
///     only held high for one clock cycle, so the must be used on the rising edge of [ready].

module signal_reader(

    input logic clk,
    input logic reset,
    input analog0_p, analog0_n, analog1_p, analog1_n,
    output logic ready,
    output logic [1:0][11:0] analog_out
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
  .dclk_in(clk),          // input wire dclk_in
  .reset_in(reset),        // input wire reset_in
  .vp_in(1'b0),              // input wire vp_in
  .vn_in(1'b0),              // input wire vn_in
  .vauxp4(analog0_p),            // input wire vauxp4
  .vauxn4(analog0_n),            // input wire vauxn4
  .vauxp5(analog1_p),            // input wire vauxp5
  .vauxn5(analog1_n),            // input wire vauxn5
  .channel_out(channel),  // output wire [4 : 0] channel_out
  .eoc_out(eoc),          // output wire eoc_out
  .alarm_out(/* Unused */),      // output wire alarm_out
  .eos_out(eos),          // output wire eos_out
  .busy_out(busy)        // output wire busy_out
);

assign daddr [6:5] = '0;
assign daddr [4:0] = channel [4:0];
assign den = eoc;
assign di = '0;
assign dwe = drdy;

logic [11:0] ua_code;
logic [11:0] ub_code;

logic [4:0] prev_channel;

always_ff @ (posedge clk) begin
    if(reset) begin
        ua_code <= '0;
        ub_code <= '0;
    end 
    else if (eoc) begin
        prev_channel <= channel;
        case (prev_channel)
            `REG_UA: ua_code <= do_out[15:4];
            `REG_UB: ub_code <= do_out[15:4];
        endcase
    end
end

//Writes stored ouput when eos is high  in order for the values to be updated at the same time.
always_ff @ (posedge clk) begin
    if (reset) begin
        ready <= 0;
        analog_out <= '0;  
    end else if (eos) begin
        ready <=  1;
        analog_out [0][11:0] <= ua_code;
        analog_out [1][11:0] <= ub_code;
    end else begin
    ready <= 0;
    end
end

endmodule
