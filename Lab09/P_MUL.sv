module P_MUL(
    // Input signals
	clk,
    rst_n,
    in_1,
    in_2,
    in_3,
    in_4,
    in_valid,
    
    // Output signals
	out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [46:0] in_1, in_2, in_3, in_4;

output logic out_valid;
output logic [95:0] out;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [95:0] next_out;
logic next_out_valid;

logic [47:0] sum_A, sum_B;
logic [47:0] next_sum_A, next_sum_B;
logic stage1_valid, next_stage1_valid; 

logic [31:0] mul_A, mul_B, mul_C, mul_D, mul_E, mul_F, mul_G, mul_H, mul_I;
logic [31:0] next_mul_A, next_mul_B, next_mul_C, next_mul_D, next_mul_E, next_mul_F, next_mul_G, next_mul_H, next_mul_I;
logic stage2_valid, next_stage2_valid;

logic [95:0] sum_C, next_sum_C;
logic stage3_valid, next_stage3_valid;

//---------------------------------------------------------------------
//   Your DESIGN                        
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_A        <= 48'd0;
        sum_B        <= 48'd0;
        stage1_valid <= 1'b0;
    end
    else begin
        sum_A        <= next_sum_A;
        sum_B        <= next_sum_B;
        stage1_valid <= next_stage1_valid;
    end
end

always_comb begin
    if(in_valid) begin
        next_sum_A        = in_1 + in_2;
        next_sum_B        = in_3 + in_4;
        next_stage1_valid = 1'b1;
    end
    else begin
        next_sum_A        = 48'd0;
        next_sum_B        = 48'd0;
        next_stage1_valid = 1'b0;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_A        <= 32'd0;
        mul_B        <= 32'd0;
        mul_C        <= 32'd0;
        mul_D        <= 32'd0;
        mul_E        <= 32'd0;
        mul_F        <= 32'd0;
        mul_G        <= 32'd0;
        mul_H        <= 32'd0;
        mul_I        <= 32'd0;
        stage2_valid <= next_stage2_valid;
    end
    else begin
        mul_A        <= next_mul_A;
        mul_B        <= next_mul_B;
        mul_C        <= next_mul_C;
        mul_D        <= next_mul_D;
        mul_E        <= next_mul_E;
        mul_F        <= next_mul_F;
        mul_G        <= next_mul_G;
        mul_H        <= next_mul_H;
        mul_I        <= next_mul_I;
        stage2_valid <= next_stage2_valid;
    end
end

always_comb begin
    if(stage1_valid) begin
        next_mul_A = sum_A[15:0]  * sum_B[15:0];
        next_mul_B = sum_A[31:16] * sum_B[15:0];
        next_mul_C = sum_A[47:32] * sum_B[15:0];
        next_mul_D = sum_A[15:0]  * sum_B[31:16];
        next_mul_E = sum_A[31:16] * sum_B[31:16];
        next_mul_F = sum_A[47:32] * sum_B[31:16];      
        next_mul_G = sum_A[15:0]  * sum_B[47:32];
        next_mul_H = sum_A[31:16] * sum_B[47:32];
        next_mul_I = sum_A[47:32] * sum_B[47:32];
        next_stage2_valid = 1'b1;
    end
    else begin
        next_mul_A = 32'd0;
        next_mul_B = 32'd0;
        next_mul_C = 32'd0;
        next_mul_D = 32'd0;
        next_mul_E = 32'd0;
        next_mul_F = 32'd0;      
        next_mul_G = 32'd0;
        next_mul_H = 32'd0;
        next_mul_I = 32'd0;
        next_stage2_valid = 1'b0;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_C        <= 96'd0;
        stage3_valid <= 1'b0;
    end
    else begin
        sum_C        <= next_sum_C;
        stage3_valid <= next_stage3_valid;
    end
end

always_comb begin
    if(stage2_valid) begin
        next_sum_C        = {mul_C, 32'b0} + {mul_B, 16'b0} + mul_A + {mul_F, 48'b0} + {mul_E, 32'b0} + {mul_D, 16'b0} + {mul_I, 64'b0} + {mul_H, 48'b0} + {mul_G, 32'b0};
        next_stage3_valid = 1'b1;
    end
    else begin
        next_sum_C        = 96'd0;
        next_stage3_valid = 1'b0;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out       <= 96'd0;
        out_valid <= 1'b0;
    end
    else begin
        out       <= next_out;
        out_valid <= next_out_valid;
    end
end

always_comb begin
    if(stage3_valid) begin
        next_out       = sum_C;
        next_out_valid = 1'b1;
    end
    else begin
        next_out       = 96'd0;
        next_out_valid = 1'b0;
    end
end

endmodule