module Counter(
	// Input signals
	clk,
	rst_n,
	// Output signals
	clk2
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input        clk, rst_n;
output logic clk2;

//---------------------------------------------------------------------
//   REG AND WIRE DECLARATION                         
//---------------------------------------------------------------------
logic [1:0] count, count_next;
logic clk2_next;

//---------------------------------------------------------------------
//   Counter                         
//---------------------------------------------------------------------
always_comb begin
	if(count == 'd3)
		count_next = 0;
	else
		count_next = count + 1;
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		count <= 1'b0;
	else
		count <= count_next;
end

//---------------------------------------------------------------------
//   Frequency divider                         
//---------------------------------------------------------------------
always_comb begin
	if(count[0] == 1'd0)
		clk2_next = !clk2;
	else
		clk2_next = clk2;
end

always_ff @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		clk2 <= 1'b0;
	else
		clk2 <= clk2_next;
end

endmodule
