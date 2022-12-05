`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.27
//@function : 实现ALU模块
module ALU(
    input [31:0] a,
    input [31:0] b,
    output [31:0] r,
    input [3:0] aluc,
    output reg zero,      // needed!!!
    output reg negative,  // needed!!!
    output carry,     // noneed
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
    parameter CLZ   = 4'b1001;
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
    reg start = 1;
    
    // ALU组合逻辑
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

            CLZ:    begin
                    casex(a)
                    32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h0;
                    32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h1;
                    32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h2;
                    32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h3;
                    32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h4;
                    32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h5;
                    32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h6;
                    32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h7;
                    32'b000000001xxxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h8;
                    32'b0000000001xxxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'h9;
                    32'b00000000001xxxxxxxxxxxxxxxxxxxxx:resultTemp<=32'ha;
                    32'b000000000001xxxxxxxxxxxxxxxxxxxx:resultTemp<=32'hb;
                    32'b0000000000001xxxxxxxxxxxxxxxxxxx:resultTemp<=32'hc;
                    32'b00000000000001xxxxxxxxxxxxxxxxxx:resultTemp<=32'hd;
                    32'b000000000000001xxxxxxxxxxxxxxxxx:resultTemp<=32'he;
                    32'b0000000000000001xxxxxxxxxxxxxxxx:resultTemp<=32'hf;
                    32'b00000000000000001xxxxxxxxxxxxxxx:resultTemp<=32'h10;
                    32'b000000000000000001xxxxxxxxxxxxxx:resultTemp<=32'h11;
                    32'b0000000000000000001xxxxxxxxxxxxx:resultTemp<=32'h12;
                    32'b00000000000000000001xxxxxxxxxxxx:resultTemp<=32'h13;
                    32'b000000000000000000001xxxxxxxxxxx:resultTemp<=32'h14;
                    32'b0000000000000000000001xxxxxxxxxx:resultTemp<=32'h15;
                    32'b00000000000000000000001xxxxxxxxx:resultTemp<=32'h16;
                    32'b000000000000000000000001xxxxxxxx:resultTemp<=32'h17;
                    32'b0000000000000000000000001xxxxxxx:resultTemp<=32'h18;
                    32'b00000000000000000000000001xxxxxx:resultTemp<=32'h19;
                    32'b000000000000000000000000001xxxxx:resultTemp<=32'h1a;
                    32'b0000000000000000000000000001xxxx:resultTemp<=32'h1b;
                    32'b00000000000000000000000000001xxx:resultTemp<=32'h1c;
                    32'b000000000000000000000000000001xx:resultTemp<=32'h1d;
                    32'b0000000000000000000000000000001x:resultTemp<=32'h1e;
                    32'b00000000000000000000000000000001:resultTemp<=32'h1f;
                    32'b00000000000000000000000000000000:resultTemp<=32'h20;
                    default:;
                    endcase
                    end 

        endcase
    end
    assign r = resultTemp[31:0];                               //needed!!!

    // Zero&Negative组合逻辑
    always@(*)begin
        // 初始化
        if(start)begin
            zero <= 1'b0;
            negative <=1'b0;
            start<=1'b0;
        end
        // 进行赋值计算
        else begin
            if(aluc==SUB)begin
                zero <= (resultTemp[31:0] == 32'b0) ? 1'b1 : 1'b0;   //we needed!!!
                negative <= (resultTemp[31] == 1'b1) ? 1'b1 : 1'b0;  //we needed!!!
            end
            else begin
                zero <= zero;
                negative <=negative;
            end
        end
    end

    assign carry = resultTemp[32];                             //noneed
    assign overflow = resultTemp[32];                          //noneed
    
endmodule
