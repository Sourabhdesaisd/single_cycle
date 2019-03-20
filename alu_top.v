module alu_top #(parameter width = 32)
              (
               input [width - 1 : 0]in_1,
               input [width - 1 : 0]in_2,
               input [4:0]aluop,
               output reg [width - 1:0]alu_out,
               output reg negative_flag,
               output reg zero_flag,
               output reg overflow_flag,
               output reg carry_flag
               );

wire [width - 1:0] final_sum;
wire [width - 1:0] PROD_RESULT;
wire [15:0] quotient;
wire [width - 1:0] out_and;
wire [width - 1:0] out_or;
wire [width - 1:0] out_xor;
wire [width - 1:0] out_xnor;
wire [width - 1:0] out_nor;
wire [width - 1:0] out_nand;
wire [width - 1:0] out_not;
wire [width - 1:0] out_sll;
wire [width - 1:0] out_srl;
wire [width - 1:0] out_sar;
wire [width - 1:0] out_ror;
wire [width - 1:0] out_rol;
wire negative_flag_adder;
wire overflow_flag_adder;
wire zero_flag_adder;
wire carry_flag_adder;
wire neg_flag_mul;
wire zero_flag_mul;
wire zero_flag_div;
wire negative_flag_div;
wire overflow_flag_div;

adder_top adder(.final_sum(final_sum),
          .cout(carry_flag_adder),
         .a(in_1),
         .b(in_2),
         .opcode(aluop),
         .negative_flag(negative_flag_adder),
         .overflow_flag(overflow_flag_adder),
         .zero_flag(zero_flag_adder)
         );
booth16x16_top multi(
                     .PROD_RESULT(PROD_RESULT),
                     .A(in_1[15:0]),
                     .B(in_2[15:0]),
                     .alu_signed(aluop[0]),
                     .neg_flag(neg_flag_mul),
                     .zero_flag(zero_flag_mul)
                    );
                    

array_divider div(
                  .quotient(quotient),
                  .remainder(),
                  .dividend(in_1[15:0]),
                  .divisor(in_2[7:0]),
                  .ZF(zero_flag_div),
                  .NF(negative_flag_div),
                  .OF(overflow_flag_div),
                  .aluop(aluop)
                 );                    

AND gate_and(.out_and(out_and),
             .in_1(in_1),
             .in_2(in_2)
            ); 

OR gate_or(
           .out_or(out_or),
           .in_1(in_1),
           .in_2(in_2)
       ); 

XOR gate_xor( 
             .out_xor(out_xor),
             .in_1(in_1),
             .in_2(in_2)
            ); 
      
XNOR gate_xnor(
               .out_xnor(out_xnor),
               .in_1(in_1),
               .in_2(in_2)
              );       

NAND gate_nand(
               .out_nand(out_nand),
               .in_1(in_1),
               .in_2(in_2)
              );          

NOT gate_not(
             .out_not(out_not),
             .in_1(in_1)
            );

SLL gate_sll(
             .out_sll(out_sll),
             .in_1(in_1),
             .in_2(in_2)
            ); 

SRL gate_srl(
             .out_srl(out_srl),
             .in_1(in_1),
             .in_2(in_2)
            );

SAR gate_sar( 
             .out_sar(out_sar),
             .in_1(in_1),
             .in_2(in_2)
            ); 

ROL gate_rol(
             .out_rol(out_rol),
             .in_1(in_1),
             .in_2(in_2)
            ); 

ROR gate_ror(
             .out_ror(out_ror),
             .in_1(in_1),
             .in_2(in_2)
            );  
NOR gate_nor(
             .out_nor(out_nor),
             .in_1(in_1),
             .in_2(in_2)
            );

