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

logic [1:0] cur_state, next_state;
logic in_valid_reg_1, in_valid_reg_2;
logic [6:0] data_reg_1, data_reg_2;

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    cur_state <= S_idle;
  else
    cur_state <= next_state;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    in_valid_reg_1 <= 0;
  else if(cur_state == S_master1)
    in_valid_reg_1 <= 0;
  else if(in_valid_1)
    in_valid_reg_1 <= in_valid_1;
  else
    in_valid_reg_1 <= in_valid_reg_1;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    in_valid_reg_2 <= 0;
  else if(cur_state == S_master2)
    in_valid_reg_2 <= 0;
  else if(in_valid_2)
    in_valid_reg_2 <= in_valid_2;
  else
    in_valid_reg_2 <= in_valid_reg_2;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    data_reg_1 <= 0;
  else if(in_valid_1)
    data_reg_1 <= data_in_1;
  else
    data_reg_1 <= data_reg_1;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    data_reg_2 <= 0;
  else if(in_valid_2)
    data_reg_2 <= data_in_2;
  else
    data_reg_2 <= data_reg_2;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    handshake_slave1 <= 0;
  else if(next_state == S_handshake && (data_reg_1[6] == 0 || data_reg_2[6] == 0))
    handshake_slave1 <= 1;
  else
    handshake_slave1 <= 0;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    handshake_slave2 <= 0;
  else if(next_state == S_handshake && (data_reg_1[6] || data_reg_2[6]))
    handshake_slave2 <= 1;
  else
    handshake_slave2 <= 0;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    valid_slave1 <= 0;
  else if(next_state == S_master1 && data_reg_1[6] == 0)
    valid_slave1 <= 1;
  else if(next_state == S_master2 && data_reg_2[6] == 0)
    valid_slave1 <= 1;
  else
    valid_slave1 <= 0;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    valid_slave2 <= 0;
  else if(next_state == S_master1 && data_reg_1[6])
    valid_slave2 <= 1;
  else if(next_state == S_master2 && data_reg_2[6])
    valid_slave2 <= 1;
  else
    valid_slave2 <= 0;
end

always_comb begin
  case(cur_state)
    S_idle:
      next_state = (in_valid_reg_1) ? S_master1 : ((in_valid_reg_2) ? S_master2 : S_idle);
    S_master1:  
      next_state = (data_reg_1[6] == 0 && ready_slave1) ? S_handshake : ((data_reg_1[6] && ready_slave2) ? S_handshake : S_master1);
    S_master2:  
      next_state = (data_reg_2[6] == 0 && ready_slave1) ? S_handshake : ((data_reg_2[6] && ready_slave2) ? S_handshake : S_master2);  
    default:
      next_state = S_idle;  
  endcase
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    addr_out <= 0;
    value_out <= 0;
  end
  else if (next_state == S_master1) begin
    addr_out <= data_reg_1[5:3];
    value_out <= data_reg_1[2:0];
  end
  else if(next_state == S_master2) begin
    addr_out <= data_reg_2[5:3];
    value_out <= data_reg_2[2:0];
  end
  else begin
    addr_out <= 0;
    value_out <= 0;
  end
end

endmodule