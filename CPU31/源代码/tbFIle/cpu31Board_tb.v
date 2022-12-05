`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 18:41:00
// Design Name: 
// Module Name: cpu31Board_tb
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

//31条下板指令集
module cpu31Board_tb();
    reg clk;
    reg rst;
    wire [7:0] o_seg;
    wire [7:0] o_sel;

initial begin
    clk = 1'b1;
    rst = 1'b1;
    #2 rst =1'b0;
end

always begin
    #5 clk = !clk;
end
  
cpu31Board board(
       .clk_in(clk),
       .reset(rst),
       .o_seg(o_seg),
       .o_sel(o_sel)
       );
endmodule
