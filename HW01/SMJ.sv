module SMJ(
    // Input signals
    hand_n0,
    hand_n1,
    hand_n2,
    hand_n3,
    hand_n4,

    // Output signals
    out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [5:0] hand_n0;
input [5:0] hand_n1;
input [5:0] hand_n2;
input [5:0] hand_n3;
input [5:0] hand_n4;
output logic [1:0] out_data;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic hand_err, hand_err_0, hand_err_1, hand_err_2, hand_err_3, hand_err_4; 

logic [5:0] lv0_n0, lv0_n1, lv0_n2, lv0_n3, lv0_n4;
logic [5:0] lv1_n0, lv1_n1, lv1_n2, lv1_n3, lv1_n4;
logic [5:0] lv2_n0, lv2_n1, lv2_n2, lv2_n3, lv2_n4;
logic [5:0] lv3_n0, lv3_n1, lv3_n2, lv3_n3, lv3_n4;
logic [5:0] lv4_n0, lv4_n1, lv4_n2, lv4_n3, lv4_n4;

logic front_pair, end_pair;
logic front_seq, end_seq;
logic front_tri, end_tri;
logic pair_2_3, pair_3_2, pair_1_3_1;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
assign hand_err_0 = (hand_n0[5:4] == 2'b00 && hand_n0[3:0] > 4'b0110) || (hand_n0[5:4] > 2'b00 && hand_n0[3:0] > 4'b1000);
assign hand_err_1 = (hand_n1[5:4] == 2'b00 && hand_n1[3:0] > 4'b0110) || (hand_n1[5:4] > 2'b00 && hand_n1[3:0] > 4'b1000);
assign hand_err_2 = (hand_n2[5:4] == 2'b00 && hand_n2[3:0] > 4'b0110) || (hand_n2[5:4] > 2'b00 && hand_n2[3:0] > 4'b1000);
assign hand_err_3 = (hand_n3[5:4] == 2'b00 && hand_n3[3:0] > 4'b0110) || (hand_n3[5:4] > 2'b00 && hand_n3[3:0] > 4'b1000);
assign hand_err_4 = (hand_n4[5:4] == 2'b00 && hand_n4[3:0] > 4'b0110) || (hand_n4[5:4] > 2'b00 && hand_n4[3:0] > 4'b1000);
assign hand_err = hand_err_0 || hand_err_1 || hand_err_2 || hand_err_3 || hand_err_4;

comparator cmp0_lv0 (.in_0(hand_n0), .in_1(hand_n1), .out_0(lv0_n0), .out_1(lv0_n1));
comparator cmp1_lv0 (.in_0(hand_n2), .in_1(hand_n3), .out_0(lv0_n2), .out_1(lv0_n3));
assign lv0_n4 = hand_n4;

assign lv1_n0 = lv0_n0;
comparator cmp2_lv1 (.in_0(lv0_n1), .in_1(lv0_n2), .out_0(lv1_n1), .out_1(lv1_n2));
comparator cmp3_lv1 (.in_0(lv0_n3), .in_1(lv0_n4), .out_0(lv1_n3), .out_1(lv1_n4));

comparator cmp4_lv2 (.in_0(lv1_n0), .in_1(lv1_n1), .out_0(lv2_n0), .out_1(lv2_n1));
comparator cmp5_lv2 (.in_0(lv1_n2), .in_1(lv1_n3), .out_0(lv2_n2), .out_1(lv2_n3));
assign lv2_n4 = lv1_n4;

assign lv3_n0 = lv2_n0;
comparator cmp6_lv3 (.in_0(lv2_n1), .in_1(lv2_n2), .out_0(lv3_n1), .out_1(lv3_n2));
comparator cmp7_lv3 (.in_0(lv2_n3), .in_1(lv2_n4), .out_0(lv3_n3), .out_1(lv3_n4));

comparator cmp8_lv4 (.in_0(lv3_n0), .in_1(lv3_n1), .out_0(lv4_n0), .out_1(lv4_n1));
comparator cmp9_lv4 (.in_0(lv3_n2), .in_1(lv3_n3), .out_0(lv4_n2), .out_1(lv4_n3));
assign lv4_n4 = lv3_n4;

// lv4_n0 <= lv4_n1 <= lv4_n2 <= lv4_n3 <= lv4_n4
assign front_pair = (lv4_n0[5:4] == lv4_n1[5:4]);
assign end_pair = (lv4_n3[5:4] == lv4_n4[5:4]);

assign same_5_err = (front_pair && end_pair && (lv4_n1 == lv4_n2) && (lv4_n2 == lv4_n3) && (lv4_n0[3:0] == lv4_n1[3:0]) && (lv4_n3[3:0] == lv4_n4[3:0]));

assign pair_2_3 = (end_pair && (lv4_n2[5:4] == lv4_n3[5:4]) && front_pair);
assign pair_3_2 = (front_pair && (lv4_n1[5:4] == lv4_n2[5:4]) && end_pair);

assign front_seq = (lv4_n0[3:0] + 1 == lv4_n1[3:0]) && (lv4_n1[3:0] + 1 == lv4_n2[3:0]);
assign end_seq = (lv4_n2[3:0] + 1 == lv4_n3[3:0]) && (lv4_n3[3:0] + 1 == lv4_n4[3:0]);

assign front_tri = (lv4_n0[3:0] == lv4_n1[3:0]) && (lv4_n1[3:0] == lv4_n2[3:0]);
assign end_tri = (lv4_n2[3:0] == lv4_n3[3:0]) && (lv4_n3[3:0] == lv4_n4[3:0]);

assign pair_1_3_1 = (lv4_n0 + 1 == lv4_n1) && (lv4_n1 == lv4_n2) && (lv4_n2 == lv4_n3) && (lv4_n3 + 1 == lv4_n4);

always_comb begin
    if(hand_err || same_5_err)
        out_data = 2'b01;
    else if(pair_2_3 && end_seq && lv4_n4[5:4] != 2'b00 && (lv4_n0[3:0] == lv4_n1[3:0]))
        out_data = 2'b10;
    else if(pair_3_2 && front_seq && lv4_n0[5:4] != 2'b00 && (lv4_n3[3:0] == lv4_n4[3:0]))
        out_data = 2'b10;
    else if(pair_1_3_1 && lv4_n1[5:4] != 2'b00)
        out_data = 2'b10;
    else if(pair_2_3 && end_tri && (lv4_n0[3:0] == lv4_n1[3:0]))
        out_data = 2'b11;
    else if(pair_3_2 && front_tri && (lv4_n3[3:0] == lv4_n4[3:0]))
        out_data = 2'b11;
    else
        out_data = 2'b00;
end

endmodule

module comparator(
    // Input signals
	in_0,
	in_1,

    // Output signals
	out_0,
	out_1
);

input [5:0] in_0, in_1;
output logic [5:0] out_0, out_1;

assign out_0 = (in_0 <= in_1) ? in_0 : in_1;
assign out_1 = (in_0 <= in_1) ? in_1 : in_0;

endmodule