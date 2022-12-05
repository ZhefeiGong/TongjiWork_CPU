`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/11 19:17:55
// Design Name: 
// Module Name: alu
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

//31条CPU ALU模块
module alu(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    input [3:0] aluc,
    output zero,      // needed!!!
    output carry,     // noneed
    output negative,  // noneed
    output overflow   // noneed
    );

    parameter ADDU  = 4'b0000;
    parameter ADD   = 4'b0010;
    parameter SUBU  = 4'b0001;
    parameter SUB   = 4'b0011;
    parameter AND   = 4'b0100;
    parameter OR    = 4'b0101;
    parameter XOR   = 4'b0110;
    parameter NOR   = 4'b0111;
    parameter LUI   = 4'b1000;
    parameter LUI2  = 4'b1001;
    parameter SLT   = 4'b1011;
    parameter SLTU  = 4'b1010;
    parameter SRA   = 4'b1100;
    parameter SLLA  = 4'b1110;
    parameter SLLA2 = 4'b1111;
    parameter SRL   = 4'b1101;
    
    wire signed [31:0] signA, signB;
    reg [32:0] resultTemp;
    assign signA = a;
    assign signB = b;
    always @(*) begin
        case(aluc)
            ADD:    resultTemp <= signA + signB;//有符号
            ADDU:   resultTemp <= a + b;
            SUB:    resultTemp <= signA - signB;//有符号
            SUBU:   resultTemp <= a - b;
            AND:    resultTemp <= a & b;
            OR:     resultTemp <= a | b;
            XOR:    resultTemp <= a ^ b;
            NOR:    resultTemp <= ~(a | b);

            SLT:    begin
                    case({a[31],b[31]})
                         2'b00:
                         resultTemp <= (a<b) ? 32'b1:32'b0;
                         2'b01:
                         resultTemp <= 32'b0;
                         2'b10:
                         resultTemp <= 32'b1;
                         2'b11:
                         resultTemp <= (a<b) ? 32'b1:32'b0;
                    endcase
                    end  
            SLTU:   resultTemp <= (a < b)? 32'b1:32'b0;

            SRA:    resultTemp <= signB >>> a;
            SLLA:   resultTemp <= b << a;
            SLLA2:  resultTemp <= b << a;
            SRL:    resultTemp <= b >> a;


            LUI:    resultTemp <= {b[15:0], 16'b0};
            LUI2:   resultTemp <= {b[15:0], 16'b0};

        endcase
    end
    assign r = resultTemp[31:0];                             //needed!!!
    assign zero = (resultTemp[31:0] == 32'b0) ? 1'b1 : 1'b0; //needed!!!
    assign carry = resultTemp[32];                           //noneed
    assign negative = resultTemp[32];                        //noneed
    assign overflow = resultTemp[32];                        //noneed
endmodule




