`timescale 1ns/1ps

`include "PATTERN.sv"
`ifdef RTL
	`include "CT.sv"
`elsif GATE
	`include "CT_SYN.v"
`endif

module TESTBENCH();

logic [3:0] in_n0, in_n1, in_n2, in_n3, in_n4, in_n5;
logic [4:0] opcode;
logic [8:0] out_n;

initial begin
	`ifdef RTL
		$fsdbDumpfile("CT.fsdb");
		$fsdbDumpvars(0,"+mda");
	`elsif GATE
		$fsdbDumpfile("CT_SYN.fsdb");
		$sdf_annotate("CT_SYN.sdf", I_CT);
		$fsdbDumpvars(0,"+mda");
	`endif
end

CT I_CT
(
	.opcode(opcode),
	.in_n0(in_n0),
	.in_n1(in_n1),
	.in_n2(in_n2),
	.in_n3(in_n3),
	.in_n4(in_n4),
	.in_n5(in_n5),
	.out_n(out_n)
);

PATTERN I_PATTERN
(
	.opcode(opcode),
	.in_n0(in_n0),
	.in_n1(in_n1),
	.in_n2(in_n2),
	.in_n3(in_n3),
	.in_n4(in_n4),
	.in_n5(in_n5),
	.out_n(out_n)
);
endmodule
