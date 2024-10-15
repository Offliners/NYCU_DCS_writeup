`timescale 1ns/1ps
`include "PATTERN.sv"

`ifdef RTL
`include "Counter.sv"
`elsif GATE
`include "./Netlist/Counter_SYN.v"
`endif

module TESTBED();

logic clk, rst_n;
logic clk2;

initial begin
  `ifdef RTL
    $dumpfile("Counter.vcd");	
	  $dumpvars(1, I_Counter);
  `elsif GATE
    $dumpfile("Counter_SYN.vcd");
	  $sdf_annotate("Counter_SYN.sdf", I_Counter);
	  $dumpvars();
  `endif
end

Counter I_Counter(
  .clk(clk),
  .clk2(clk2),
  .rst_n(rst_n)
);

PATTERN I_PATTERN(
  .clk(clk),
  .clk2(clk2),
  .rst_n(rst_n)
);

endmodule