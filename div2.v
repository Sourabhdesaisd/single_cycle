module array_divider (
    input  [15:0] dividend,
    input  [7:0]  divisor,
    input  [4:0]  aluop,        // 5-bit ALU opcode
    output [15:0] quotient,
    output [7:0]  remainder,
    output        ZF,            // Zero flag
    output        NF,            // Negative flag
    output        OF             // Overflow flag
);

    // ALU opcodes
    localparam ALU_DIVU = 5'b00110;  // unsigned division
    localparam ALU_DIVS = 5'b00111;  // signed division

    // Internal variables
    reg [15:0] q;
    reg [8:0]  r;               // one extra bit for compare/subtract
    reg [15:0] abs_dividend;
    reg [7:0]  abs_divisor;
    reg        sign_dividend, sign_divisor, sign_quotient;
    reg        zf_reg, nf_reg, of_reg;
    integer i;

    always @(*) begin
        // defaults
        q = 16'd0;
        r = 9'd0;
        abs_dividend = 16'd0;
        abs_divisor  = 8'd0;
        sign_dividend = 1'b0;
        sign_divisor  = 1'b0;
        sign_quotient = 1'b0;
        zf_reg = 1'b0;
        nf_reg = 1'b0;
        of_reg = 1'b0;

        // Signed mode flags only when ALU_DIVS selected
        sign_dividend = ((aluop == ALU_DIVS) && dividend[15]);
        sign_divisor  = ((aluop == ALU_DIVS) && divisor[7]);

        // Take absolute values
        abs_dividend  = sign_dividend ? (~dividend + 1'b1) : dividend;
        abs_divisor   = sign_divisor  ? (~divisor  + 1'b1) : divisor;

        // Divide by zero
        if (divisor == 8'd0) begin
            q = 16'hFFFF;
            r = {1'b0, dividend[7:0]};
            zf_reg = 1'b1;   // Zero flag on divide by zero
            nf_reg = 1'b0;
            of_reg = 1'b0;
        end
        else if ((aluop == ALU_DIVU) || (aluop == ALU_DIVS)) begin
            // Division loop
            for (i = 15; i >= 0; i = i - 1) begin
                r = {r[7:0], abs_dividend[i]};
                if (r >= {1'b0, abs_divisor}) begin
                    r = r - {1'b0, abs_divisor};
                    q[i] = 1'b1;
                end else begin
                    q[i] = 1'b0;
                end
            end

            // Signed division: restore signs
            if (aluop == ALU_DIVS) begin
                sign_quotient = sign_dividend ^ sign_divisor;
                if (sign_quotient)
                    q = ~q + 1'b1;
                if (sign_dividend)
                    r = ~r + 1'b1;

                // Overflow check: only -32768 / -1
                if ((dividend == 16'h8000) && (divisor == 8'hFF))
                    of_reg = 1'b1;
            end

            // Set flags
            zf_reg = (q == 16'd0);
            nf_reg = (aluop == ALU_DIVS) ? q[15] : 1'b0;
        end
        else begin
            q = 16'd0;
            r = 9'd0;
            zf_reg = 1'b1;
            nf_reg = 1'b0;
            of_reg = 1'b0;
        end
    end

    assign quotient  = q;
    assign remainder = r[7:0];
    assign ZF        = zf_reg;
    assign NF        = nf_reg;
    assign OF        = of_reg;

endmodule

 
