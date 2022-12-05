`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:02:38
// Design Name: 
// Module Name: ext16unsigned
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

//实现16位无符号拓展
module ext16unsigned(
    input [15:0]imm,
    output [31:0] data
    );
assign data ={16'b0,imm};  
endmodule
