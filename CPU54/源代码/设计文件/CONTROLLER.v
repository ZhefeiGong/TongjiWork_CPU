`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.26 - 2022.7.26
//@function : 产生各种控制信号（核心连接部件）
module CONTROLLER(

    input clk,
    input rst,
    input ena,

    // IMEM
    input [31:0]IM_instruction,
    output [31:0]IM_addr,
    
    // ALU
    output [31:0]ALU_a,         
    output [31:0]ALU_b,         
    input [31:0] ALU_r,
    input ALU_Zero,
    input ALU_Negative,
    output [3:0]ALU_aluc,    

    // RegFiles
    output [4:0] RF_waddr,    
    output [31:0] RF_wdata,
    output [4:0] RF_rsc,
    output [4:0] RF_rtc,
    input [31:0] RF_rdata1,
    input [31:0] RF_rdata2,
    output RF_we,   
    
    // DMEM
    input [31:0]DM_data_out,
    output [1:0]DM_SIZE,
    output DM_ENA,              
    output DM_WENA,
    output [31:0] DM_data_in,
    output [31:0] DM_addr_in,                 
    
    // CP0
    input [31:0]cp0_out,
    input [31:0]epc_out,
    output [31:0]CP0_Pc,
    output [4:0]CP0_Addr,
    output [31:0]CP0_Wdata,
    output mfc0,
    output mtc0,
    output exception,
    output eret,
    output [4:0]cause

    // for test
    /*, output T1,
    output T2,
    output T3,
    output T4,
    output T5,
    output Busy_Div_test,
    output Busy_Divu_test,
    output Start_Div_test,
    output Start_Divu_test,
    output HI_EN_test,
    output LO_EN_test,
    output [31:0]IR_instruction_test*/


    );


parameter [31:0]EXCEPTION_ADDR = 32'h00400004;
parameter [4:0]JAL_ADDR = 31;

assign DM_ENA = 1'b1;


//----------------------------------参数初始化----------------------------------
wire [31:0]IR_instruction;
assign CP0_Addr = IR_instruction[15:11];
assign RF_rsc = IR_instruction[25:21];
assign RF_rtc = IR_instruction[20:16];

//--------------------------------指令标志初始化--------------------------------
wire  cpu_ADD = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100000)? 1'b1:1'b0;
wire  cpu_ADDU = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100001)? 1'b1:1'b0;
wire  cpu_SUB = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100010)? 1'b1:1'b0;
wire  cpu_SUBU = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100011)? 1'b1:1'b0;
wire  cpu_AND = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100100)? 1'b1:1'b0;
wire  cpu_OR = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100101)? 1'b1:1'b0;
wire  cpu_XOR = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100110)? 1'b1:1'b0;
wire  cpu_NOR = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b100111)? 1'b1:1'b0;
wire  cpu_SLT = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b101010)? 1'b1:1'b0;
wire  cpu_SLTU = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b101011)? 1'b1:1'b0;
wire  cpu_SLL = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000000)? 1'b1:1'b0;
wire  cpu_SRL = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000010)? 1'b1:1'b0;
wire  cpu_SRA = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000011)? 1'b1:1'b0;
wire  cpu_SLLV = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000100)? 1'b1:1'b0;
wire  cpu_SRLV = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000110)? 1'b1:1'b0;
wire  cpu_SRAV = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b000111)? 1'b1:1'b0;
wire  cpu_JR = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b001000)? 1'b1:1'b0;

wire  cpu_ADDI = (IR_instruction[31:26]==6'b001000)? 1'b1:1'b0;
wire  cpu_ADDIU = (IR_instruction[31:26]==6'b001001)? 1'b1:1'b0;
wire  cpu_ANDI = (IR_instruction[31:26]==6'b001100)? 1'b1:1'b0;
wire  cpu_ORI = (IR_instruction[31:26]==6'b001101)? 1'b1:1'b0;
wire  cpu_XORI = (IR_instruction[31:26]==6'b001110)? 1'b1:1'b0;
wire  cpu_LW = (IR_instruction[31:26]==6'b100011)? 1'b1:1'b0;
wire  cpu_SW = (IR_instruction[31:26]==6'b101011)? 1'b1:1'b0;
wire  cpu_BEQ = (IR_instruction[31:26]==6'b000100)? 1'b1:1'b0;
wire  cpu_BNE = (IR_instruction[31:26]==6'b000101)? 1'b1:1'b0;
wire  cpu_SLTI = (IR_instruction[31:26]==6'b001010)? 1'b1:1'b0;
wire  cpu_SLTIU = (IR_instruction[31:26]==6'b001011)? 1'b1:1'b0;
wire  cpu_LUI = (IR_instruction[31:26]==6'b001111)? 1'b1:1'b0;
wire  cpu_J = (IR_instruction[31:26]==6'b000010)? 1'b1:1'b0;
wire  cpu_JAL = (IR_instruction[31:26]==6'b000011)? 1'b1:1'b0;

wire  cpu_CLZ = (IR_instruction[31:26]==6'b011100&&IR_instruction[5:0]==6'b100000)? 1'b1:1'b0;
wire  cpu_DIVU = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b011011)? 1'b1:1'b0;
wire  cpu_ERET = (IR_instruction[31:0] ==32'b01000010000000000000000000011000)? 1'b1:1'b0;
wire  cpu_JALR = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b001001)? 1'b1:1'b0;
wire  cpu_LB = (IR_instruction[31:26]==6'b100000)? 1'b1:1'b0;
wire  cpu_LBU = (IR_instruction[31:26]==6'b100100)? 1'b1:1'b0;
wire  cpu_LHU = (IR_instruction[31:26]==6'b100101)? 1'b1:1'b0;
wire  cpu_SB = (IR_instruction[31:26]==6'b101000)? 1'b1:1'b0;
wire  cpu_SH = (IR_instruction[31:26]==6'b101001)? 1'b1:1'b0;
wire  cpu_LH = (IR_instruction[31:26]==6'b100001)? 1'b1:1'b0;
wire  cpu_MFC0 = (IR_instruction[31:26]==6'b010000&&IR_instruction[25:21]==5'b00000&&IR_instruction[5:0]==6'b000000)? 1'b1:1'b0;
wire  cpu_MFHI = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b010000)? 1'b1:1'b0;
wire  cpu_MFLO = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b010010)? 1'b1:1'b0;
wire  cpu_MTC0 = (IR_instruction[31:26]==6'b010000&&IR_instruction[25:21]==5'b00100&&IR_instruction[5:0]==6'b000000)? 1'b1:1'b0;
wire  cpu_MTHI = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b010001)? 1'b1:1'b0;
wire  cpu_MTLO = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b010011)? 1'b1:1'b0;
wire  cpu_MUL = (IR_instruction[31:26]==6'b011100&&IR_instruction[5:0]==6'b000010)? 1'b1:1'b0;
wire  cpu_MULTU = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b011001)? 1'b1:1'b0;
wire  cpu_SYSCALL = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b001100)? 1'b1:1'b0;
wire  cpu_TEQ = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b110100)? 1'b1:1'b0;
wire  cpu_BGEZ = (IR_instruction[31:26]==6'b000001)? 1'b1:1'b0;
wire  cpu_BREAK = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b001101)? 1'b1:1'b0;
wire  cpu_DIV = (IR_instruction[31:26]==6'b000000&&IR_instruction[5:0]==6'b011010)? 1'b1:1'b0;


// 54条指令独热码
wire [53:0]OP={cpu_ADDI,cpu_ADDIU,cpu_ANDI,cpu_ORI,cpu_XORI,cpu_LUI,
               cpu_ADD,cpu_ADDU,cpu_SUB,cpu_SUBU,cpu_AND,cpu_OR,cpu_XOR,cpu_NOR,
               cpu_SLT,cpu_SLTU,cpu_SLTI,cpu_SLTIU,cpu_SLL,cpu_SRL,cpu_SRA,cpu_SLLV,cpu_SRLV,cpu_SRAV,
               cpu_LW,cpu_SW,
               cpu_BEQ,cpu_BNE,
               cpu_J,cpu_JR,cpu_JAL,
               cpu_CLZ,cpu_BGEZ,cpu_JALR,cpu_MFC0,cpu_MTC0,
               cpu_MFHI,cpu_MFLO,cpu_MTHI,cpu_MTLO,
               cpu_LBU,cpu_LHU,cpu_LB,cpu_LH,cpu_SB,cpu_SH,
               cpu_BREAK,cpu_SYSCALL,cpu_ERET,cpu_TEQ,
               cpu_DIV,cpu_DIVU,cpu_MUL,cpu_MULTU};



//---------------------------------控制信号生成---------------------------------
wire [31:0]PC_in, NPC_out, Z_out;

//wire T1,T2,T3,T4,T5;
wire IR_EN, PC_EN, Z_EN, NPC_EN;

wire [31:0]MUX1_2;
wire [1:0]MUX1_ORDER;

wire [31:0]MUX2_1,MUX2_2,MUX2_3;
wire [31:0]MUX2_4 = 4;
wire [31:0]MUX2_5 = 0;
wire [2:0]MUX2_ORDER;

wire [31:0]MUX5_2;
wire [31:0]MUX5_4=32'h00400004;
wire [2:0]MUX5_ORDER;

wire [4:0]MUX6_0 = 31;
wire [1:0]MUX6_ORDER;

wire [31:0]HILO_wHi, HILO_wLo;
wire HI_EN, LO_EN;

wire [31:0]MUX7_0, MUX7_1;
wire [2:0]MUX7_ORDER;

wire [31:0]MUX8_0, MUX8_1;
wire [2:0]MUX8_ORDER;

wire Busy_Div,Busy_Divu,Start_Div,Start_Divu;

wire [63:0]MUL_Z,MULTU_Z;
wire Start_MUL,Start_MULTU;

wire LhEn,LbEn,LhuEn,LbuEn;

wire [31:0]MUX4_1, MUX4_2, MUX4_4;
wire [2:0]MUX4_ORDER;

assign DM_addr_in = Z_out;      // DMEM数据直接相连
assign DM_data_in = RF_rdata2;  // DMEM数据直接相连
assign CP0_Wdata = RF_rdata2;   // CP0直接读入Rt寄存器的值


//------------------------------实例化多周期控制器------------------------------

STATESMACHINE cpu_STATEMACHINE(.clk(clk),.RESET(rst),.OP(OP),
                               .ALU_Zero(ALU_Zero),.ALU_Negative(ALU_Negative),.Busy_Div(Busy_Div),.Busy_Divu(Busy_Divu),
                               .PC_EN(PC_EN),.IR_EN(IR_EN),.Z_EN(Z_EN),.NPC_EN(NPC_EN),.HI_EN(HI_EN),.LO_EN(LO_EN),
                               .LbEn(LbEn),.LhEn(LhEn),.LbuEn(LbuEn),.LhuEn(LhuEn),
                               .Start_Div(Start_Div),.Start_Divu(Start_Divu),.Start_MUL(Start_MUL),.Start_MULTU(Start_MULTU),
                               .MUX1_ORDER(MUX1_ORDER),.MUX2_ORDER(MUX2_ORDER),.MUX4_ORDER(MUX4_ORDER),.MUX5_ORDER(MUX5_ORDER),
                               .MUX6_ORDER(MUX6_ORDER),.MUX7_ORDER(MUX7_ORDER),.MUX8_ORDER(MUX8_ORDER),
                               .ALU_aluc(ALU_aluc),.DM_SIZE(DM_SIZE),.DM_WENA(DM_WENA),.RF_we(RF_we),
                               .mfc0(mfc0),.mtc0(mtc0),.exception(exception),.eret(eret),.cause(cause)
                               //for test
                               /*,.T1(T1),.T2(T2),.T3(T3),.T4(T4),.T5(T5)*/

                               );


//---------------------------------实例化各部件---------------------------------

// registers
PC cpu_PC(.clk(clk),.rst(rst),.ena(PC_EN),.data_in(PC_in),.data_out(IM_addr));
DATAREG cpu_IR(.clk(clk),.rst(rst),.ena(IR_EN),.data_in(IM_instruction),.data_out(IR_instruction));
DATAREG cpu_Z(.clk(clk),.rst(rst),.ena(Z_EN),.data_in(ALU_r),.data_out(Z_out));
DATAREG cpu_NPC(.clk(clk),.rst(rst),.ena(NPC_EN),.data_in(ALU_r),.data_out(NPC_out));

// MUX1
EXT5_UNSIGNED cpu_ext5Unsigned(.sa(IR_instruction[10:6]),.data(MUX1_2));
MUX3IN cpu_MUX1(.Order(MUX1_ORDER),.DataIn0(IM_addr),.DataIn1(RF_rdata1),.DataIn2(MUX1_2),.DataOut(ALU_a));

// MUX2
EXT16_SIGNED cpu_ext16Signed(.imm(IR_instruction[15:0]),.data(MUX2_1));
EXT16_UNSIGNED cpu_ext16Unsigned(.imm(IM_instruction[15:0]),.data(MUX2_2));
EXT18_SIGNED cpu_ext18Signed(.imm(IR_instruction[15:0]),.data(MUX2_3));
MUX6IN cpu_MUX2(.Order(MUX2_ORDER),.DataIn0(RF_rdata2),.DataIn1(MUX2_1),.DataIn2(MUX2_2),.DataIn3(MUX2_3),.DataIn4(MUX2_4),.DataIn5(MUX2_5),.DataOut(ALU_b));

// MUX5
JOINT cpu_joint(.pc(IM_addr[31:28]),.imem(IR_instruction[25:0]),.data(MUX5_2));
MUX6IN cpu_MUX5(.Order(MUX5_ORDER),.DataIn0(epc_out),.DataIn1(RF_rdata1),.DataIn2(MUX5_2),.DataIn3(Z_out),.DataIn4(MUX5_4),.DataIn5(NPC_out),.DataOut(PC_in));

// MUX6(5bit)
MUX3IN_ADDR cpu_MUX6(.Order(MUX6_ORDER),.DataIn0(MUX6_0),.DataIn1(IR_instruction[20:16]),.DataIn2(IR_instruction[15:11]),.DataOut(RF_waddr));

// MUX4
DIV cpu_DIVer(.dividend(RF_rdata1),.divisor(RF_rdata2),.start(Start_Div),.clock(clk),.reset(rst),.q(MUX8_0),.r(MUX7_0),.busy(Busy_Div));
DIVU cpu_DIVUer(.dividend(RF_rdata1),.divisor(RF_rdata2),.start(Start_Divu),.clock(clk),.reset(rst),.q(MUX8_1),.r(MUX7_1),.busy(Busy_Divu));

MULT cpu_MULer(.clk(clk),.reset(rst),.ena(Start_MUL),.a(RF_rdata1),.b(RF_rdata2),.z(MUL_Z));
MULTU cpu_MULTUer(.clk(clk),.reset(rst),.ena(Start_MULTU),.a(RF_rdata1),.b(RF_rdata2),.z(MULTU_Z));

MUX5IN cpu_MUX7(.Order(MUX7_ORDER),.DataIn0(MUX7_0),.DataIn1(MUX7_1),.DataIn2(MUL_Z[63:32]),.DataIn3(MULTU_Z[63:32]),.DataIn4(RF_rdata1),.DataOut(HILO_wHi));
MUX5IN cpu_MUX8(.Order(MUX8_ORDER),.DataIn0(MUX8_0),.DataIn1(MUX8_1),.DataIn2(MUL_Z[31:0]),.DataIn3(MULTU_Z[31:0]),.DataIn4(RF_rdata1),.DataOut(HILO_wLo));

HILO cpu_HILO(.clk(clk),.rst(rst),.HI_EN(HI_EN),.LO_EN(LO_EN),.wHi(HILO_wHi),.wLo(HILO_wLo),.rHi(MUX4_2),.rLo(MUX4_1));

CONV cpu_CONV(.data_in(DM_data_out),.LhEn(LhEn),.LbEn(LbEn),.LhuEn(LhuEn),.LbuEn(LbuEn),.data_out(MUX4_4));

MUX7IN cpu_MUX4(.Order(MUX4_ORDER),.DataIn0(MUL_Z[31:0]),.DataIn1(MUX4_1),.DataIn2(MUX4_2),.DataIn3(cp0_out),.DataIn4(MUX4_4),.DataIn5(Z_out),.DataIn6(NPC_out),.DataOut(RF_wdata));



// for test
/*assign Busy_Div_test = Busy_Div;
assign Busy_Divu_test = Busy_Divu;
assign Start_Div_test = Start_Div;
assign Start_Divu_test = Start_Divu;
assign HI_EN_test = HI_EN;
assign LO_EN_test = LO_EN;
assign IR_instruction_test=IM_instruction;*/



endmodule