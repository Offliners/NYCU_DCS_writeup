`timescale 1ns/1ps

`include "PATTERN.sv"

`ifdef RTL
`include "I2S.sv"
`elsif GATE
`include "./Netlist/I2S_SYN.v"
`endif

module TESTBENCH();

logic clk, rst_n, in_valid, WS, SD;
logic out_valid;

logic [31:0] out_left, out_right; 

initial begin 
	`ifdef RTL
		$dumpfile("I2S.vcd");
		$dumpvars;
	`elsif GATE
		$sdf_annotate("./Netlist/I2S_SYN.sdf",I_I2S);
		$dumpfile("I2S_SYN.vcd");
		$dumpvars;
	`endif
end

I2S I_I2S(
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .WS(WS),
  .SD(SD),

  .out_valid(out_valid),
  .out_left(out_left),
  .out_right(out_right)
);


PATTERN I_PATTERN(   
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .WS(WS),
  .SD(SD),

  .out_valid(out_valid),
  .out_left(out_left),
  .out_right(out_right)
);

endmodule
