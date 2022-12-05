`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 19:55:47
// Design Name: 
// Module Name: joint
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

//实现拼接操作
module joint(
    input [3:0]pc,
    input [25:0]imem,
    output [31:0]data
    );
assign data={pc,imem,2'b0};
endmodule
