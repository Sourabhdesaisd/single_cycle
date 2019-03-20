module AND(
          
           input [31:0]in_1,
           input [31:0]in_2,
           
           output [31:0]out_and
         );
            

           assign out_and = (in_1 & in_2);

endmodule
