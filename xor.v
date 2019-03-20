module XOR(
          
           input [31:0]in_1,
           input [31:0]in_2,
           
           output [31:0]out_xor
         );
            

           assign out_xor = in_1  ^ in_2;

endmodule

