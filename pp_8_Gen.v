

    module booth_radix4_multiplier (
    input  [15:0] A,     // Multiplicand
    input  [15:0] B,     // Multiplier
    input         alu_signed, // 1 = signed, 0 = unsigned
    output reg	  neg_flag,
    output 	  zero_flag,
    output [31:0] PP0, PP1, PP2, PP3,
    output [31:0] PP4, PP5, PP6, PP7,
    output [31:0] PP8
);

    // Extended multiplier (conditionally signed or unsigned)
    reg [18:0] B_ext;
    reg [1:0] sign, usign;
    reg extend;

    assign zero_flag = ((A || B) == 0) ? 1'b1 : 1'b0 ;

    always @(*) begin
	extend = 1'b0;
    	sign = {2{B[15]}};
    	usign = 2'b00; 
        if (alu_signed == 1'b1) begin
            // Signed extension for negative numbers
            B_ext = {sign, B, extend};   // {sign, B, 0}
	    neg_flag = B[15] ^ A[15];

        end else begin
            // Unsigned extension with 0
            B_ext = {usign, B, extend};   // {0, B, 0}
        end
    end

    reg [31:0] partial [8:0];
    integer i;

    always @(*) begin
        for (i = 0; i < 9; i = i + 1) begin
            case (B_ext[2*i +: 3]) // Take 3-bit group
                3'b000, 3'b111: partial[i] = 32'b0;                     // 0 × A
                3'b001, 3'b010: partial[i] = {{16{A[15]}}, A} << (2*i); // +1 × A
                3'b011:         partial[i] = {{32{A[15]}}, A} << (2*i+1); // +2 × A
                3'b100:         partial[i] = -({{16{A[15]}}, A} << (2*i+1)); // -2 × A
                3'b101, 3'b110: partial[i] = -({{16{A[15]}}, A} << (2*i));   // -1 × A
                default:        partial[i] = 32'b0;
            endcase
        end
    end
  

    // Assign outputs to Wallace Tree inputs
    assign PP0  = partial[0];
    assign PP1  = partial[1];
    assign PP2  = partial[2];
    assign PP3  = partial[3];
    assign PP4  = partial[4];
    assign PP5  = partial[5];
    assign PP6  = partial[6];
    assign PP7  = partial[7];
    assign PP8  = partial[8];

endmodule

