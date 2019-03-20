

module compressor42_vec #(
	parameter width = 32
)(
    input  wire [width-1:0] a,
    input  wire [width-1:0] b,
    input  wire [width-1:0] c,
    input  wire [width-1:0] d,
    input  wire             cin_chain,   // seed for bit 0, normally 1'b0
    output wire [width-1:0] sum,         // same weight
    output wire [width-1:0] carry        // carry row (to be interpreted as <<1)
);

    wire [width-1:0] s1;

    // Per-bit "cout" from the 4:2 (goes to cin of next higher bit)
    wire [width-1:0] cout;

    genvar i;
    generate
        for (i = 0; i < width ; i = i + 1) begin : comp_4_to_2
            wire cin_i ;//= (i == 0) ? cin_chain : cout[i-1];
	if (i == 0) begin
      		assign cin_i = cin_chain;
	 end
    	else begin
      		assign cin_i = cout[i-1];
	 end

            // First FA: a + b + c -> s1, c1
            assign s1[i]  = a[i] ^ b[i] ^ c[i];
            assign cout[i]  = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);

            // Second FA: s1 + d + cin -> sum, c2
            assign sum[i] = s1[i] ^ d[i] ^ cin_i;
            assign carry[i]  = (s1[i] & d[i]) | (s1[i] & cin_i) | (d[i] & cin_i);
        end
    endgenerate
endmodule

// ============================================================

module compressor32_vec #(
	parameter width = 32
)(
    input  wire [width-1:0] a,
    input  wire [width-1:0] b,
    input  wire [width-1:0] c,
    //input  wire [width-1:0] d,
    //input  wire             cin_chain,   // seed for bit 0, normally 1'b0
    output wire [width-1:0] sm,         // same weight
    output wire [width-1:0] cry        // carry row (to be interpreted as <<1)
);
    // Internal per-bit carries between the two adders that form the 3:2
    // wire [width-1:0] c1;

    genvar i;
    generate
        for (i = 0; i < width ; i = i + 1) begin : comp_3_to_2
            // FA: a + b + c -> s1, c1
            assign sm[i]  = a[i] ^ b[i] ^ c[i];
            assign cry[i]  = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);

         
        end
    endgenerate
endmodule

// ============================================================

module pp_tree #(
	parameter width = 32
)(
    input  wire [width-1:0] P0,  input wire [width-1:0] P1,
    input  wire [width-1:0] P2,  input wire [width-1:0] P3,
    input  wire [width-1:0] P4,  input wire [width-1:0] P5,
    input  wire [width-1:0] P6,  input wire [width-1:0] P7,
    input  wire [width-1:0] P8,
    output wire [width-1:0] s_u_m,     
    output wire [width-1:0] c_arr_y
);
    wire [width-1:0] c0, c00, c1, s0, s00, s1;

    // ---------------- Stage 1 ----------------
    wire [width-1:0] cl0, cl00;
    wire [width-1:0] cl1;
    wire oneBitZero;

    assign oneBitZero = 1'b0;

    compressor42_vec #(
	.width(width)
) S1_0 (
        .a(P0), .b(P1), .c(P2), .d(P3),
        .cin_chain(oneBitZero),
        .sum(s00), .carry(c00)
    );
    compressor42_vec #(
	.width(width)
) S1_1 (
        .a(P4), .b(P5), .c(P6), .d(P7),
        .cin_chain(oneBitZero),
        .sum(s1), .carry(c1)
    );

    assign cl00 = (c00 << 1);
    compressor32_vec #(
	.width(width)
) S1_FINAL (
        .a(s00), .b(cl00), .c(P8),
        .sm(s0), .cry(c0)
    );

    // ---------------- Stage 2 ----------------
    // Final reduction: {s0,c0,s1,c1} -> SUM, CARRY
    assign cl1 = (c1 << 1);
    assign cl0 = (c0 << 1);
    compressor42_vec  #(
	.width(width) 
) S2_FINAL (
        .a(s0), .b(cl0), .c(s1), .d(cl1),
        .cin_chain(oneBitZero),
        .sum(s_u_m), .carry(c_arr_y)
    );

endmodule

