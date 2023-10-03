module I2S(
  // Input signals
  clk,
  rst_n,
  in_valid,
  SD,
  WS,
  // Output signals
  out_valid,
  out_left,
  out_right
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input SD, WS;

output logic        out_valid;
output logic [31:0] out_left, out_right;



endmodule