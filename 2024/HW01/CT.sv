module CT(
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
output logic [10:0] out_n;

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
logic [7:0] sum;
logic [4:0] mean;

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

assign sum = (lv8_n0 + lv8_n1 + lv8_n2 + lv8_n3 + lv8_n4 + lv8_n5);
divider6 div6(.num(sum), .result(mean));

always_comb begin
    case(opcode[2:0])
        3'b000: begin 
            if(mean <= lv7_n1) out_n = 10'd5;
            else if(mean <= lv7_n2) out_n = 10'd4;
            else if(mean <= lv7_n3) out_n = 10'd3;
            else if(mean <= lv7_n4) out_n = 10'd2;
            else if(mean <= lv7_n5) out_n = 10'd1;
            else out_n = 10'd6;
        end
        3'b001: 
            out_n = lv8_n0 + lv8_n5;
        3'b010: 
            out_n = (lv8_n3 * lv8_n4) >> 1;
        3'b011: 
            out_n = lv8_n0 + (lv8_n2 << 1);
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

module divider6(
    // Input signals
    num,

    // Output signals
    result
);

input [7:0] num;
output logic [4:0] result;

always_comb begin
    case(num)
        default: result = 5'd0;
        8'd029: result = 5'd04;
        8'd030: result = 5'd05;
        8'd031: result = 5'd05;
        8'd032: result = 5'd05;
        8'd033: result = 5'd05;
        8'd034: result = 5'd05;
        8'd035: result = 5'd05;
        8'd036: result = 5'd06;
        8'd037: result = 5'd06;
        8'd038: result = 5'd06;
        8'd039: result = 5'd06;
        8'd040: result = 5'd06;
        8'd041: result = 5'd06;
        8'd042: result = 5'd07;
        8'd043: result = 5'd07;
        8'd044: result = 5'd07;
        8'd045: result = 5'd07;
        8'd046: result = 5'd07;
        8'd047: result = 5'd07;
        8'd048: result = 5'd08;
        8'd049: result = 5'd08;
        8'd050: result = 5'd08;
        8'd051: result = 5'd08;
        8'd052: result = 5'd08;
        8'd053: result = 5'd08;
        8'd054: result = 5'd09;
        8'd055: result = 5'd09;
        8'd056: result = 5'd09;
        8'd057: result = 5'd09;
        8'd058: result = 5'd09;
        8'd059: result = 5'd09;
        8'd060: result = 5'd10;
        8'd061: result = 5'd10;
        8'd062: result = 5'd10;
        8'd063: result = 5'd10;
        8'd064: result = 5'd10;
        8'd065: result = 5'd10;
        8'd066: result = 5'd11;
        8'd067: result = 5'd11;
        8'd068: result = 5'd11;
        8'd069: result = 5'd11;
        8'd070: result = 5'd11;
        8'd071: result = 5'd11;
        8'd072: result = 5'd12;
        8'd073: result = 5'd12;
        8'd074: result = 5'd12;
        8'd075: result = 5'd12;
        8'd076: result = 5'd12;
        8'd077: result = 5'd12;
        8'd078: result = 5'd13;
        8'd079: result = 5'd13;
        8'd080: result = 5'd13;
        8'd081: result = 5'd13;
        8'd082: result = 5'd13;
        8'd083: result = 5'd13;
        8'd084: result = 5'd14;
        8'd085: result = 5'd14;
        8'd086: result = 5'd14;
        8'd087: result = 5'd14;
        8'd088: result = 5'd14;
        8'd089: result = 5'd14;
        8'd090: result = 5'd15;
        8'd091: result = 5'd15;
        8'd092: result = 5'd15;
        8'd093: result = 5'd15;
        8'd094: result = 5'd15;
        8'd095: result = 5'd15;
        8'd096: result = 5'd16;
        8'd097: result = 5'd16;
        8'd098: result = 5'd16;
        8'd099: result = 5'd16;
        8'd100: result = 5'd16;
        8'd101: result = 5'd16;
        8'd102: result = 5'd17;
        8'd103: result = 5'd17;
        8'd104: result = 5'd17;
        8'd105: result = 5'd17;
        8'd106: result = 5'd17;
        8'd107: result = 5'd17;
        8'd108: result = 5'd18;
        8'd109: result = 5'd18;
        8'd110: result = 5'd18;
        8'd111: result = 5'd18;
        8'd112: result = 5'd18;
        8'd113: result = 5'd18;
        8'd114: result = 5'd19;
        8'd115: result = 5'd19;
        8'd116: result = 5'd19;
        8'd117: result = 5'd19;
        8'd118: result = 5'd19;
        8'd119: result = 5'd19;
        8'd120: result = 5'd20;
        8'd121: result = 5'd20;
        8'd122: result = 5'd20;
        8'd123: result = 5'd20;
        8'd124: result = 5'd20;
        8'd125: result = 5'd20;
        8'd126: result = 5'd21;
        8'd127: result = 5'd21;
        8'd128: result = 5'd21;
        8'd129: result = 5'd21;
        8'd130: result = 5'd21;
        8'd131: result = 5'd21;
        8'd132: result = 5'd22;
        8'd133: result = 5'd22;
        8'd134: result = 5'd22;
        8'd135: result = 5'd22;
        8'd136: result = 5'd22;
        8'd137: result = 5'd22;
        8'd138: result = 5'd23;
        8'd139: result = 5'd23;
        8'd140: result = 5'd23;
        8'd141: result = 5'd23;
        8'd142: result = 5'd23;
        8'd143: result = 5'd23;
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