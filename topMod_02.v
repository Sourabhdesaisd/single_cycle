

module booth16x16_top #(
	parameter width = 32
)(
    input   [15:0] A,
    input   [15:0] B,
    input          alu_signed,   // 1 = signed, 0 = unsigned
    output neg_flag,
    output zero_flag,
    output [width-1:0] PROD_RESULT      // lower 32 bits
);

    // -------------------------
    // Stage 1: Booth Encoder
    // -------------------------
    wire [width-1:0] PP0, PP1, PP2, PP3;
    wire [width-1:0] PP4, PP5, PP6, PP7, PP8;
//    wire neg_flag;
//    wire zero_flag;

    booth_radix4_multiplier booth_enc (
        .A(A),
        .B(B),
        .alu_signed(alu_signed),
	.neg_flag(neg_flag), 
	.zero_flag(zero_flag),
        .PP0(PP0),   .PP1(PP1),   .PP2(PP2),   .PP3(PP3),
        .PP4(PP4),   .PP5(PP5),   .PP6(PP6),   .PP7(PP7),
        .PP8(PP8)
    );

    // -------------------------
    // Stage 2: Reduction Tree
    // -------------------------
    wire [width-1:0] s_um, c_arry;

    pp_tree #( .width(width) ) tree (
        .P0(PP0), .P1(PP1), .P2(PP2), .P3(PP3),
        .P4(PP4), .P5(PP5), .P6(PP6), .P7(PP7),
        .P8(PP8),
        .s_u_m(s_um), .c_arr_y(c_arry)
    );

    // -------------------------
    // Stage 3: Final CPA (CLA)
    // -------------------------
    wire        Cout;
    wire cin;
    wire [width:0] cry_sh;
    assign cry_sh = (c_arry << 1);
    assign cin = 1'b0;

    cla_32bit cla (
        .A(s_um),
        .B(cry_sh[31:0]), // carry row shifted left
        .Cin(cin),
        .Sum(PROD_RESULT),
        .Cout(Cout)
    );

endmodule

