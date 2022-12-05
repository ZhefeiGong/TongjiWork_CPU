`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:43:11
// Design Name: 
// Module Name: DMEM
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

//数据存储器--即ram
module DMEM(
    input clk,   //下降沿有效
    input ena,   //高电平有效
    input wena,  //高写低读
    input [4:0]addr,
    input [31:0] data_in,
    output[31:0] data_out
);
reg [31:0] store [31:0];    //存储器含32个32位的寄存器
//写入数据-下降沿
always@(negedge clk)        //下降沿有效
begin
if(ena==1'b1&&wena==1'b1)
    store[addr]<=data_in;   //非阻塞赋值
end
assign data_out = (ena==1'b1)? store[addr]:32'bz;

endmodule
