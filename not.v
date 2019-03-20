module NOT(
          
           input [31:0]in_1,
           
           output [31:0]out_not
         );
            

           assign out_not = ~(in_1);

endmodule
