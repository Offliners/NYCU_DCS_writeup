`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
	`include "IMG_SUB.sv"
`elsif GATE
	`include "IMG_SUB_SYN.v"
`endif

module TESTBED();

logic clk, rst_n ;
logic in_valid ;
logic [3:0] in_image ;
logic out_valid ;
logic [3:0] out_diff ;

initial begin
  `ifdef RTL
		$fsdbDumpfile("IMG_SUB.fsdb");
		$fsdbDumpvars(0,"+mda");
  `elsif GATE
		$fsdbDumpfile("IMG_SUB.fsdb");
		$sdf_annotate("IMG_SUB_SYN.sdf",I_SUB);
		$fsdbDumpvars(0,"+mda");
  `endif 
end

IMG_SUB I_SUB
(
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_image(in_image),
	.out_valid(out_valid),
	.out_diff(out_diff)
);

PATTERN I_PATTERN
(
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_image(in_image),
	.out_valid(out_valid),
	.out_diff(out_diff)
);

endmodule