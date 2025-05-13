module IMG_SUB(
    // Input signals
    clk,
    rst_n,
    in_valid,
    in_image,

    // Output signals
    out_valid,
    out_diff
);
 
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
input              clk, rst_n;
input              in_valid;
input        [3:0] in_image;
output logic       out_valid;
output logic [3:0] out_diff;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [3:0] image [3:0];
parameter IDLE        = 2'd0,
          INPUT_IMG1  = 2'd1,
          INPUT_IMG2  = 2'd2,
          OUTPUT_DIFF = 2'd3;

logic [1:0] state, next_state;
logic [3:0] counter, next_counter;
logic next_out_valid;
logic [3:0] next_out_diff;

//---------------------------------------------------------------------
//   Your design
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        state <= IDLE;
    else
        state <= next_state; 
end

always_comb begin
    case(state)
        default:     next_state = IDLE;
        IDLE:        next_state = in_valid ? INPUT_IMG1 : IDLE;
        INPUT_IMG1:  next_state = (counter == 4'd8) ? INPUT_IMG2 : INPUT_IMG1;
        INPUT_IMG2:  next_state = (counter == 4'd8) ? OUTPUT_DIFF : INPUT_IMG2;
        OUTPUT_DIFF: next_state = (counter == 4'd8) ? IDLE : OUTPUT_DIFF;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        counter <= 4'd0;
    else
        counter <= (state == IDLE || counter == 4'd8) ? 4'd0 : counter + 4'd1;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_valid <= 1'd0;
        out_diff <= 4'd0;
    end
    else begin
        out_valid <= next_out_valid;
        out_diff <= next_out_diff;
    end
end

always_comb begin
    if(state == INPUT_IMG1)
        image[counter] = in_image;
    else if(state == INPUT_IMG2)
        image[counter] = image[counter] - in_image;
    else if(state == OUTPUT_DIFF) begin
        next_out_valid = 1'd1;
        next_out_diff = image[counter];
    end
    else begin
        next_out_valid = 1'd0;
        next_out_diff = 4'd0;
    end
end

endmodule