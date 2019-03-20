
//`timescale 1ns/1ps

module register_file1 #(
    parameter REG_DEPTH = 32,
    parameter REG_WIDTH = 32,
    parameter REG_ADDR_WIDTH = $clog2(REG_DEPTH)
) (
    input  clk,
    input  rst_n,

    // Write path signals
    input  [REG_ADDR_WIDTH-1:0] write_reg, // 5-bit write address(RD)
    input  reg_wr_en,                      // control signal write enable
    input  [REG_WIDTH-1:0] reg_wr_data,    // 32 bit writing into the Register file

    // Read path signals
    input  [REG_ADDR_WIDTH-1:0] reg_rd1,   // 5-bit read address1(RS1)
    input  [REG_ADDR_WIDTH-1:0] reg_rd2,   // 5-bit read address2(RS2)
    output [REG_WIDTH-1:0] reg_rd_data1, // 32-bit read data1
    output [REG_WIDTH-1:0] reg_rd_data2  // 32-bit read data2
);

    //Register file declaration    reg [REG_WIDTH-1:0] regfile [0:REG_DEPTH-1];
    reg [REG_WIDTH-1:0] regfile [0:REG_DEPTH-1];
//    logic [REG_DEPTH-1:0][REG_WIDTH-1:0] regfile;


    // Internal signals
    wire [REG_DEPTH-1:0] demux_out;
    wire [REG_WIDTH-1:0] and_out;
//    reg [REG_WIDTH-1:0] mux_out1;
//    reg [REG_WIDTH-1:0] mux_out2;



    // Demux instance for write enable decoding
    demux32_1 #(
        .NO_OF_OUTS(REG_DEPTH),
        .SELECT(REG_ADDR_WIDTH)
    ) dm (
        .demux_sel_in(write_reg),
        .demux_out(demux_out)
    );

/*
            mux32_1 #(.NO_OF_INPS(REG_DEPTH),
                .SELECT(5)
            ) m1 (
                  .mux_in(regfile[31:0]),
                  .mux_sel(reg_rd1),
                  .mux_out(reg_rd_data1)
            );

            mux32_1 #(.NO_OF_INPS(REG_DEPTH),
                .SELECT(5)
            ) m2 (
                .mux_in(regfile[31:0]),
                .mux_sel(reg_rd2),
                .mux_out(reg_rd_data2)
            );
*/
    genvar i;

    generate
        for(i=0; i<REG_DEPTH; i=i+1)
        begin
            assign and_out[i] = demux_out[i] & reg_wr_en;
        end
    endgenerate



    genvar j;

    generate
        for(j=0; j<REG_DEPTH; j=j+1)
        begin
            always@(posedge clk or negedge rst_n)
            begin
                if(!rst_n)
                    regfile[j] <= 32'b0; 
                else if(j==0)
                    regfile[j] <= 32'b0; 
                else
                begin
                    regfile[j] <= and_out[j] ? reg_wr_data : regfile[j];
                end
            end
        end
    endgenerate

/*
    always@(reg_rd1, reg_rd2)
    begin
        mux_out1 = regfile[reg_rd1];
        mux_out2 = regfile[reg_rd2];
    end
*/

    assign reg_rd_data1 = (reg_rd1 == 'd0) ? {REG_WIDTH{1'd0}} : regfile[reg_rd1];
    assign reg_rd_data2 = (reg_rd2 == 'd0) ? {REG_WIDTH{1'd0}} : regfile[reg_rd2];
    
/*
    assign reg_rd_data1 = mux_out1;
    assign reg_rd_data2 = mux_out2;
*/

endmodule

