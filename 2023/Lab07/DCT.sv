module DCT(
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
input        clk, rst_n, in_valid;
input signed [7:0]in_data;
output logic out_valid;
output logic signed[9:0]out_data;


//---------------------------------------------------------------------
//   REG AND WIRE DECLARATION                         
//---------------------------------------------------------------------
//finish your declaration
integer i, j, m, n;
parameter [2:0] IDLE   = 3'd0, 
				INPUT  = 3'd1, 
				MUL1   = 3'd2, 
				MUL2   = 3'd3, 
				OUTPUT = 3'd4;
logic signed [7:0] dctmtx    [0:3][0:3];
logic signed [7:0] inbuffer  [0:3][0:3];
logic signed [9:0] tmpbuffer [0:3][0:3];
logic signed [9:0] outbuffer [0:3][0:3];
logic signed [9:0] buffer_next;
logic signed [31:0] mac [0:3];
logic [3:0] input_cnt, output_cnt;
logic [3:0] mul_cnt;
logic [2:0] state, next_state;


//---------------------------------------------------------------------
//   YOUR DESIGN                         
//---------------------------------------------------------------------
assign dctmtx[0][0] = 8'b01000000;
assign dctmtx[0][1] = 8'b01000000;
assign dctmtx[0][2] = 8'b01000000;
assign dctmtx[0][3] = 8'b01000000;
assign dctmtx[1][0] = 8'b01010011;
assign dctmtx[1][1] = 8'b00100010;
assign dctmtx[1][2] = 8'b11011110;
assign dctmtx[1][3] = 8'b10101101;
assign dctmtx[2][0] = 8'b01000000;
assign dctmtx[2][1] = 8'b11000000;
assign dctmtx[2][2] = 8'b11000000;
assign dctmtx[2][3] = 8'b01000000;
assign dctmtx[3][0] = 8'b00100010;
assign dctmtx[3][1] = 8'b10101101;
assign dctmtx[3][2] = 8'b01010011;
assign dctmtx[3][3] = 8'b11011110;

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= next_state;
end

always_comb begin
	case(state)
		default: 
			next_state = IDLE;
		IDLE: 
			next_state = (in_valid) ? INPUT : IDLE;
		INPUT:
			next_state = (input_cnt == 4'd15) ?  MUL1 : INPUT;
		MUL1:
			next_state = (mul_cnt == 4'd15) ? MUL2 : MUL1;
		MUL2:
			next_state = (mul_cnt == 4'd15) ? OUTPUT : MUL2;
		OUTPUT: 
			next_state = (output_cnt == 4'd15) ? IDLE : OUTPUT;
	endcase
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		input_cnt <= 4'd0;
	else if(in_valid)
		input_cnt <= input_cnt + 4'd1;
	else
		input_cnt <= 4'd0;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0; i < 4; i = i + 1)
			for(j = 0; j < 4; j = j + 1)
				inbuffer[i][j] <= 8'd0;
	end
	else if(in_valid)
		inbuffer[input_cnt[3:2]][input_cnt[1:0]] <= in_data;
	else
		inbuffer <= inbuffer;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'b0;
		out_data  <= 10'd0;
	end
	else if(state == OUTPUT) begin
		out_valid <= 1'b1;
		out_data  <= outbuffer[output_cnt[3:2]][output_cnt[1:0]];
	end
	else begin
		out_valid <= 1'b0;
		out_data  <= 10'd0;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		output_cnt <= 4'd0;
	else if(state == OUTPUT)
		output_cnt <= output_cnt + 4'd1;
	else
		output_cnt <= 4'd0;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(m = 0; m < 4; m = m + 1) begin
			for(n = 0; n < 4; n = n + 1) begin
				tmpbuffer[m][n] <= 10'd0;
				outbuffer[m][n] <= 10'd0;
			end
		end
	end
	else begin
		if(state == MUL1)
			tmpbuffer[mul_cnt[3:2]][mul_cnt[1:0]] <= buffer_next;
		else if(state == MUL2)
			outbuffer[mul_cnt[3:2]][mul_cnt[1:0]] <= buffer_next;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		mul_cnt <= 4'd0;
	else if(state == MUL1 || state == MUL2)
		mul_cnt <= mul_cnt + 4'd1;
	else
		mul_cnt <= 4'd0;
end

always_comb begin
	if(state == MUL1) begin
		mac[0] = dctmtx[mul_cnt[3:2]][0] * inbuffer[0][mul_cnt[1:0]];
		mac[1] = dctmtx[mul_cnt[3:2]][1] * inbuffer[1][mul_cnt[1:0]];
		mac[2] = dctmtx[mul_cnt[3:2]][2] * inbuffer[2][mul_cnt[1:0]];
		mac[3] = dctmtx[mul_cnt[3:2]][3] * inbuffer[3][mul_cnt[1:0]];
		buffer_next = (mac[0] + mac[1] + mac[2] + mac[3]) / 128;
	end
	else if(state == MUL2) begin
		mac[0] = tmpbuffer[mul_cnt[3:2]][0] * dctmtx[mul_cnt[1:0]][0];
		mac[1] = tmpbuffer[mul_cnt[3:2]][1] * dctmtx[mul_cnt[1:0]][1];
		mac[2] = tmpbuffer[mul_cnt[3:2]][2] * dctmtx[mul_cnt[1:0]][2];
		mac[3] = tmpbuffer[mul_cnt[3:2]][3] * dctmtx[mul_cnt[1:0]][3];
		buffer_next = (mac[0] + mac[1] + mac[2] + mac[3]) / 128;
	end
	else
		buffer_next = 0;
end

endmodule