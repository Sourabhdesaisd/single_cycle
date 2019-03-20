

// 32-bit Carry Lookahead Adder
module cla_32bit (
    input  [31:0] A,
    input  [31:0] B,
    input         Cin,
    output [31:0] Sum,
    output        Cout
);

    wire [31:0] G, P;     // Generate & Propagate
    wire [32:0] C;        // Carry bits

    assign C[0] = Cin;

    // Generate & Propagate for each bit
    assign G = A & B;
    assign P = A ^ B;

    // Carry lookahead logic
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : CLA_LOOP
            assign C[i+1] = G[i] | (P[i] & C[i]);
            assign Sum[i] = P[i] ^ C[i];
        end
    endgenerate

    assign Cout = C[32];

endmodule
