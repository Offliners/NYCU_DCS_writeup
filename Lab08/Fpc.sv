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

//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end


endmodule

