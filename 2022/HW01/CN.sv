module CN(
    // Input signals
    opcode,
	in_n0,
	in_n1,
	in_n2,
	in_n3,
	in_n4,
	in_n5,

    // Output signals
    out_n
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_n0, in_n1, in_n2, in_n3, in_n4, in_n5;
input [4:0] opcode;
output logic [8:0] out_n;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [4:0] value0, value1, value2, value3, value4, value5;
logic [4:0] lv0_n0, lv0_n1, lv0_n2, lv0_n3, lv0_n4, lv0_n5;
logic [4:0] lv1_n0, lv1_n1, lv1_n2, lv1_n3, lv1_n4, lv1_n5;
logic [4:0] lv2_n0, lv2_n1, lv2_n2, lv2_n3, lv2_n4, lv2_n5;
logic [4:0] lv3_n0, lv3_n1, lv3_n2, lv3_n3, lv3_n4, lv3_n5;
logic [4:0] lv4_n0, lv4_n1, lv4_n2, lv4_n3, lv4_n4, lv4_n5;
logic [4:0] lv5_n0, lv5_n1, lv5_n2, lv5_n3, lv5_n4, lv5_n5;
logic [4:0] lv6_n0, lv6_n1, lv6_n2, lv6_n3, lv6_n4, lv6_n5;
logic [4:0] lv7_n0, lv7_n1, lv7_n2, lv7_n3, lv7_n4, lv7_n5;
logic [4:0] lv8_n0, lv8_n1, lv8_n2, lv8_n3, lv8_n4, lv8_n5;

//---------------------------------------------------------------------
//   Your design
//---------------------------------------------------------------------
register_file reg_file0(.address(in_n0), .value(value0));
register_file reg_file1(.address(in_n1), .value(value1));
register_file reg_file2(.address(in_n2), .value(value2));
register_file reg_file3(.address(in_n3), .value(value3));
register_file reg_file4(.address(in_n4), .value(value4));
register_file reg_file5(.address(in_n5), .value(value5));

// CMP LV0
assign lv0_n0 = value0;
comparator cmp0(.smaller(lv0_n1), .bigger(lv0_n3), .a(value1), .b(value3));
assign lv0_n2 = value2;
assign lv0_n4 = value4;
assign lv0_n5 = value5;

// CMP LV1
comparator cmp1(.smaller(lv1_n0), .bigger(lv1_n5), .a(lv0_n0), .b(lv0_n5));
assign lv1_n1 = lv0_n1;
assign lv1_n2 = lv0_n2;
assign lv1_n3 = lv0_n3;
assign lv1_n4 = lv0_n4;

// CMP LV2
assign lv2_n0 = lv1_n0;
assign lv2_n1 = lv1_n1;
comparator cmp2(.smaller(lv2_n2), .bigger(lv2_n4), .a(lv1_n2), .b(lv1_n4));
assign lv2_n3 = lv1_n3;
assign lv2_n5 = lv1_n5;

// CMP LV3
assign lv3_n0 = lv2_n0;
comparator cmp3_0(.smaller(lv3_n1), .bigger(lv3_n2), .a(lv2_n1), .b(lv2_n2));
comparator cmp3_1(.smaller(lv3_n3), .bigger(lv3_n4), .a(lv2_n3), .b(lv2_n4));
assign lv3_n5 = lv2_n5;

// CMP LV4
comparator cmp4(.smaller(lv4_n0), .bigger(lv4_n3), .a(lv3_n0), .b(lv3_n3));
assign lv4_n1 = lv3_n1;
assign lv4_n2 = lv3_n2;
assign lv4_n4 = lv3_n4;
assign lv4_n5 = lv3_n5;


// CMP LV5
assign lv5_n0 = lv4_n0;
assign lv5_n1 = lv4_n1;
comparator cmp5(.smaller(lv5_n2), .bigger(lv5_n5), .a(lv4_n2), .b(lv4_n5));
assign lv5_n3 = lv4_n3;
assign lv5_n4 = lv4_n4;

// CMP LV6
comparator cmp6_0(.smaller(lv6_n0), .bigger(lv6_n1), .a(lv5_n0), .b(lv5_n1));
comparator cmp6_1(.smaller(lv6_n2), .bigger(lv6_n3), .a(lv5_n2), .b(lv5_n3));
comparator cmp6_2(.smaller(lv6_n4), .bigger(lv6_n5), .a(lv5_n4), .b(lv5_n5));

// CMP LV7
assign lv7_n0 = lv6_n0;
comparator cmp7_0(.smaller(lv7_n1), .bigger(lv7_n2), .a(lv6_n1), .b(lv6_n2));
comparator cmp7_1(.smaller(lv7_n3), .bigger(lv7_n4), .a(lv6_n3), .b(lv6_n4));
assign lv7_n5 = lv6_n5;

always_comb begin
    case(opcode[4:3])
        2'b00:
            {lv8_n0, lv8_n1, lv8_n2, lv8_n3, lv8_n4, lv8_n5} = {value0, value1, value2, value3, value4, value5};
        2'b01:
            {lv8_n0, lv8_n1, lv8_n2, lv8_n3, lv8_n4, lv8_n5} = {value5, value4, value3, value2, value1, value0};
        2'b10:
            {lv8_n0, lv8_n1, lv8_n2, lv8_n3, lv8_n4, lv8_n5} = {lv7_n5, lv7_n4, lv7_n3, lv7_n2, lv7_n1, lv7_n0};
        2'b11:
            {lv8_n0, lv8_n1, lv8_n2, lv8_n3, lv8_n4, lv8_n5} = {lv7_n0, lv7_n1, lv7_n2, lv7_n3, lv7_n4, lv7_n5};
    endcase
end

always_comb begin
    case(opcode[2:0])
        3'b000:
			out_n = lv8_n2 - lv8_n1;
        3'b001: 
            out_n = lv8_n0 + lv8_n3;
        3'b010: 
            out_n = (lv8_n3 * lv8_n4) / 2;
        3'b011: 
            out_n = lv8_n1 + (lv8_n5 << 1);
        3'b100: 
            out_n = lv8_n1 & lv8_n2;
        3'b101: 
            out_n = ~lv8_n0;
        3'b110: 
            out_n = lv8_n3 ^ lv8_n4;
        3'b111: 
            out_n = lv8_n1 << 1; 
    endcase
end

endmodule


module comparator(
    // Input signals
    a,
    b,

    // Output signals
    smaller,
    bigger
);

input [4:0] a, b;
output [4:0] smaller, bigger;

assign smaller = (a < b) ? a : b;
assign bigger  = (a < b) ? b : a;

endmodule


//---------------------------------------------------------------------
//   Register design from TA (Do not modify, or demo fails)
//---------------------------------------------------------------------
module register_file(
    address,
    value
);
input [3:0] address;
output logic [4:0] value;

always_comb begin
    case(address)
    4'b0000:value = 5'd9;
    4'b0001:value = 5'd27;
    4'b0010:value = 5'd30;
    4'b0011:value = 5'd3;
    4'b0100:value = 5'd11;
    4'b0101:value = 5'd8;
    4'b0110:value = 5'd26;
    4'b0111:value = 5'd17;
    4'b1000:value = 5'd3;
    4'b1001:value = 5'd12;
    4'b1010:value = 5'd1;
    4'b1011:value = 5'd10;
    4'b1100:value = 5'd15;
    4'b1101:value = 5'd5;
    4'b1110:value = 5'd23;
    4'b1111:value = 5'd20;
    default: value = 0;
    endcase
end

endmodule