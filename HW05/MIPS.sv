module MIPS(
    //Input 
    clk,
    rst_n,
    in_valid,
    instruction,
	output_reg,
    //OUTPUT
    out_valid,
    out_1,
	out_2,
	out_3,
	out_4,
	instruction_fail
);

//Input 
input clk;
input rst_n;
input in_valid;
input [31:0] instruction;
input [19:0] output_reg;
//OUTPUT
output logic out_valid, instruction_fail;
output logic [15:0] out_1, out_2, out_3, out_4;





endmodule

