module SAR ( 

                input [31:0] in_1 ,
                input [31:0] in_2 ,

                output [31:0] out_sar

            ) ;

wire [30:0] temp = in_2[30:0] >> in_2 ;

assign out_sar = {in_1[31:0],temp} ;

        endmodule

