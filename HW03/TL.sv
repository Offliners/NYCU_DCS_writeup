module TL(
  // Input signals
  clk,
  rst_n,
  in_valid,
  car_main_s,
  car_main_lt,
  car_side_s,
  car_side_lt,
  // Output signals
  out_valid,
  light_main,
  light_side
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [2:0] car_main_s, car_main_lt, car_side_s, car_side_lt; 
output logic out_valid;
output logic [1:0]light_main, light_side;



endmodule
