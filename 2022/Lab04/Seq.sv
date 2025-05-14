module Seq(
    // input signals
    clk,
    rst_n,
    in_data,
    in_state_reset,

    // output signals
    out_cur_state,
    out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk,rst_n,in_data,in_state_reset;
output logic [2:0] out_cur_state;
output logic out;

//---------------------------------------------------------------------
//   FSM state                      
//---------------------------------------------------------------------
parameter S0 = 3'd0, 
          S1 = 3'd1,
          S2 = 3'd2,
          S3 = 3'd3,
          S4 = 3'd4,
          S5 = 3'd5,
          S6 = 3'd6,
          S7 = 3'd7;

logic [2:0] state, next_state;

//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= S0;
        out_cur_state <= S0;
    end
    else begin
        state <= in_state_reset ? S0 : next_state;
        out_cur_state <= in_state_reset ? S0 : next_state;
    end
end

always_comb begin
    case(state)
        default:    next_state = S0;
        S0:         next_state = in_data ? S1 : S2;
        S1:         next_state = in_data ? S1 : S4;
        S2:         next_state = in_data ? S4 : S3;
        S3:         next_state = in_data ? S5 : S6;
        S4:         next_state = in_data ? S4 : S5;
        S5:         next_state = in_data ? S5 : S7;
        S6:         next_state = in_data ? S7 : S6;
        S7:         next_state = in_data ? S7 : S7;
    endcase
end

always_comb begin
    case(state)
        default:                    out = 1'b0;
        S0, S1, S2, S3, S4, S5, S6: out = 1'b0;
        S7:                         out = 1'b1;
    endcase
end

endmodule