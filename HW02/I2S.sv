module I2S(
  // Input signals
  clk,
  rst_n,
  in_valid,
  SD,
  WS,

  // Output signals
  out_valid,
  out_left,
  out_right
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input SD, WS;

output logic        out_valid;
output logic [31:0] out_left, out_right;

logic [31:0] in_data, in_data_next;
logic        cur_WS, cur_WS_next;
logic        cur_val, cur_val_next;
logic        flag_WS, flag_val;
logic        out_valid_next;
logic [31:0] out_left_next, out_right_next;

always_comb begin
  if(in_valid) begin
    if(WS != cur_WS)
      in_data_next = {30'd0, SD};
    else
      in_data_next = {in_data[30:0], SD};
  end
  else
    in_data_next = 0;
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n)
    in_data <= 0;
  else
    in_data <= in_data_next;
end

always_comb begin
  if(in_valid) begin
    cur_WS_next = WS;
    cur_val_next = in_valid;
  end
  else begin
    cur_WS_next = 0;
    cur_val_next = 0;
  end
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cur_WS <= 0;
    cur_val <= 0;
  end
  else begin
    cur_WS <= cur_WS_next;
    cur_val <= cur_val_next;
  end
end

assign flag_WS = (cur_WS == WS) ? 0 : 1;
assign flag_val = (cur_val == in_valid) ? 0 : 1;

always_comb begin
  if(in_valid) begin
    if(flag_val) begin
      out_valid_next = 0;
      out_left_next = 0;
      out_right_next = 0;
    end
    else begin
      if(flag_WS) begin
        out_valid_next = 1;

        if(!cur_WS) begin
          out_left_next = in_data;
          out_right_next = 0;
        end
        else begin
          out_left_next = 0;
          out_right_next = in_data;
        end
      end
      else begin
        out_valid_next = 0;
        out_left_next = 0;
        out_right_next = 0;
      end
    end
  end
  else begin
    if(flag_val) begin
        out_valid_next = 1;

        if(!cur_WS) begin
          out_left_next = in_data;
          out_right_next = 0;
        end
        else begin
          out_left_next = 0;
          out_right_next = in_data;
        end
      end
      else begin
        out_valid_next = 0;
        out_left_next = 0;
        out_right_next = 0;
      end
  end
end

always_ff @ (posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    out_valid <= 0;
    out_left <= 0;
    out_right <= 0;
  end
  else begin
    out_valid <= out_valid_next;
    out_left <= out_left_next;
    out_right <= out_right_next;
  end
end

endmodule