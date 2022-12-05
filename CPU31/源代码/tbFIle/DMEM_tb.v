`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 11:06:57
// Design Name: 
// Module Name: DMEM_tb
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


module DMEM_tb();
    reg clk;   //下降沿有效
    reg ena;   //高电平有效
    reg wena;  //高写低读
    reg [4:0]addr;
    reg [31:0] data_in;
    wire [31:0] data_out;

initial begin
    clk=1'b1;
    ena=1'b0;
    wena=1'b0;
    #5 ena = 1'b1;
    wena=1'b1;
    addr = 5'b00000;
    data_in = 32'hffff0000;
end

always begin
    #10 clk = !clk;
end
    
    
DMEM mem(
.clk(clk),
.ena(ena),
.wena(wena),
.addr(addr),
.data_in(data_in),
.data_out(data_out));
    
    
    
    
endmodule
