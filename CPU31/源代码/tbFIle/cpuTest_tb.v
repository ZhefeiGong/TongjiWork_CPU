`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 17:55:01
// Design Name: 
// Module Name: cpuTest_tb
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


module cpuTest_tb();
reg clk;  //上升沿有效
reg  rst;  //高电平重置
reg  ena;  //高电平有效
reg [31:0] IM_instruction;
reg [31:0] DM_data_out;
wire [31:0] IM_addr;    //***out***
wire [31:0] DM_data_in; //***out***
wire DM_ena;            //***out*** 
wire DM_wena;           //***out***
wire [31:0] DM_addr;    //***out***

   // wire [31:0] RF_wdata_TEST;
   // wire [4:0] RF_waddr_TEST;
   // wire [31:0] RF_rdata1_TEST;
   // wire [31:0] RF_rdata2_TEST;

initial begin
    clk = 1'b0;
    rst = 1'b1;//初始化
    ena= 1'b1;
    #10 rst=1'b0;
    IM_instruction = 32'hafe10004;
    DM_data_out = 32'hffff0000;
end
//时钟赋值
always begin
    #20 clk = !clk;
end


CPU cput(
.clk(clk),
.rst(rst),
.ena(ena),
.IM_instruction(IM_instruction),
.DM_data_out(DM_data_out),
.IM_addr(IM_addr), 
.DM_data_in(DM_data_in),
.DM_ena(DM_ena),  
.DM_wena(DM_wena), 
.DM_addr(DM_addr));
//.RF_waddr_TEST(RF_waddr_TEST));

//.RF_wdata_TEST(RF_wdata_TEST),
//.RF_waddr_TEST(RF_waddr_TEST),
//.RF_rdata1_TEST(RF_rdata1_TEST),
//.RF_rdata2_TEST(RF_rdata2_TEST)); 


endmodule
