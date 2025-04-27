module Fpc(
    // input signals
    clk,
    rst_n,
    in_valid,
    in_a,
    in_b,
    mode,

    // output signals
    out_valid,
    out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid, mode;
input [15:0] in_a, in_b;
output logic out_valid;
output logic [15:0] out;

//---------------------------------------------------------------------
//   REG AND WIRE DECLARATION                         
//---------------------------------------------------------------------
parameter [1:0] IDLE   = 2'd0,
                ADD    = 2'd1,
                MUL    = 2'd2,
                OUTPUT = 2'd3;

logic [1:0] state, next_state;
logic [15:0] next_in_a, next_in_b, in_a_buf, in_b_buf;
logic [15:0] big_num, small_num;
logic signed [8:0] num1, num2;
logic signed [9:0] sum;
logic [15:0] next_out;
logic [15:0] mul_buf;
logic next_out_valid;

//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin
    next_in_a = in_a_buf;
    next_in_b = in_b_buf;
    case(state)
        default : begin 
            next_out_valid = 1'b0;
            next_state     = IDLE;
        end
        IDLE : begin
            next_out_valid = 1'b0;
            if(in_valid) begin
                next_in_a = in_a;
                next_in_b = in_b;
                next_state = (mode) ? MUL : ADD;
            end
            else
                next_state = IDLE;
        end
        ADD : begin
            next_out_valid = 1'b1;
            next_state     = OUTPUT;
        end
        MUL : begin
            next_out_valid = 1'b1;
            next_state     = OUTPUT;
        end
        OUTPUT : begin
            next_out_valid = 1'b0;
            next_state     = IDLE;
        end
    endcase
end

always_ff @(posedge clk) begin
    in_a_buf <= next_in_a;
    in_b_buf <= next_in_b;
end

always_comb begin
    if(state == ADD) begin
        if(in_a_buf[14:7] > in_b_buf[14:7]) begin
            big_num   = in_a_buf;
            small_num = in_b_buf;
        end 
        else begin
            big_num   = in_b_buf;
            small_num = in_a_buf;
        end

        num1 = {1'b1, big_num[6:0]};
        num2 = {1'b1, small_num[6:0]} >> (big_num[14:7] - small_num[14:7]);

        if(big_num[15])   num1 = ~num1 + 1'b1;
        if(small_num[15]) num2 = ~num2 + 1'b1;
        
        sum = num1 + num2;
        if(sum[9]) begin
            next_out[15] = 1;
            sum = ~sum + 1'b1;
        end
        else
            next_out[15] = 0;

        if(sum[8]) begin
            next_out[14:7] = big_num[14:7] + 1;
            next_out[6:0] = sum[7:1];
        end
        else if(sum[7]) begin
            next_out[14:7] = big_num[14:7] + 0;
            next_out[6:0] = sum[6:0];
        end
        else if(sum[6]) begin
            next_out[14:7] = big_num[14:7] - 1;
            next_out[6:0] = {sum[5:0], 1'b0};
        end
        else if(sum[5]) begin
            next_out[14:7] = big_num[14:7] - 2;
            next_out[6:0] = {sum[4:0], 2'b0};
        end
        else if(sum[4]) begin
            next_out[14:7] = big_num[14:7] - 3;
            next_out[6:0] = {sum[3:0], 3'b0};
        end
        else if(sum[3]) begin
            next_out[14:7] = big_num[14:7] - 4;
            next_out[6:0] = {sum[2:0], 4'b0};
        end
        else if(sum[2]) begin
            next_out[14:7] = big_num[14:7] - 5;
            next_out[6:0] = {sum[1:0], 5'b0};
        end
        else if(sum[1]) begin
            next_out[14:7] = big_num[14:7] - 6;
            next_out[6:0] = {sum[1:0], 6'b0};
        end
        else begin
            next_out[14:7] = big_num[14:7] - 7;
            next_out[6:0] = {sum[0], 7'b0};
        end
    end
    else if(state == MUL) begin
        next_out[15] = in_a_buf[15] ^ in_b_buf[15];
        mul_buf = {1'b1, in_a_buf[6:0]} * {1'b1, in_b_buf[6:0]};
        if(mul_buf[15]) begin
            next_out[14:7] = in_a_buf[14:7] + in_b_buf[14:7] + 1 - 127;
            next_out[6:0]  = mul_buf[14:8];
        end 
        else begin
            next_out[14:7] = in_a_buf[14:7] + in_b_buf[14:7] - 127;
            next_out[6:0]  = mul_buf[13:7];
        end
    end
    else
        next_out = 16'd0;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 16'd0;
        out_valid <= 1'b0;
    end
    else begin
        out <= next_out;
        out_valid <= next_out_valid;
    end
end

endmodule