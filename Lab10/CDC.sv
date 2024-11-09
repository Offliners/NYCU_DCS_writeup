`include "synchronizer.v"
module CDC(
	// Input signals
	clk_1,
	clk_2,
	in_valid,
	rst_n,
	in_a,
	mode,
	in_b,

	//  Output signals
	out_valid,
	out
);
		
input clk_1; 
input clk_2;			
input rst_n;
input in_valid;
input[3:0]in_a,in_b;
input mode;
output logic out_valid;
output logic [7:0]out; 			




//---------------------------------------------------------------------
//   your design  (Using synchronizer)       
// Example :
//logic P,Q,Y;
//synchronizer x5(.D(P),.Q(Y),.clk(clk_2),.rst_n(rst_n));           
//---------------------------------------------------------------------		



		
endmodule