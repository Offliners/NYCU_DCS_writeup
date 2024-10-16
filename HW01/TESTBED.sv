`timescale 1ns/1ps

`include "PATTERN.sv"
`ifdef RTL
	`include "SMJ.sv"
`elsif GATE
	`include "./Netlist/SMJ_SYN.v"
`endif

module TESTBENCH();

logic [5:0] hand_n0, hand_n1, hand_n2, hand_n3, hand_n4;
logic [1:0] out_data;

initial begin
	`ifdef RTL
		$dumpfile("SMJ.fsdb");
		$dumpvars(1, I_SMJ);
	`elsif GATE
		$dumpfile("SMJ_SYN.fsdb");
		$sdf_annotate("SMJ_SYN.sdf", I_SMJ);
		$dumpvars(1, I_SMJ);
	`endif
end

SMJ I_SMJ
(
    .hand_n0(hand_n0),
    .hand_n1(hand_n1),
    .hand_n2(hand_n2),
    .hand_n3(hand_n3),
    .hand_n4(hand_n4),
    .out_data(out_data)
);

PATTERN I_PATTERN
(
    .hand_n0(hand_n0),
    .hand_n1(hand_n1),
    .hand_n2(hand_n2),
    .hand_n3(hand_n3),
    .hand_n4(hand_n4),
    .out_data(out_data)
);
endmodule

