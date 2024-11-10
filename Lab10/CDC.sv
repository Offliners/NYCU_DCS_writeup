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


parameter [1:0] IDLE    = 2'd0,
				COMPUTE = 2'd1,
				OUT     = 2'd2;

logic P, Q;
logic next_P, next_Q;
logic CDC_res;
logic mode_buf, next_mode;
logic [3:0] in_a_buf, in_b_buf, next_in_a, next_in_b;
logic [1:0] state, next_state;
logic next_out_valid;
logic [7:0] next_out;

//---------------------------------------------------------------------
//   your design  (Using synchronizer)       
// Example :
//logic P,Q,Y;
//synchronizer x5(.D(P),.Q(Y),.clk(clk_2),.rst_n(rst_n));           
//---------------------------------------------------------------------		
always_ff @(posedge clk_1 or negedge rst_n) begin
	if(!rst_n)
		P <= 1'b0;
	else
		P <= next_P;
end

always_comb begin
	next_P = in_valid ^ P;
end

always_ff @(posedge clk_1 or negedge rst_n) begin
	if(!rst_n) begin
		mode_buf <= 1'b0;
		in_a_buf <= 4'd0;
		in_b_buf <= 4'd0;
	end
	else begin
		mode_buf <= next_mode;
		in_a_buf <= next_in_a;
		in_b_buf <= next_in_b;
	end
end

always_comb begin
	next_mode = (in_valid) ? mode : mode_buf;
	next_in_a = (in_valid) ? in_a : in_a_buf;
	next_in_b = (in_valid) ? in_b : in_b_buf;
end

synchronizer syn(.D(P), .Q(next_Q), .clk(clk_2), .rst_n(rst_n));

always_comb begin
	CDC_res = next_Q ^ Q;
end

always_ff @(posedge clk_2 or negedge rst_n) begin
	if(!rst_n)
		Q <= 1'b0;
	else
		Q <= next_Q;
end

always_ff @(posedge clk_2 or negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next_state;
end

always_comb begin
	case(state)
		default: next_state = IDLE;
		IDLE: begin
			if(CDC_res)
				next_state = COMPUTE;
			else
				next_state = IDLE;
		end
		COMPUTE: next_state = OUT;
		OUT:     next_state = IDLE;
	endcase
end

always_comb begin
	if(state == COMPUTE) begin
		next_out_valid = 1'b1;
		next_out = (mode_buf) ? in_a_buf * in_b_buf : in_a_buf + in_b_buf;
	end
	else begin
		next_out_valid = 1'b0;
		next_out = 8'd0;
	end
end

always_ff @(posedge clk_2 or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'b0;
		out       <= 8'd0;
	end 
	else begin
		out_valid <= next_out_valid;
		out       <= next_out;
	end
end

endmodule