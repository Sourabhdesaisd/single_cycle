module NAND(
          
           input [31:0]in_1,
           input [31:0]in_2,
           
           output [31:0]out_nand
         );
            

           assign out_nand = ~(in_1 & in_2);

endmodule
