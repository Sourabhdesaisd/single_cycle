module adder_top#(
           parameter integer WIDTH = 'd32,
           parameter integer OP_LEN = 'd 5
        
)
(   
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input [OP_LEN -1 :0 ] opcode,
        output reg [WIDTH-1:0] final_sum,
        output reg cout,
        output reg negative_flag,
        output reg overflow_flag,
        output reg zero_flag
);

wire [WIDTH-1:0] unsigned_o;
wire [WIDTH-1 : 0] sub_out;
wire [WIDTH-1:0] sum_sign;
wire cout_ab,neg_ab,ovf_ab,z_ab,neg_sign,z_sign,ovf_sign,cout_sign,z_sub,ovf_sub,cout_sub,neg_sub;

 /////////////////////unsigned/////////////////////////
dpa_new_1 #(.WIDTH(WIDTH)) add_un(
                              .a(a),
                              .b(b),
                              .cin(1'b0),
                              .final_sum(unsigned_o),
                              .cout(cout_ab),
                              .negative_flag(neg_ab),
                              .overflow_flag(ovf_ab),
                              .zero_flag(z_ab));

////////////////////////signed////////////////////


dpa_new_1 #(.WIDTH(WIDTH)) add_sin(
                              .a(a),
                              .b(b),
                              .cin(1'b0),
                              .final_sum(sum_sign),
                              .cout(cout_sign),
                              .negative_flag(neg_sign),
                              .overflow_flag(ovf_sign),
                              .zero_flag(z_sign));


/*dpa_new_1 #(.WIDTH(WIDTH)) add_sin(.a(~unsigned_o),
                              .b({WIDTH{1'b0}}),
                              .cin(1'b1),
                              .final_sum(sum_sing),
                              .cout(cout_sing),
                              .negative_flag(neg_sing),
                              .overflow_flag(ovf_sing),
                              .zero_flag(z_sing));*/

////////////////////////SUB//////////////////////////////


dpa_new_1 #(.WIDTH(WIDTH)) sub (.a(a),
                           .b(~b),
                           .cin(1'b1),
                           .final_sum(sub_out),
                           .cout(cout_sub),
                           .negative_flag(neg_sub),
                           .overflow_flag(ovf_sub),
                           .zero_flag(z_sub));
                          
always@(*) begin
    case(opcode)
        5'b00001 : 
                    begin
                        final_sum = unsigned_o;
                        zero_flag = z_ab;
                        overflow_flag = ovf_ab;
                        negative_flag = neg_ab;
                        cout = cout_ab;                        
                    end
 
        5'b00010 :
                    begin
                        final_sum = sum_sign;
                        zero_flag = z_sign;
                        overflow_flag = ovf_sign;
                        cout = cout_sign;
                        negative_flag = neg_sign;
                    end
        5'b00011 : 
                    begin
                        final_sum = sub_out;
                        zero_flag = z_sub;
                        overflow_flag = ovf_sub;
                        cout = cout_sub;
                        negative_flag = neg_sub;
                    end
                    default : begin
                                    final_sum = 0;
                        zero_flag = 1;
                        overflow_flag = 0;
                        cout = 0;
                        negative_flag = 0;
                                end
                   
endcase
end
endmodule       

           




