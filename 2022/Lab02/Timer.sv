module Timer(
    // Input signals
    in,
	in_valid,
	rst_n,
	clk,
    // Output signals
    out_valid
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [4:0] in;
input in_valid,	rst_n,	clk;
output logic out_valid;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [4:0] in_reg, cnt_reg;

//---------------------------------------------------------------------
//   Your design                        
//--------------------------------------------------------------------- 
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        in_reg <= 5'd0;
    else
        in_reg <= in_valid ? in : in_reg;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_reg <= 5'd0;
    else if(in_valid)
        cnt_reg <= 5'd0;
    else
        cnt_reg <= in_reg ? cnt_reg + 5'd1 : cnt_reg;
end

always_comb begin
    if(cnt_reg == 5'd0 || in_reg == 5'd0)
        out_valid = 1'b0;
    else if(cnt_reg == in_reg)
        out_valid = 1'b1;
    else
        out_valid = 1'b0;
end


endmodule