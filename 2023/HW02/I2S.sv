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


//---------------------------------------------------------------------
//   REG AND WIRE DECLARATION                         
//---------------------------------------------------------------------
parameter [1:0] IDLE       = 2'd0,
                LEFT_READ  = 2'd1,
                RIGHT_READ = 2'd2;

logic [1:0] state, next_state;
logic [32:0] buffer, next_buffer;
logic [1:0] sel, next_sel;

//---------------------------------------------------------------------
//   YOUR DESIGN                         
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    state <= IDLE;
  else
    state <= next_state;
end

always_comb begin
  next_buffer = out_valid ? {buffer[0], SD & in_valid} : {buffer[31:0], SD & in_valid};

  case(state)
    default : begin
      next_sel = sel;
      next_state = state;
    end
    IDLE : begin
      next_sel = 2'b00;
      if(in_valid)
        next_state = WS ? RIGHT_READ : LEFT_READ;
      else
        next_state = IDLE;
    end
    LEFT_READ : begin
      if(in_valid) begin
        if(WS) begin
          next_sel = 2'b10;
          next_state = RIGHT_READ;
        end 
        else begin
          next_sel = 2'b00;
          next_state = LEFT_READ;
        end
      end
      else begin
        next_sel = 2'b10;
        next_state = IDLE;
      end
    end
    RIGHT_READ : begin
      if(in_valid) begin
        if(WS) begin
          next_sel = 2'b00;
          next_state = RIGHT_READ;
        end
        else begin
          next_sel = 2'b01;
          next_state = LEFT_READ;
        end
      end
      else begin
        next_sel = 2'b01;
        next_state = IDLE;
      end
    end
  endcase
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    buffer <= 33'd0;
    sel    <= 2'd0;
  end
  else begin
    buffer <= next_buffer;
    sel    <= next_sel;
  end
end

always_comb begin
  out_valid = sel[0] | sel[1];

  if(sel[0]) begin
    out_left  = 32'd0;
    out_right = buffer[32:1];
  end
  else if(sel[1]) begin
    out_left  = buffer[32:1];
	  out_right = 32'd0;
  end
  else begin
    out_left  = 32'd0;
	  out_right = 32'd0;
  end
end

endmodule