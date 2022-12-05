`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/07 00:43:40
// Design Name: 
// Module Name: mux5bit
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

//二选一5位数据选择器
module mux5bit(
    input instruct,
    input [4:0] data0,
    input [4:0] data1,
    output [4:0] dataout
    );
//instruct=0 data0
//instruct=1 data1
assign dataout = instruct ? data1 : data0;
endmodule