always@(*) 
begin
    case(aluop)
        5'b00001 :begin
                  alu_out = final_sum;
                  negative_flag = negative_flag_adder;
                  overflow_flag = overflow_flag_adder;
                  zero_flag = zero_flag_adder;
                  carry_flag = carry_flag_adder;
                  end 
                  
        5'b00010 :begin
                  alu_out = final_sum;
                  negative_flag = negative_flag_adder;
                  overflow_flag = overflow_flag_adder;
                  zero_flag = zero_flag_adder;
                  carry_flag = carry_flag_adder;
                  end

        5'b00011 :begin
                  alu_out = final_sum;
                  negative_flag = negative_flag_adder;
                  overflow_flag = overflow_flag_adder;
                  zero_flag = zero_flag_adder;
                  carry_flag = carry_flag_adder;
                  end

        5'b00100 :begin
                  alu_out = PROD_RESULT;
                  negative_flag = neg_flag_mul;
                  overflow_flag = 0;
                  zero_flag = zero_flag_mul;
                  carry_flag = 0;
                  end

        5'b00101 :begin
                  alu_out = PROD_RESULT;
                  negative_flag = neg_flag_mul;
                  overflow_flag = 0;
                  zero_flag = zero_flag_mul;
                  carry_flag = 0;
                  end

        5'b00110 :begin
                  alu_out = {{16{1'b0}},quotient};
                  negative_flag = negative_flag_div;
                  overflow_flag = overflow_flag_div;
                  zero_flag = zero_flag_div;
                  carry_flag = 0;
                  end

        5'b00111 :begin
                  alu_out = {{16{quotient[15]}},quotient};
                  negative_flag = negative_flag_div;
                  overflow_flag = overflow_flag_div;
                  zero_flag = zero_flag_div;
                  carry_flag = 0;
                  end

        5'b01000 :begin
                  alu_out = out_and;
                  negative_flag = (out_and[31]);
                  overflow_flag = 0;
                  zero_flag = (out_and == 0);
                  carry_flag = 0;
                  end

        5'b01001 :begin
                  alu_out = out_or;
                  negative_flag = (out_or[31]);
                  overflow_flag = 0;
                  zero_flag = (out_or == 0);
                  carry_flag = 0;
                  end
        5'b01010 :begin
                  alu_out = out_xor;
                  negative_flag = (out_xor[31]);
                  overflow_flag = 0;
                  zero_flag = (out_xor == 0);
                  carry_flag = 0;
                  end

        5'b01011 :begin
                  alu_out = out_nand;
                  negative_flag = (out_nand[31]);
                  overflow_flag = 0;
                  zero_flag = (out_nand == 0);
                  carry_flag = 0;
                  end
            
        5'b01100 :begin
                  alu_out = out_nor;
                  negative_flag = (out_nor[31]);
                  overflow_flag = 0;
                  zero_flag = (out_nor == 0);
                  carry_flag = 0;
                  end
                   
        5'b01101 :begin 
                  alu_out = out_xnor;
                  negative_flag = (out_xnor[31]);
                  overflow_flag = 0;
                  zero_flag = (out_xnor == 0);
                  carry_flag = 0;
                  end
                 
        5'b01110 :begin 
                  alu_out = out_sll;
                  negative_flag = (out_sll[31]);
                  overflow_flag = 0;
                  zero_flag = (out_sll == 0);
                  carry_flag = 0;
                  end
                  
        5'b01111 :begin
                  alu_out = out_srl;
                  negative_flag = (out_srl[31]);
                  overflow_flag = 0;
                  zero_flag = (out_srl == 0);
                  carry_flag = 0;
                  end

        5'b10000 :begin
                  alu_out = out_sar;
                  negative_flag = (out_sar[31]);
                  overflow_flag = 0;
                  zero_flag = (out_sar == 0);
                  carry_flag = 0;     
                  end

        5'b10001 :begin
                  alu_out = out_ror;
                  negative_flag = (out_ror[31]);
                  overflow_flag = 0;
                  zero_flag = (out_ror == 0);
                  carry_flag = 0;                       
                  end

        5'b10010 :begin
                  alu_out = out_rol;
                  negative_flag = (out_rol[31]);
                  overflow_flag = 0;
                  zero_flag = (out_rol == 0);
                  carry_flag = 0;   
                  end

        5'b10011 :begin
                  alu_out = out_not;
                  negative_flag = (out_not[31]);
                  overflow_flag = 0;
                  zero_flag = (out_not == 0);
                  carry_flag = 0;
                  end

         default :begin
                  alu_out = 32'd0;
                  negative_flag = 0;
                  overflow_flag = 0;
                  zero_flag = 1;
                  carry_flag = 0;
                  end
    endcase

end



endmodule



