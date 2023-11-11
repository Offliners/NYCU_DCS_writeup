module inter(
  // Input signals
  clk,
  rst_n,
  in_valid_1,
  in_valid_2,
  data_in_1,
  data_in_2,
  ready_slave1,
  ready_slave2,

  // Output signals
  valid_slave1,
  valid_slave2,
  addr_out,
  value_out,
  handshake_slave1,
  handshake_slave2
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid_1, in_valid_2;
input [6:0] data_in_1, data_in_2; 
input ready_slave1, ready_slave2;

output logic valid_slave1, valid_slave2;
output logic [2:0] addr_out, value_out;
output logic handshake_slave1, handshake_slave2;

parameter S_idle = 2'b00,
          S_master1 = 2'b01, 
          S_master2 = 2'b10,
          S_handshake = 2'b11;

logic in_1, in_2, in_bef_1, in_bef_2;
logic [6:0] data_1, data_2, data_bef_1, data_bef_2;
logic [1:0] cur_state, next_state;
logic [2:0] value_out_temp, addr_out_temp;

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cur_state <= S_idle;
    in_bef_1 <= 0;
    in_bef_2 <= 0;
    data_bef_1 <= 0;
    data_bef_2 <= 0;
  end
  else begin
    cur_state <= next_state;
    in_bef_1 <= in_valid_1;
    in_bef_2 <= in_valid_2;
    data_bef_1 <= data_1;
    data_bef_2 <= data_2;
  end
end

always_comb begin
  in_1 = (in_valid_1) ? 1 : in_bef_1;
  in_2 = (in_valid_2) ? 1 : in_bef_2;
  data_1 = (in_valid_1) ? data_in_1 : data_bef_1;
  data_2 = (in_valid_2) ? data_in_2 : data_bef_2;

  case(cur_state)
    S_idle:
      if(in_1) begin
        next_state = S_master1;
        in_1 = 0;
      end
      else if(in_2) begin
        next_state = S_master2;
        in_2 = 0;
      end
      else
        next_state = cur_state;
    S_master1:
      if(data_1[6] == 0) begin
        if(valid_slave1 && ready_slave1) begin
          next_state = S_handshake;
          in_1 = 0;
        end
        else
          next_state = cur_state;
      end
      else begin
        if(valid_slave2 && ready_slave2) begin
          next_state = S_handshake;
          in_1 = 0;
        end
        else
          next_state = cur_state;
      end
    S_handshake:
      if(in_1)
        next_state = S_master1;
      else if(in_2)
        next_state = S_master2;
      else
        next_state = cur_state;
    default:
      next_state = cur_state;
  endcase
end

always_comb begin
  if(cur_state == S_master1) begin
    value_out_temp = data_1[2:0];
    addr_out_temp = data_1[5:3];
  end
  else if (cur_state == S_master2) begin
    value_out_temp = data_2[2:0];
    addr_out_temp = data_2[5:3];
  end
  else begin
    value_out_temp = 0;
    addr_out_temp = 0;
  end
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    value_out <= 0;
    addr_out <= 0;
  end
  else begin
    value_out <= value_out_temp;
    addr_out <= addr_out_temp;
  end
end

endmodule
