`timescale 1ns/1ps
`include "PATTERN.sv"

`ifdef RTL
`include "CDC.sv"
`elsif GATE
`include "./Netlist/CDC_SYN.v"
`endif

module TESTBED();


wire	clk_1,clk_2,rst_n,in_valid;
wire	[3:0] in_a,in_b;
wire 	mode;
wire	out_valid;
wire 	[7:0]out;

initial begin
  `ifdef RTL
    $dumpfile("CDC.vcd");
	$dumpvars;
  `elsif GATE
    $dumpfile("CDC_SYN.vcd");
	//$sdf_annotate("CDC_SYN.sdf",I_CDC);  
	$sdf_annotate("./Netlist/CDC_SYN_pt.sdf",I_CDC,,,"maximum"); 
	$dumpvars;
  `endif
end

CDC I_CDC
(
  // Input signals
	.clk_1(clk_1),
	.clk_2(clk_2),
	.in_valid(in_valid),
	.mode(mode),
	.rst_n(rst_n),
	.in_a(in_a),
	.in_b(in_b),
  // Output signals
	.out_valid(out_valid),
	.out(out)
);


PATTERN I_PATTERN
(
   // Input signals
	.clk_1(clk_1),
	.clk_2(clk_2),
	.in_valid(in_valid),
	.mode(mode),
	.rst_n(rst_n),
	.in_a(in_a),
	.in_b(in_b),
  // Output signals
	.out_valid(out_valid),
	.out(out)
);

endmodule