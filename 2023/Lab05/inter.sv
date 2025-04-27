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


//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
parameter [1:0] S_IDLE      = 2'd0,
                S_MASTER1   = 2'd1,
                S_MASTER2   = 2'd2,
                S_HANDSHAKE = 2'd3;
logic [1:0] state, next_state;
logic in1, in2;
logic select_slave1, select_slave2;
logic [2:0] addr_out1, addr_out2, value_out1, value_out2;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    state <= S_IDLE;
  else
    state <= next_state;
end

always_comb begin
  case(state)
    default : next_state = S_IDLE;
    S_IDLE : begin
      if(in1)
        next_state = S_MASTER1;
      else if(in2)
        next_state = S_MASTER2;
      else
        next_state = state;
    end
    S_MASTER1 : begin
      if(select_slave1 == 1'b0) begin
        if(valid_slave1 && ready_slave1)
          next_state = S_HANDSHAKE;
        else
          next_state = S_MASTER1;
      end
      else begin
        if(valid_slave2 && ready_slave2)
          next_state = S_HANDSHAKE;
        else
          next_state = S_MASTER1;
      end
    end
    S_MASTER2 : begin
      if(select_slave2 == 1'b0) begin
        if(valid_slave1 && ready_slave1)
          next_state = S_HANDSHAKE;
        else
          next_state = S_MASTER2;
      end
      else begin
        if(valid_slave2 && ready_slave2)
          next_state = S_HANDSHAKE;
        else
          next_state = S_MASTER2;
      end
    end
    S_HANDSHAKE : begin
      if(in1)
        next_state = S_MASTER1;
      else if(in2)
        next_state = S_MASTER2;
      else
        next_state = S_HANDSHAKE;
    end
  endcase
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    select_slave1 <= 1'b0;
    select_slave2 <= 1'b0;
    addr_out1     <= 3'd0;
    value_out1    <= 3'd0;
    addr_out2     <= 3'd0;
    value_out2    <= 3'd0;
  end
  else begin
    if(in_valid_1) begin
      select_slave1 <= data_in_1[6];
      addr_out1     <= data_in_1[5:3];
      value_out1    <= data_in_1[2:0];
    end
    
    if(in_valid_2) begin
      select_slave2 <= data_in_2[6];
      addr_out2     <= data_in_2[5:3];
      value_out2    <= data_in_2[2:0];
    end
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    in1 <= 1'b0;
  else if(in_valid_1)
    in1 <= 1'b1;
  else if(state == S_MASTER1 && next_state == S_HANDSHAKE)
    in1 <= 1'b0;
  else
    in1 <= in1;
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    in2 <= 1'b0;
  else if(in_valid_2)
    in2 <= 1'b1;
  else if(state == S_MASTER2 && next_state == S_HANDSHAKE)
    in2 <= 1'b0;
  else
    in2 <= in2;
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    addr_out  <= 3'd0;
    value_out <= 3'd0;
  end
  else begin
    if(in1 && state == S_MASTER1) begin
      addr_out  <= addr_out1;
      value_out <= value_out1; 
    end
    else if(in2 && state == S_MASTER2) begin
      addr_out  <= addr_out2;
      value_out <= value_out2; 
    end

    if(handshake_slave1 || handshake_slave2) begin
      addr_out  <= 3'd0;
      value_out <= 3'd0;
    end
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    valid_slave1 <= 1'b0;
    valid_slave2 <= 1'b0;
  end
  else begin
    if(in1 && state == S_MASTER1) begin
      valid_slave1 <= !select_slave1;
      valid_slave2 <= select_slave1;
    end
    else if(handshake_slave1)
      valid_slave1 <= 1'b0;
    
    if(in2 && state == S_MASTER2) begin
      valid_slave1 <= !select_slave2;
      valid_slave2 <= select_slave2;
    end
    else if(handshake_slave2)
      valid_slave2 <= 1'b0;
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    handshake_slave1 <= 1'b0;
    handshake_slave2 <= 1'b0;
  end
  else begin
    if(valid_slave1 && ready_slave1)
      handshake_slave1 <= 1'b1;
    else if(handshake_slave1)
      handshake_slave1 <= 1'b0; 

    if(valid_slave2 && ready_slave2)
      handshake_slave2 <= 1'b1;
    else if(handshake_slave2)
      handshake_slave2 <= 1'b0;
  end
end

endmodule