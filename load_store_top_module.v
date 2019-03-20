module 	load_store_top_module 		(

						input [31:0] data_from_rs1 		,
						input [31:0] data_from_rs2 		,
						input [31:0] PC 			,
						input [13:0] immediate 			,
                        input [7:0] from_alu_out    ,
						input [1:0] BC 				,
						input [1:0] OPCODE 			,
				
						input CT 				,
						input sel_pc 				,
						input sel_rs1 				,
						input sel_rs2 				,
						input sel_ex 				,
						input sel_imm_1 			,
						input sel_imm_2 			,
						input sel_hw 				,
						input sel_w 				,

						input ld_mem_reg 			,
						input ld_mar 				,
						input ld_mdr 				,

						output [31:0] data_in_for_register_file ,
                        output [31:0] to_alu_in_1   ,
                        output [31:0] to_alu_in_2    

					    ) ;


wire 	[7:0] 		mar_in 		;
wire 	[7:0] 		mar_out 	;
wire 	[31:0] 		MEM_OUT 	;
wire 	[31:0] 		mdr_in 		;
wire 	[31:0] 		mdr_out	;
wire    [31:0]      mdr_to_reg_out ;
wire    [31:0]      load_imm_to_reg ;


mar_logic 		mar_logic_instance			(

								.data_from_rs1(data_from_rs1) 	,
								.PC(PC) 	 		,
								.data_from_rs2(data_from_rs2) 	,
								.immediate(immediate) 		,
                                .from_alu_out(from_alu_out) ,
								.sel_pc(sel_pc) 		,
								.sel_rs2(sel_rs2) 		,
								.sel_imm_1(sel_imm_1)		,
								.sel_imm_2(sel_imm_2)		,
								.sel_rs1(sel_rs1)		,
                                .sel_ex(sel_ex)             ,
								.out(mar_in) ,
                                .to_alu_in_1(to_alu_in_1) ,
                                .to_alu_in_2(to_alu_in_2)   
	
								) ;


MAR_register 		MAR_register_instance	 		(

								.ld_mar(ld_mar) 		,
								.mar_in(mar_in) 		,
								.mar_out(mar_out)

								);


memory_top         mem_top_instance                    (
        
                                 .data_in(mdr_out) ,
                                 .MAR(mar_out) ,
                                 .BC(BC) ,
                                 .CT(CT) ,
                                 .opcode(OPCODE) ,
                                 .MEM_OUT(MEM_OUT)

                            );




mux_21_32 		mux_1_instance 				(

								.a(MEM_OUT)			,
								.b(data_from_rs2) 		,
								.sel(CT) 			,
								.out(mdr_in) 

				) ;


MDR_register 		MDR_register_instance 			(

								.ld_mdr(ld_mdr) 		,
								.mdr_in(mdr_in) 		,
								.mdr_out(mdr_out)

								);

mdr_to_reg 		mdr_to_reg_instance			(

								.MDR(mdr_out) 			,
								.MAR(mar_out[1:0])		,
								.sel_ex(sel_ex)			,
								.sel_hw(sel_hw)			,
								.sel_w(sel_w) 			,
								.mdr_to_reg_out(mdr_to_reg_out)

								) ;



load_immediate_logic 	load_immediate_logic_instance 		(

								.immediate(immediate) 		,
								.sel_ex(sel_ex) 		,
								.load_imm_to_reg(load_imm_to_reg)  

								) ;



mux_21_32 mux_20 (

                    .a(load_imm_to_reg) ,
                    .b(mdr_to_reg_out) ,
                    .sel(ld_mem_reg) ,
                    .out(data_in_for_register_file));


endmodule

//test_bench



module top_module_tb ;

reg [31:0] data_from_rs1 ;
reg [31:0] data_from_rs2 ;
reg [31:0] PC ;
reg [13:0] immediate ;
reg [1:0] BC ;
reg [1:0] OPCODE ;
reg [7:0] from_alu_out ;	

reg CT ;
reg sel_pc ;
reg sel_rs1 ;
reg sel_rs2 ;
reg sel_ex ;
reg sel_imm_1 ;
reg sel_imm_2 ;
reg sel_hw ;
reg sel_w ;

