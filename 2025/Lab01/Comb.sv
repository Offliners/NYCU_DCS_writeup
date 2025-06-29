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
input [6:0] in_num0, in_num1, in_num2, in_num3;
output logic [7:0] out_num0, out_num1;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [6:0] A, B, C, D;
logic [6:0] AB_max, AB_min, CD_max, CD_min;
logic [7:0] E, F;

//---------------------------------------------------------------------
//   Your DESIGN                        
//---------------------------------------------------------------------
assign A = ~in_num0 ^ in_num1;
assign B =  in_num1 | in_num3;
assign C =  in_num0 & in_num2;
assign D =  in_num2 ^ in_num3;

assign AB_max = (A > B) ? A : B;
assign AB_min = (A < B) ? A : B;
assign CD_max = (C > D) ? C : D;
assign CD_min = (C < D) ? C : D;

assign E = AB_max + CD_max;
assign F = AB_min + CD_min;

assign out_num0 = E;
assign out_num1 = {F[7], F[7:1] ^ F[6:0]};

endmodule