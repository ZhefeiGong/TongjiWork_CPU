`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 13:01:13
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow(
    input clk_in,         // 下降沿有效
    input reset,          // 高电平有效
    output [31:0] inst,   // 指令信息
    output [31:0] pc      // PC记录地址信息
    );

wire [31:0] IM_instruction;
wire [31:0] IM_addr;

wire [31:0] DM_data_in;
wire [31:0] DM_data_out;
wire [31:0] DM_addr;
wire DM_ena;
wire DM_wena;

assign inst = IM_instruction;
assign pc = IM_addr;

//修改哈佛和冯诺依曼CPU的差别
wire [31:0] DM_addr_change;
assign DM_addr_change = (DM_addr - 32'h10010000) / 4;    //MARS中数据跳着存储 并且基地址不同
wire [31:0] IM_addr_change;
assign IM_addr_change =IM_addr - 32'h00400000;           //MARS中基地址不同

//IMEM指令存储器
IMEM imemory(
.IM_addr(IM_addr_change[12:2]),    //测试过程中仅有11位！！！
.IM_instruction(IM_instruction)
);

//DMEM数据存储器
DMEM dmemory(
.clk(clk_in),
.ena(DM_ena),
.wena(DM_wena),
.addr(DM_addr_change[4:0]),       //仅有32个32位的存储空间！！！
.data_in(DM_data_in),
.data_out(DM_data_out)
);

//CPU
wire CPU_ena = 1'b1;//高电平有效 针对PC对数据进行读取
CPU sccpu(
.clk(clk_in),
.rst(reset),
.ena(CPU_ena),
.IM_instruction(IM_instruction),
.DM_data_out(DM_data_out),
.IM_addr(IM_addr), 
.DM_data_in(DM_data_in),
.DM_ena(DM_ena),  
.DM_wena(DM_wena), 
.DM_addr(DM_addr)); 

endmodule