reg ld_mem_reg ;
reg ld_mar ;
reg ld_mdr ;

wire [31:0] data_in_for_register_file ;
wire [31:0] to_alu_in_1 ;
wire [31:0] to_alu_in_2 ;


load_store_top_module 	top_module_tb			(


						.data_from_rs1(data_from_rs1) ,
						.data_from_rs2(data_from_rs2) ,
						.PC(PC) ,
						.immediate(immediate) ,
						.BC(BC) ,
						.OPCODE(OPCODE) ,
				        .from_alu_out(from_alu_out) ,

						.CT(CT) ,
						.sel_pc(sel_pc) ,
						.sel_rs1(sel_rs1) ,
						.sel_rs2(sel_rs2) ,
						.sel_ex(sel_ex)  ,
						.sel_imm_1(sel_imm_1) ,
						.sel_imm_2(sel_imm_2) ,
						.sel_hw(sel_hw) ,
						.sel_w(sel_w) ,

						.ld_mem_reg(ld_mem_reg) ,
						.ld_mar(ld_mar) ,
						.ld_mdr(ld_mdr) ,

						.data_in_for_register_file(data_in_for_register_file) , 
                        .to_alu_in_1(to_alu_in_1) ,
                        .to_alu_in_2(to_alu_in_2)


					) ;



initial begin

$shm_open("wave.shm") ;
$shm_probe("ACTMF") ;

end


initial begin

BC = 2'b01 ;
CT = 1 ;

//SW instruction stores value of RS2 to addressing of RS1

data_from_rs1 = 0 ;
data_from_rs2 = 32'h1357_2468 ;
PC = 32 ;
immediate = 16 ;
from_alu_out = 0;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 0 ;	
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 1 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SHl instruction stores lower halfword value of RS2 to addressing of RS1

data_from_rs1 = 4 ;
data_from_rs2 = 32'hF432_1DC3 ;
PC = 32 ;
immediate = 16 ;
from_alu_out = 8;
OPCODE = 2'b01 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 1 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5



//SB instruction store byte value of RS2 to addressing of RS1

data_from_rs1 = 7 ;
data_from_rs2 = 32'h1576_FCD1 ;
PC = 32 ;
immediate = 16 ;
from_alu_out = 14;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 1 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SHU instruction store upper halfword value of RS2 to addressing of RS1

data_from_rs1 = 8 ;
data_from_rs2 = 32'hFE12_34CD ;
PC = 32 ;
immediate = 16 ;
from_alu_out = 16;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 1 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SWP instruction stores value of RS2 to addressing of ( PC +RS1 )

data_from_rs1 = 0 ;
data_from_rs2 = 32'h12F1_DC32 ;
PC = 12 ;
immediate = 16 ;
from_alu_out = 12;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SHLP instruction stores lower halfword value of RS2 to addressing of PC+RS1

data_from_rs1 = 4 ;
data_from_rs2 = 32'hDC15_7845 ;
PC = 12 ;
immediate = 16 ;
from_alu_out = 16;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SBP instruction stores byte value of RS2 to addressing of PC+RS1

data_from_rs1 = 8;
data_from_rs2 = 32'hABCD_1675 ;
PC = 12 ;
immediate = 16 ;
from_alu_out = 20;
OPCODE = 2'b10 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SHUP instruction stores upper halfword value of RS1 to addressing of PC + RS2

data_from_rs1 = 10 ;
data_from_rs2 = 32'h13F6_AC13 ;
PC = 12 ;
immediate = 16 ;
from_alu_out = 22 ;
OPCODE = 2'b11 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SWPO instruction stores word value of RS2 to addressing of (PC+imm)

data_from_rs1 = 0 ;
data_from_rs2 = 32'h3514_B1DF ;
PC = 12 ;
immediate = 12 ;
from_alu_out = 24;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SHLPO instruction stores lower halfword value of RS2 to addressing of (PC+imm)

data_from_rs1 = 0 ;
data_from_rs2 = 32'hA786_C123 ;
PC = 12 ;
immediate = 16 ;
from_alu_out = 28;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SBPO instruction stores byte value of RS2 to addressing of (pc +imm)

