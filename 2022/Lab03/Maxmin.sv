module Maxmin(
    // input signals
	in_num,
	in_valid,
	rst_n,
	clk,
	
    // output signals
    out_valid,
	out_max,
	out_min
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [7:0] in_num;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [7:0] out_max, out_min;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic next_out_valid;
logic [7:0] next_out_min, next_out_max;
logic [3:0] counter, next_count;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_min   <= 8'd255;
		out_max   <= 8'd0;
		out_valid <= 1'b0;
	end
	else begin
		out_min   <= next_out_min;
		out_max   <= next_out_max;
		out_valid <= next_out_valid;
	end
end

assign next_out_min = in_valid ? ((in_num < out_min) ? in_num : out_min) : 8'd255;
assign next_out_max = in_valid ? ((in_num > out_max) ? in_num : out_max) : 8'd0;

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		counter <= 4'd0;
	else begin
		counter <= next_count;
	end
end

assign next_count = in_valid ? counter + 4'd1 : 4'd0;
assign next_out_valid = (next_count == 4'd15) ? 1'b1 : 1'b0; 

endmodule