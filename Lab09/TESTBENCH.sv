`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
	`include "P_MUL.sv"
`elsif GATE
	`include "./Netlist/P_MUL_SYN.v"
`endif

module TESTBENCH();

logic [46:0] in_1, in_2;
logic [46:0] in_3, in_4;
logic in_valid, rst_n, clk;

logic [95:0] out;
logic out_valid;

initial begin
	`ifdef RTL
		$dumpfile("P_MUL.vcd");
		$dumpvars;
	`elsif GATE
		$dumpfile("P_MUL_SYN.vcd");
		$sdf_annotate("./Netlist/P_MUL_SYN.sdf", I_P_MUL);
		$dumpvars;
	`endif
end

P_MUL I_P_MUL
(
	.in_1(in_1),
	.in_2(in_2),
	.in_3(in_3),
	.in_4(in_4),
	.in_valid(in_valid),
	.rst_n(rst_n),
	.clk(clk),
	.out_valid(out_valid),
	.out(out)
);

PATTERN I_PATTERN
(
	.in_1(in_1),
	.in_2(in_2),
	.in_3(in_3),
	.in_4(in_4),
	.in_valid(in_valid),
	.rst_n(rst_n),
	.clk(clk),
	.out_valid(out_valid),
	.out(out)
);
endmodule