data_from_rs1 = 0 ;
data_from_rs2 = 32'h1289_2134 ;
PC = 12 ;
immediate = 20 ;
from_alu_out = 32;
OPCODE = 2'b10 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SHUPO instruction stores upper halfword value of RS2 to addressing of (PC + imm )

data_from_rs1 = 0 ;
data_from_rs2 = 32'hEBA0_9865 ;
PC = 12 ;
immediate = 26 ;
from_alu_out = 38;
OPCODE = 2'b11 ;
sel_pc = 1 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SWD instruction stores wordvalue of RS2 to addressing of imm

data_from_rs1 = 0 ;
data_from_rs2 = 32'h12EF_AB32 ;
PC = 32 ;
immediate = 40 ;
from_alu_out = 40;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SHLD instruction stores lower halfword value of RS2 to addressing of imm

data_from_rs1 = 0 ;
data_from_rs2 = 32'h12AB_CD32 ;
PC = 32 ;
immediate = 46 ;
from_alu_out = 46;
OPCODE = 2'b01 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SBD instruction stores byte value of RS2 to addressing of imm

data_from_rs1 = 0 ;
data_from_rs2 = 32'h12CD_EFBF ;
PC = 32 ;
immediate = 48 ;
from_alu_out = 48;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SHUD instruction stores wordvalue of RS2 to addressing of imm

data_from_rs1 = 0 ;
data_from_rs2 = 32'h11EF_AB42 ;
PC = 32 ;
immediate = 50 ;
from_alu_out = 50;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SWRO instruction stores word value of RS2 to addressing of (RS1+imm)

data_from_rs1 = 30 ;
data_from_rs2 = 32'hDE12_AB21 ;
PC = 32 ;
immediate = 22 ;
from_alu_out = 52;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SHLRO instruction stores word value of RS2 to addressing of (RS1+imm)

data_from_rs1 = 30 ;
data_from_rs2 = 32'hDE13_AB22 ;
PC = 32 ;
immediate = 26 ;
from_alu_out = 56;
OPCODE = 2'b01 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


//SBRO instruction stores word value of RS2 to addressing of (RS1+imm)

data_from_rs1 = 30 ;
data_from_rs2 = 32'hDE14_AB24 ;
PC = 32 ;
immediate = 29 ;
from_alu_out = 59;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//SHURO instruction stores word value of RS2 to addressing of (RS1 + imm)

data_from_rs1 = 30 ;
data_from_rs2 = 32'hAB12_CD21 ;
PC = 32 ;
immediate = 30 ;
from_alu_out = 60;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 0 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

//load instructions


BC = 2'b01 ;
CT = 0 ;


