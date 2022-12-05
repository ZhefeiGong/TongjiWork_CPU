`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 20:54:09
// Design Name: 
// Module Name: IMEM_tb
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

//test for IMEM
module IMEM_tb();
reg [31:0] a;
wire [31:0] spo;
IMEM imem( .IM_addr(a[10:0]), .IM_instuction(spo) );
initial begin
 a = 32'b0;
end
always begin
#20 a = a + 1'b1;
end
endmodule
