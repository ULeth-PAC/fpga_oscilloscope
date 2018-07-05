`timescale 1ns / 1ps

/// This module controls the on-chip ADC and monitors the incoming digital
/// lines. The module is responsible for sampling the data at a reasonable rate.
///
/// # Ports
///
/// *   [clk] is the system clock.
/// *   [reset] is the synchronous active high reset signal.
/// *   [digital] is the digital bus to be sampled for the logic analyzer.
/// *   [analog_p] is a bus of positive sides of the anlog inputs.
/// *   [analog_n] is a bus of negative sides of the anlog inputs.
/// *   [analog_out] is a bus of sampled 12-bit ADC values on the analog
///     channels. This only valid while [ready] is high.
/// *   [digital_out] is a bus of sampled values on the digital lines. This only
///     valid while [ready] is high.
/// *   [ready] indicates that the analog and digital values have been sampled
///     and written to [analog_out] and [digital_out]. The [ready] signal is
///     only held high for one clock cycle, so the [analog_out] and
///     [digital_out] must be used on the rising edge of [ready].
module signal_reader(
    input logic clk,
    input logic reset,
    input logic [7:0] digital,
    input logic [1:0] analog_p,
    input logic [1:0] analog_n,
    output logic [1:0][11:0] analog_out,
    output logic [7:0] digital_out,
    output logic ready);

    // TODO

endmodule
