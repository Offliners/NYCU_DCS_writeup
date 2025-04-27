module Sort(
    // Input signals
	in_num0,
	in_num1,
	in_num2,
	in_num3,
	in_num4,
    
	// Output signals
	out_num
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input  [5:0] in_num0, in_num1, in_num2, in_num3, in_num4;
output logic [5:0] out_num;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [5:0] lv0_n0, lv0_n1, lv0_n2, lv0_n3, lv0_n4;
logic [5:0] lv1_n0, lv1_n1, lv1_n2, lv1_n3, lv1_n4;
logic [5:0] lv2_n0, lv2_n1, lv2_n2, lv2_n3, lv2_n4;
logic [5:0] lv3_n0, lv3_n1, lv3_n2, lv3_n3, lv3_n4;
logic [5:0] lv4_n0, lv4_n1, lv4_n2, lv4_n3, lv4_n4;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
comparator comp_lv0_0(.in_0(in_num0), .in_1(in_num1), .out_0(lv0_n0), .out_1(lv0_n1));
comparator comp_lv0_1(.in_0(in_num2), .in_1(in_num3), .out_0(lv0_n2), .out_1(lv0_n3));
assign lv0_n4 = in_num4;

comparator comp_lv1_0(.in_0(lv0_n1), .in_1(lv0_n2), .out_0(lv1_n1), .out_1(lv1_n2));
comparator comp_lv1_1(.in_0(lv0_n3), .in_1(lv0_n4), .out_0(lv1_n3), .out_1(lv1_n4));
assign lv1_n0 = lv0_n0;

comparator comp_lv2_0(.in_0(lv1_n0), .in_1(lv1_n1), .out_0(lv2_n0), .out_1(lv2_n1));
comparator comp_lv2_1(.in_0(lv1_n2), .in_1(lv1_n3), .out_0(lv2_n2), .out_1(lv2_n3));
assign lv2_n4 = lv1_n4;

comparator comp_lv3_0(.in_0(lv2_n1), .in_1(lv2_n2), .out_0(lv3_n1), .out_1(lv3_n2));
comparator comp_lv3_1(.in_0(lv2_n3), .in_1(lv2_n4), .out_0(lv3_n3), .out_1(lv3_n4));
assign lv3_n0 = lv2_n0;

comparator comp_lv4_0(.in_0(lv3_n0), .in_1(lv3_n1), .out_0(lv4_n0), .out_1(lv4_n1));
comparator comp_lv4_1(.in_0(lv3_n2), .in_1(lv3_n3), .out_0(lv4_n2), .out_1(lv4_n3));
assign lv4_n4 = lv3_n4;

assign out_num = lv4_n2;

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