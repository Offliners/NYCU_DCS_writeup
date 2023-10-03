module BCD(
  // Input signals
	in_bin,
  // Output signals
	out_hundred,
	out_ten,
	out_unit
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
//Input Ports
input [8:0] in_bin;

//output Ports
output logic [2:0]out_hundred;
output logic [3:0]out_ten;
output logic [3:0]out_unit;


//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------


//---------------------------------------------------------------------
//   Your DESIGN                        
//---------------------------------------------------------------------
assign out_hundred = (in_bin / 100) % 10;
assign out_ten = (in_bin / 10) % 10;
assign out_unit = in_bin % 10;

endmodule