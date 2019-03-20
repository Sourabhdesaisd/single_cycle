module SLL ( 

                input [31:0] in_1 ,
                input [31:0] in_2 ,

                output [31:0] out_sll

            ) ;


            assign out_sll = in_1 << in_2 ;

        endmodule

/*
        module tb ;

        reg [31:0] in_1,in_2;
        wire [31:0] out ;


        SLL SLL_tb ( .in_1(in_1) , . in_2(in_2) , . out(out));

        initial begin
            $shm_open("wave.shm");
            $shm_probe("ACTMF");
        end

        initial begin

            in_1 = 32'b1000_1100_0011_0000_1101_0111_0110_0011;
            in_2 = 2;#5

            in_2 = 4;#5
            
            in_2 = 5;#5

            in_2 = 7;#5
            
            in_2 = 8;#5

            in_2 = 10;#5
            
            in_2 = 12;#5

            in_2 = 14;#5
            
            in_2 = 15;#5

            in_2 = 17;#5
            
            in_2 = 18;#5

            in_2 = 20;#5
            
            in_2 = 22;#5

            in_2 = 24;#5
            
            in_2 = 25;#5

            in_2 = 27;#5
            
            in_2 = 28;#5

            in_2 = 30;#5
            
            in_2 = 31;#5

            in_2 = 32;#5
            
            in_2 = 35;#5

            in_2 = 77;#5
            
            in_2 = 98;#5

            in_2 = 410;#5

            $finish;

        end

        endmodule


*/





