

module dpa_new_1 #(
    parameter integer WIDTH   =  'd32
    // parameter OP_LEN = 5,
   // parameter  SIGNED_W = 33
) (
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    input               cin,
    // input  [OP_LEN -1 :0 ] alu_op,

    output  [WIDTH-1:0] final_sum,
    output              cout,
    output              negative_flag,
    output              overflow_flag,
    output              zero_flag
);

    // propagate and generate
    wire [WIDTH-1:0] p, g;
    wire [WIDTH-1:0] sum_zero;
    wire [WIDTH-1:0] sum_one;

    assign p = a ^ b;      // carry-propagate
    assign g = a & b;      // carry-generate

    assign sum_zero = p;       // when carry-in = 0, sum bit = p
    assign sum_one = ~p;      // when carry-in = 1, sum bit = ~p

    // carries: need WIDTH+1 bits to hold final carry-out
    reg  [WIDTH:0] c;
    reg  [WIDTH-1:0] sum;
    integer i;

    always @(*) begin : main_block
        // initialize carry in
        c[0] = cin;
        // compute carries
        for (i = 0; i < WIDTH; i = i + 1) begin
            c[i+1] = g[i] | (p[i] & c[i]);
        end
        // compute sum bits using your original selection style
        for (i = 0; i < WIDTH; i = i + 1) begin
            sum[i] = c[i] ? sum_one[i] : sum_zero[i];
        end
    end

    // final outputs (WIDTH-bit sum)
    assign final_sum     = sum;
    assign cout          = c[WIDTH];                 // final carry-out
    assign zero_flag     = (sum == {WIDTH{1'b0}});
    assign negative_flag = sum[WIDTH-1];
    // overflow: carry into MSB (c[WIDTH-1]) xor carry out (c[WIDTH])
    assign overflow_flag = c[WIDTH-1] ^ c[WIDTH];

endmodule
