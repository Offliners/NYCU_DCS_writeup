module Fpc(
// input signals
clk,
rst_n,
in_valid,
in_a,
in_b,
mode,
// output signals
out_valid,
out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid, mode;
input [15:0] in_a, in_b;
output logic out_valid;
output logic [15:0] out;

//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------



endmodule

