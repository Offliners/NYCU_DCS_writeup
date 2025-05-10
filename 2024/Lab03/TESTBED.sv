`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
	`include "SIPO.sv"
`elsif GATE
	`include "SIPO_SYN.v"
`endif

module TESTBED();

logic clk, rst_n, in_valid;
logic out_valid;

logic s_in;
logic [3:0] p_out; 


initial begin
    `ifdef RTL
	    $fsdbDumpfile("SIPO.fsdb");
	    $fsdbDumpvars(0,"+mda");
    `elsif GATE
	    $fsdbDumpfile("SIPO_SYN.fsdb");
	    $sdf_annotate("SIPO_SYN.sdf", I_SIPO);
	    $fsdbDumpvars(0,"+mda");
    `endif
end


SIPO I_SIPO (
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.s_in(s_in),
	.out_valid(out_valid),
	.p_out(p_out)
);

PATTERN I_PATTERN (
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.s_in(s_in),
	.out_valid(out_valid),
	.p_out(p_out)	
);
endmodule