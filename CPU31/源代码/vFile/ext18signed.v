`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:12:50
// Design Name: 
// Module Name: ext18signed
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

//进行18位有符号拓展
module ext18signed(
    input [15:0] imm,
    output [31:0] data
    );
assign data = imm[15]? {14'b11111111111111,imm,2'b0}:{ 14'b0,imm,2'b0};
endmodule
