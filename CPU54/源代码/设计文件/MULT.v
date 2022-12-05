`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.
//@function : 以补码形式进行有符号数的运算
module MULT(
    input clk,           //乘法器时钟信号
    input reset,         //复位信号，高电平有效
    input ena,           //高电平有效
    input [31:0]a,       //输入数a(被乘数)   -->补码形式输入
    input [31:0]b,       //输入数b(乘数)     -->补码形式输入
    output [63:0]z       //乘积输出z
    );

//申请寄存器
reg [31:0] MulA;
reg [31:0] MulB;
reg [5:0] Count;
reg [65:0] TempStore;
reg [31:0] NegCompleA;
reg [32:0] BoothA;
reg [32:0] BoothNegA;

//begin to calculate
always@(posedge clk or posedge reset) 
begin
    if(reset)begin
        MulA<=0;
        MulB<=0;
        Count<=0;
        TempStore<=0;
        NegCompleA<=0;
        BoothA<=0;
        BoothNegA<=0;
    end
    else begin
        if(ena)begin
            /*deal with some special situation*/
            if(a==32'b10000000000000000000000000000000 && b==32'b10000000000000000000000000000000)
                TempStore=66'b001111111111111111111111111111111111111111111111111111111111111111;
            else begin
                if(a==32'b10000000000000000000000000000000)begin
                    MulA=b;
                    MulB=a;
                end
                else begin
                    MulA=a;
                    MulB=b;                    
                end    
                NegCompleA = ~MulA+1;                                                        //取反加一
                BoothA={MulA[31],MulA[31:0]};                                                //双符号位
                BoothNegA={NegCompleA[31],NegCompleA[31:0]};                                 //双符号位
                TempStore={33'b00000000000000000000000000000000,MulB,1'b0};
                //circulation    
                for(Count=0;Count<32;Count=Count+1)begin                                     //进行32次运算
                    case(TempStore[1:0])
                        2'b01:TempStore={TempStore[65:33]+BoothA,TempStore[32:0]};           //+
                        2'b10:TempStore={TempStore[65:33]+BoothNegA,TempStore[32:0]};        //-
                    default:;
                    endcase
                    TempStore={TempStore[65],TempStore[65:1]};                               //算术右移
                end 
            end
        end
    end
end
assign z = TempStore[64:1];                                                              //中间64位
endmodule
