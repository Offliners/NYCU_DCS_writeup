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
logic [3:0] image [17:0];
parameter IDLE        = 2'd0,
          INPUT_IMG   = 2'd1,
          OUTPUT_DIFF = 2'd2;

logic [1:0] state, next_state;
logic [4:0] counter;
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
        IDLE:        next_state = in_valid ? INPUT_IMG : IDLE;
        INPUT_IMG:   next_state = (counter == 5'd17) ? OUTPUT_DIFF : INPUT_IMG;
        OUTPUT_DIFF: next_state = (counter == 5'd26) ? IDLE : OUTPUT_DIFF;
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        for(int i = 0; i <= 17; i++) begin
            image[i] <= 4'd0;
        end
    else if(in_valid) begin
        image[17] <= in_image;
        for(int i = 0; i < 17; i++) begin
            image[i] <= image[i + 1];
        end
    end
    else begin
        for(int i = 0; i <= 17; i++) begin
            image[i] <= image[i];
        end
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        counter <= 5'd0;
    else
        counter <= (in_valid || out_valid) ? counter + 5'd1 : 5'd0;
end

assign out_valid = (state == OUTPUT_DIFF) ? 1'b1 : 1'd0;
assign out_diff  = (state == OUTPUT_DIFF) ? (image[counter - 5'd18] - image[counter - 5'd9]) : 4'd0;

endmodule