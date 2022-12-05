`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:16:02
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//控制器
module controller(
    input [31:0]IM_instruction,
    
    input [31:0]PC_data_out,
    output [31:0]PC_data_in,    //***out***
    
    output [4:0]RF_waddr,       //***out***--RF_waddr5位地址
    output [31:0] RF_wdata,     //***out***
    input [31:0]RF_rdata1,
    input [31:0]RF_rdata2,
    output RF_we,               //***out***
    
    output [31:0]ALU_a,         //***out***
    output [31:0]ALU_b,         //***out***
    input [31:0] ALU_r,
    input ALU_zero,
    output [3:0]ALU_aluc,       //***out***--ALU指令
    
    input [31:0]DM_data_out,
    output DM_ena,              //***out***
    output DM_wena              //***out***
    );
    
parameter jalWaddr = 31;

//---------------------------------初始化指令标志---------------------------------
wire  cpu_ADD = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100000)? 1'b1:1'b0;
wire  cpu_ADDU = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100001)? 1'b1:1'b0;
wire  cpu_SUB = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100010)? 1'b1:1'b0;
wire  cpu_SUBU = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100011)? 1'b1:1'b0;
wire  cpu_AND = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100100)? 1'b1:1'b0;
wire  cpu_OR = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100101)? 1'b1:1'b0;
wire  cpu_XOR = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100110)? 1'b1:1'b0;
wire  cpu_NOR = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b100111)? 1'b1:1'b0;
wire  cpu_SLT = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b101010)? 1'b1:1'b0;
wire  cpu_SLTU = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b101011)? 1'b1:1'b0;
wire  cpu_SLL = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000000)? 1'b1:1'b0;
wire  cpu_SRL = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000010)? 1'b1:1'b0;
wire  cpu_SRA = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000011)? 1'b1:1'b0;
wire  cpu_SLLV = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000100)? 1'b1:1'b0;
wire  cpu_SRLV = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000110)? 1'b1:1'b0;
wire  cpu_SRAV = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b000111)? 1'b1:1'b0;
wire  cpu_JR = (IM_instruction[31:26]==6'b000000&&IM_instruction[5:0]==6'b001000)? 1'b1:1'b0;

wire  cpu_ADDI = (IM_instruction[31:26]==6'b001000)? 1'b1:1'b0;
wire  cpu_ADDIU = (IM_instruction[31:26]==6'b001001)? 1'b1:1'b0;
wire  cpu_ANDI = (IM_instruction[31:26]==6'b001100)? 1'b1:1'b0;
wire  cpu_ORI = (IM_instruction[31:26]==6'b001101)? 1'b1:1'b0;
wire  cpu_XORI = (IM_instruction[31:26]==6'b001110)? 1'b1:1'b0;
wire  cpu_LW = (IM_instruction[31:26]==6'b100011)? 1'b1:1'b0;
wire  cpu_SW = (IM_instruction[31:26]==6'b101011)? 1'b1:1'b0;
wire  cpu_BEQ = (IM_instruction[31:26]==6'b000100)? 1'b1:1'b0;
wire  cpu_BNE = (IM_instruction[31:26]==6'b000101)? 1'b1:1'b0;
wire  cpu_SLTI = (IM_instruction[31:26]==6'b001010)? 1'b1:1'b0;
wire  cpu_SLTIU = (IM_instruction[31:26]==6'b001011)? 1'b1:1'b0;
wire  cpu_LUI = (IM_instruction[31:26]==6'b001111)? 1'b1:1'b0;
wire  cpu_J = (IM_instruction[31:26]==6'b000010)? 1'b1:1'b0;
wire  cpu_JAL = (IM_instruction[31:26]==6'b000011)? 1'b1:1'b0;

//---------------------------------组合逻辑实现各个控制参数---------------------------------
wire M10 = cpu_BNE;
wire z = M10 ? !ALU_zero : ALU_zero;                                                                       //MUX10-->一位选择器

assign ALU_aluc[0]=cpu_SUB||cpu_SUBU||cpu_OR||cpu_NOR||cpu_SLT||cpu_SRL||cpu_SRLV||cpu_ORI||cpu_BEQ||cpu_BNE||cpu_SLTI;
assign ALU_aluc[1]=cpu_ADD||cpu_SUB||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU||cpu_SLL||cpu_SLLV||cpu_ADDI||cpu_XORI||cpu_LW||cpu_SW||cpu_SLTI||cpu_SLTIU;
assign ALU_aluc[2]=cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_ANDI||cpu_ORI||cpu_XORI;
assign ALU_aluc[3]=cpu_SLT||cpu_SLTU||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_SLTI||cpu_SLTIU||cpu_LUI;
assign DM_ena=cpu_LW||cpu_SW;
assign DM_wena=cpu_SW;
assign RF_we=cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU
         ||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_ADDI||cpu_ADDIU
         ||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LW||cpu_SLTI||cpu_SLTIU||cpu_LUI||cpu_JAL;

wire M1=(cpu_BEQ&&z)||(cpu_BNE&&z);
wire M2=cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU
         ||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_ADDI||cpu_ADDIU
         ||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LW||cpu_SW||cpu_BEQ||cpu_BNE||cpu_SLTI||cpu_SLTIU||cpu_LUI;
wire M3=cpu_J||cpu_JAL;
wire M4=cpu_JAL;
wire M5=cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU
         ||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_ADDI||cpu_ADDIU
         ||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_SLTI||cpu_SLTIU||cpu_LUI;
wire M6=cpu_SLL||cpu_SRL||cpu_SRA;
wire M7=cpu_ADDI||cpu_ADDIU||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LW||cpu_SW||cpu_SLTI||cpu_SLTIU||cpu_LUI;
wire M8=cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU
         ||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV;
wire M9=cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LUI;
wire M11=cpu_ADD||cpu_ADDU||cpu_SUB||cpu_SUBU||cpu_AND||cpu_OR||cpu_XOR||cpu_NOR||cpu_SLT||cpu_SLTU
         ||cpu_SLL||cpu_SRL||cpu_SRA||cpu_SLLV||cpu_SRLV||cpu_SRAV||cpu_ADDI||cpu_ADDIU
         ||cpu_ANDI||cpu_ORI||cpu_XORI||cpu_LW||cpu_SW||cpu_SLTI||cpu_SLTIU||cpu_LUI;


//---------------------------------初始化各个部件---------------------------------
wire [31:0] ext18Out;
wire [31:0] ext16UnsignedOut;
wire [31:0] ext16SignedOut;
wire [31:0] ext5Out;
wire [31:0] joint_out;
wire [31:0] add1_num = 4;
wire [31:0] add1_out;
wire [31:0] add2_out;
wire [31:0] npc_num = 4;
wire [31:0] npc_out;
wire [31:0] mux1_out;
wire [31:0] mux3_out;
wire [31:0] mux5_out;
wire [4:0] mux8_out;
wire [31:0] mux9_out;
wire [4:0] mux11_0=jalWaddr;

ext5unsigned ext5(.sa(IM_instruction[10:6]),.data(ext5Out));                                //EXT5
ext16signed ext16s(.imm(IM_instruction[15:0]),.data(ext16SignedOut));                       //EXT16signed
ext16unsigned ext16u(.imm(IM_instruction[15:0]),.data(ext16UnsignedOut));                   //EXT16unsigned
ext18signed ext18s(.imm(IM_instruction[15:0]),.data(ext18Out));                             //EXT18
joint jo(.pc(PC_data_out[31:28]),.imem(IM_instruction[25:0]),.data(joint_out));             //joint
adder ADD1(.a(add1_num),.b(PC_data_out),.dataout(add1_out));                                //ADD1
adder ADD2(.a(ext18Out),.b(npc_out),.dataout(add2_out));                                    //ADD2
adder add_npc (.a(npc_num),.b(PC_data_out),.dataout(npc_out));                              //NPC

mux mux1(.instruct(M1),.data0(npc_out),.data1(add2_out),.dataout(mux1_out));                                //MUX1
mux mux2(.instruct(M2),.data0(mux3_out),.data1(mux1_out),.dataout(PC_data_in));                             //MUX2
mux mux3(.instruct(M3),.data0(RF_rdata1),.data1(joint_out),.dataout(mux3_out));                             //MUX3
mux mux4(.instruct(M4),.data0(mux5_out),.data1(add1_out),.dataout(RF_wdata));                               //MUX4
mux mux5(.instruct(M5),.data0(DM_data_out),.data1(ALU_r),.dataout(mux5_out));                               //MUX5
mux mux6(.instruct(M6),.data0(RF_rdata1),.data1(ext5Out),.dataout(ALU_a));                                  //MUX6
mux mux7(.instruct(M7),.data0(RF_rdata2),.data1(mux9_out),.dataout(ALU_b));                                 //MUX7
mux5bit mux8(.instruct(M8),.data0(IM_instruction[20:16]),.data1(IM_instruction[15:11]),.dataout(mux8_out)); //MUX8
mux mux9(.instruct(M9),.data0(ext16SignedOut),.data1(ext16UnsignedOut),.dataout(mux9_out));                 //MUX9
mux5bit mux11(.instruct(M11),.data0(mux11_0),.data1(mux8_out),.dataout(RF_waddr));                          //MUX11


endmodule
