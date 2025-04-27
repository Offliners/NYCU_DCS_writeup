module Comb_1(
	// Input signals
	in_num0,
	in_num1,
	in_num2,
	in_num3,
	
	// Output signals
	out_num0,
	out_num1
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_num0, in_num1, in_num2, in_num3;
output logic [4:0] out_num0, out_num1;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [3:0] A, B, C, D;
logic [4:0] AB, CD;

//---------------------------------------------------------------------
//   Your DESIGN                        
//---------------------------------------------------------------------
assign A = ~in_num0 ^ in_num1;
assign B =  in_num1 | in_num3;
assign C =  in_num0 & in_num2;
assign D =  in_num2 ^ in_num3;

assign AB = A + B;
assign CD = C + D;

assign out_num0 = (AB > CD) ? CD : AB;
assign out_num1 = (AB > CD) ? AB : CD;

endmodule