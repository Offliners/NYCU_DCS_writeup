module Seq(
	// Input signals
	clk,
	rst_n,
	in_valid,
	in_data,

	// Output signals
	out_valid,
	out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [3:0] in_data;
output logic out_valid;
output logic out_data;

//---------------------------------------------------------------------
//   REG AND WIRE DECLARATION                         
//---------------------------------------------------------------------
logic [3:0] reg_buf_1, reg_buf_2, next_reg_buf_1, next_reg_buf_2;
logic in_buf_1, in_buf_2;
logic next_out_data, next_out_valid, trigger;

//---------------------------------------------------------------------
//   YOUR DESIGN                        
//---------------------------------------------------------------------
assign trigger = (reg_buf_2 > reg_buf_1 && reg_buf_1 > in_data) || (reg_buf_2 < reg_buf_1 && reg_buf_1 < in_data);
assign next_reg_buf_1 = (in_valid) ? in_data : 4'd0;
assign next_reg_buf_2 = (in_valid) ? reg_buf_1 : 4'd0;
assign next_out_valid = (in_valid && reg_buf_2) ? 1'b1 : 1'b0;
assign next_out_data = (in_valid && reg_buf_2) ? trigger : 1'b0;

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'b0;
		out_data <= 1'b0;
	end
	else begin
		out_valid <= next_out_valid;
		out_data <= next_out_data;
	end
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_buf_1 <= 1'b0;
		in_buf_2 <= 1'b0;
	end
	else begin
		in_buf_1 <= in_valid;
		in_buf_2 <= in_buf_1;
	end
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg_buf_1 <= 4'd0;
		reg_buf_2 <= 4'd0;
	end
	else begin
		reg_buf_1 <= next_reg_buf_1;
		reg_buf_2 <= next_reg_buf_2;
	end
end

endmodule
