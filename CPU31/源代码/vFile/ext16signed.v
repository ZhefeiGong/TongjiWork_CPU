`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:02:06
// Design Name: 
// Module Name: ext16signed
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

//进行16位符号拓展
module ext16signed(
    input [15:0] imm,
    output [31:0] data
    );
assign data = imm[15]?{16'hffff,imm}:{16'h0000,imm};
endmodule
