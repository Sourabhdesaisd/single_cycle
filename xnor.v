module XNOR(
          
           input [31:0]in_1,
           input [31:0]in_2,
           
           output [31:0]out_xnor
         );
            

           assign out_xnor = ~(in_1 ^ in_2);

endmodule
