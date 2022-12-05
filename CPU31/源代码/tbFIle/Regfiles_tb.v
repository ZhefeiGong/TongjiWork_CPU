`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 18:37:34
// Design Name: 
// Module Name: Regfiles_tb
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


module Regfiles_tb;
    reg clk;
    reg rst;
    reg we;
    reg [4:0]raddr1;
    reg [4:0]raddr2;
    reg [4:0]waddr;
    reg [31:0]wdata;
    wire [31:0]rdata1;
    wire [31:0]rdata2;
regfile re(.clk(clk),.rst(rst),.we(we),.raddr1(raddr1),.raddr2(raddr2),.waddr(waddr),.wdata(wdata),.rdata1(rdata1),.rdata2(rdata2));
//Ê±ÖÓ
initial
begin
    clk=1'b0;
    forever #10 clk=~clk;//period=20
end
//¶ÁĞ´²Ù×÷
initial
begin
    raddr1=5'b00000;
    raddr2=5'b00000;
    waddr=5'b00000;
    wdata=32'b00000000111111110000000011111111;
    rst=1'b0;
    we=1'b1;
    #20//write
    repeat(31)
    begin
        #20 
        wdata=wdata+1'b1;
        waddr=waddr+1'b1;
    end
    #20//read
    we=1'b0;
    raddr1=5'b11111;
    raddr2=5'b01111;
    repeat(8)
    begin
        #20 
        raddr1=raddr1-1'b1;
        raddr2=raddr2-1'b1;
    end
    rst=1'b1;//¼Ä´æÆ÷Çå0
    repeat(3)
    begin
        #20 
        raddr1=raddr1-1'b1;
        raddr2=raddr2-1'b1;
   end
end
endmodule
