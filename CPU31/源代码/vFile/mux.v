`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 19:18:09
// Design Name: 
// Module Name: mux
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

//二选一32位数据选择器
module mux(
    input instruct,
    input [31:0] data0,
    input [31:0] data1,
    output [31:0] dataout
    );
//instruct=0 data0
//instruct=1 data1
assign dataout = instruct ? data1 : data0;
endmodule
