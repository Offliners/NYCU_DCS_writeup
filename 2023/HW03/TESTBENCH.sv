`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
`include "TL.sv"
`elsif GATE
`include "./Netlist/TL_SYN.v"
`endif



module TESTBENCH();



logic clk,rst_n,in_valid;
logic [2:0] car_main_s, car_main_lt, car_side_s, car_side_lt;
logic out_valid;
logic [1:0]light_main, light_side;

initial begin 
  `ifdef RTL
      $dumpfile("TL.vcd");
      $dumpvars;
  `elsif GATE
      $dumpfile("TL_SYN.vcd");
	    $sdf_annotate("./Netlist/TL_SYN.sdf",I_TL);
	    $dumpvars;
  `endif 
end
//================================================================
// parameters & integer
//================================================================



TL I_TL
(
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .car_main_s(car_main_s),
  .car_main_lt(car_main_lt),
  .car_side_s(car_side_s),
  .car_side_lt(car_side_lt),
  .out_valid(out_valid),
  .light_main(light_main),
  .light_side(light_side)
);



PATTERN I_PATTERN
(
  .clk(clk),
  .rst_n(rst_n),
  .in_valid(in_valid),
  .car_main_s(car_main_s),
  .car_main_lt(car_main_lt),
  .car_side_s(car_side_s),
  .car_side_lt(car_side_lt),
  .out_valid(out_valid),
  .light_main(light_main),
  .light_side(light_side)
);
endmodule
