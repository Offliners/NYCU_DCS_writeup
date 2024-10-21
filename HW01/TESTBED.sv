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
		$dumpfile("SMJ.vcd");
		$dumpvars;
	`elsif GATE
		$dumpfile("SMJ_SYN.vcd");
		$sdf_annotate("./Netlist/SMJ_SYN.sdf", I_SMJ);
		$dumpvars;
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

