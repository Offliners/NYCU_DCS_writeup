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
logic in_buf1, in_buf2, trigger, out_data_next, out_valid_next;
logic [3:0] reg1, reg2, reg1_next, reg2_next;

//---------------------------------------------------------------------
//   YOUR DESIGN                        
//---------------------------------------------------------------------
assign trigger = ((reg2 > reg1) && (reg1 > in_data)) || ((reg2 < reg1) && (reg1 < in_data));
assign reg1_next = (in_valid) ? in_data : 0;
assign reg2_next = (in_valid) ? reg1 : 0;
assign out_data_next = (in_valid && in_buf2) ? trigger : 0;
assign out_valid_next = (in_valid && in_buf2) ? 1 : 0;

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		in_buf1 <= 0;
		in_buf2 <= 0;
	end
	else begin
		in_buf1 <= in_valid;
		in_buf2 <= in_buf1;
	end
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		reg1 <= 0;
		reg2 <= 0;
	end
	else begin
		reg1 <= reg1_next;
		reg2 <= reg2_next;
	end
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		out_valid <= 0;
	else
		out_valid <= out_valid_next;
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		out_data <= 0;
	else
		out_data <= out_data_next;
end

endmodule
