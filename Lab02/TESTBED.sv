`timescale 1us/100ns
`include "PATTERN.sv"

`ifdef RTL
`include "Sort.sv"
`elsif GATE
`include "./Netlist/Sort_SYN.v"
`endif


module TESTBED();

logic [5:0] in_num0, in_num1, in_num2, in_num3, in_num4;
logic [5:0] out_num;


initial begin
  `ifdef RTL
    $dumpfile("Sort.vcd");
	$dumpvars;
  `elsif GATE
	$dumpfile("Sort_SYN.vcd");
	$sdf_annotate("Sort_SYN.sdf", I_Sort);
	$dumpvars;
  `endif
end

Sort I_Sort
(
	.in_num0(in_num0),
	.in_num1(in_num1),
	.in_num2(in_num2),
	.in_num3(in_num3),
	.in_num4(in_num4),
	.out_num(out_num)
);

PATTERN I_PATTERN
(
	.in_num0(in_num0),
	.in_num1(in_num1),
	.in_num2(in_num2),
	.in_num3(in_num3),
	.in_num4(in_num4),
	.out_num(out_num)
);

endmodule