// LW instruction load word from address of (RS1 + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 32 ;
immediate = 28 ;
from_alu_out = 0;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LH instruction load sign extended halfword from address of (RS1 + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 32 ;
immediate = 28 ;
from_alu_out = 0;
OPCODE = 2'b01 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LHU instruction load zero extended halfword from address of (RS1 + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 32 ;
immediate = 28 ;
from_alu_out = 0;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LB instruction load sign extended BYTE from address of (RS1 + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 32 ;
immediate = 28 ;
from_alu_out = 0;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LBU instruction load zero extended BYTE from address of (RS1 + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 32 ;
immediate = 28 ;
from_alu_out = 0;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LWP instruction load word from address of (PC + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 8 ;
immediate = 28 ;
from_alu_out = 12;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LHP instruction load sign extended halfword from address of (PC + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 8 ;
immediate = 28 ;
from_alu_out = 12;
OPCODE = 2'b10 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LHUP instruction load zero extended halfword from address of (PC + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 8 ;
immediate = 28 ;
from_alu_out = 12;
OPCODE = 2'b11 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBP instruction load sign extended byte from address of (PC + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 8 ;
immediate = 28 ;
from_alu_out = 12;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBUP instruction load zero extended byte from address of (PC + RS2)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 8 ;
immediate = 28 ;
from_alu_out = 12;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LI instruction load immediate with sign extention

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 4 ;
immediate = 14'b11_1000_0000_1010 ;
from_alu_out = 0;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 1 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LIU instruction load immediate with zero extention

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 4 ;
immediate = 14'b11_1000_0000_1010 ;
from_alu_out = 0;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 0 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 1 ;
ld_mem_reg = 0 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LWPO instruction load word from address of (PC + imm)

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 12 ;
immediate = 8 ;
from_alu_out = 20;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LHPO instruction load sign extended halfword from address of (PC + imm)

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 12 ;
immediate = 8 ;
from_alu_out = 20;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LHUPO instruction load zero extended halfword from address of (PC + imm)

data_from_rs1 = 0 ;
data_from_rs2 = 8 ;
PC = 12 ;
immediate = 8 ;
from_alu_out = 20;
OPCODE = 2'b10 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBPO instruction load sign extended byte from address of (PC + imm)

data_from_rs1 = 0 ;
data_from_rs2 = 12 ;
PC = 12 ;
immediate = 8 ;
from_alu_out = 20;
OPCODE = 2'b11 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBUP instruction load zero extended byte from address of (PC + imm)

data_from_rs1 = 0 ;
data_from_rs2 = 16 ;
PC = 12 ;
immediate = 8 ;
from_alu_out = 20;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LWD instruction load word from address of  imm

data_from_rs1 = 0 ;
data_from_rs2 = 0 ;
PC = 4 ;
immediate = 28 ;
from_alu_out = 32;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LHD instruction load sign extended halfword from address of  imm

data_from_rs1 = 0 ;
data_from_rs2 = 4 ;
PC = 4 ;
immediate = 28 ;
from_alu_out = 32;
OPCODE = 2'b10 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LHUD instruction load zero extended halfword from address of  imm

data_from_rs1 = 0 ;
data_from_rs2 = 8 ;
PC = 4 ;
immediate = 28 ;
from_alu_out = 32;
OPCODE = 2'b11 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBD instruction load sign extended byte from address of imm

data_from_rs1 = 0 ;
data_from_rs2 = 12 ;
PC = 4 ;
immediate = 28 ;
from_alu_out = 32;
OPCODE = 2'b00 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBUD instruction load zero extended byte from address of imm

data_from_rs1 = 0 ;
data_from_rs2 = 16 ;
PC = 4 ;
immediate = 28 ;
from_alu_out = 32;
OPCODE = 2'b01 ;
sel_pc = 1 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 1 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LWRO instruction load word from address of (RS1 + imm)

data_from_rs1 = 40 ;
data_from_rs2 = 0 ;
PC = 4 ;
immediate = 8 ;
from_alu_out = 48;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 1 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LHRO instruction load sign extended halfword from address of (RS1 + imm)

data_from_rs1 = 40 ;
data_from_rs2 = 4 ;
PC = 4 ;
immediate = 8 ;
from_alu_out = 48;
OPCODE = 2'b11 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5


// LHURO instruction load zero extended halfword from address of (RS1 + imm)

data_from_rs1 = 40 ;
data_from_rs2 = 8 ;
PC = 4 ;
immediate = 8 ;
from_alu_out = 48;
OPCODE = 2'b00 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 1 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBRO instruction load sign extended byte from address of (RS1 + imm)

data_from_rs1 = 40 ;
data_from_rs2 = 12 ;
PC = 4 ;
immediate = 8 ;
from_alu_out = 48;
OPCODE = 2'b01 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 0 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

// LBURO instruction load zero extended byte from address of (RS1 + imm)

data_from_rs1 = 40 ;
data_from_rs2 = 16 ;
PC = 4 ;
immediate = 8 ;
from_alu_out = 48;
OPCODE = 2'b10 ;
sel_pc = 0 ;
sel_rs2 = 1 ;
sel_imm_1 = 1 ;
sel_imm_2 = 0 ;
sel_rs1 = 0 ;
sel_ex = 1 ;
sel_hw = 0 ;
sel_w = 0 ;
//ld_imm_reg = 0 ;
ld_mem_reg = 1 ;
ld_mar = 1 ;
ld_mdr =1 ;#5

$finish ;

end

endmodule


