module cpu#(
           parameter width = 32)        
           (
           input clk,
           input rst,
           input reg_rd1,
           input reg_rd2,
           input  [width-1:0] write_reg, // 5-bit write address(RD)
           input  reg_wr_en,
           output [width-1 :0] alu_out,
           output negative_flag,
           output overflow_flag,
           output zero_flag,
           output carry_flag

          );
wire [width-1 :0] reg_rd_data1;
wire [width-1 :0] reg_rd_data2;
wire reg_wr_data;
register_file1 register (
                         .clk(clk),
                         .rst_n(rst),
                         .write_reg(write_reg),
                         .reg_wr_en(reg_wr_en),
                         .reg_wr_data(reg_wr_data),
                         .reg_rd1(reg_rd1),
                         .reg_rd2(reg_rd2),
                         .reg_rd_data1(reg_rd_data1),
                         .reg_rd_data2(reg_rd_data2)
                        );

alu_top alu(
            .in_1(reg_rd_data1),
            .in_2(reg_rd_data2),
            .aluop(aluop),
            .alu_out(alu_out),
            .negative_flag(negative_flag),
            .zero_flag(zero_flag),
            .overflow_flag(overflow_flag),
            .carry_flag(carry_flag)
            );

endmodule
