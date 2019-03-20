

module demux32_1 #(
    parameter NO_OF_OUTS =32,
    parameter SELECT = $clog2(NO_OF_OUTS)
    ) (
    input [SELECT-1:0] demux_sel_in,
    output reg [NO_OF_OUTS-1:0] demux_out
    );

    genvar i;
    generate
        for(i=0; i<NO_OF_OUTS; i=i+1)
        begin
            always@(*)
            begin
                if(i==demux_sel_in)
                    demux_out[i] = 1'b1;
                else
                    demux_out[i] = 1'b0;
            end
        end
     endgenerate
    
   
endmodule
    
