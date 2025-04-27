
`timescale 1ns/1ps
`include "pattern.sv"
`include "lab06_2.sv"

module testbench();

logic clk,rst_n;
logic in_valid;
logic [3:0] in_number;
logic [1:0] mode;

logic out_valid;
logic signed [5:0] out_result;

initial begin
  $fsdbDumpfile("lab06_2.fsdb");
	$fsdbDumpvars(0,"+mda");
end

lab06_2 I_lab06_2
(
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .out_valid(out_valid),
  .in_number(in_number),
  .mode(mode),
  .out_result(out_result)
);

pattern I_pattern
(
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .out_valid(out_valid),
  .in_number(in_number),
  .mode(mode),
  .out_result(out_result)
);

endmodule

