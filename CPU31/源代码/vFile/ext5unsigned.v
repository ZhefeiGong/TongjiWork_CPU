`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:04:54
// Design Name: 
// Module Name: ext5unsigned
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

//实现5位sa无符号拓展
module ext5unsigned(
    input [4:0] sa,
    output [31:0]data
    );
assign data={27'b0,sa};
endmodule
