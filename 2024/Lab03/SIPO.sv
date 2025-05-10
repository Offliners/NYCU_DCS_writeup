module SIPO(
	// input signals
	clk,
	rst_n,
	in_valid,
	s_in,
	
	// output signals
	out_valid,
	p_out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n;
input in_valid;
input s_in;
output logic out_valid;
output logic [3:0] p_out;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic next_out_valid;
logic [3:0] next_p_out;
logic [1:0] counter;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
        out_valid <= 1'b0;
        p_out <= 4'd0;
    end
    else begin
        out_valid <= next_out_valid;
        p_out <= next_p_out;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        counter <= 4'd0;
    else begin
        if(in_valid)
            counter <= counter + 1;
        else
            counter <= counter;
    end
end

assign next_p_out = in_valid ? {p_out[2:0], s_in} : 4'd0;
assign next_out_valid = (counter == 2'd3) ? 1'b1 : 1'b0;

endmodule