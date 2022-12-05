`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/08 13:15:12
// Design Name: 
// Module Name: aluTEST_tb
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


module aluTEST_tb();
reg [31:0] a;
reg [31:0] b;
reg [31:0] aluc;
wire [31:0] r;
wire zero;
wire carry;
wire negative;
wire overflow;

initial begin
     a = 32'h0000003;
     b = 32'h0000004;
     aluc = 4'b0011;
end

alu test(
.a(a),
.b(b),
.aluc(aluc),
.r(r),  
.zero(zero), 
.carry(carry),  
.negative(negative), 
.overflow(overflow) 
    );
endmodule
