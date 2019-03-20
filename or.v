module OR(
          
           input [31:0]in_1,
           input [31:0]in_2,
           
           output [31:0]out_or
         );
            

           assign out_or = (in_1 | in_2);

endmodule
