`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.28
//@function : 实现无符号除法操作
module DIVU(
    input [31:0]dividend,                //被除数          -->无符号整数
    input [31:0]divisor,                 //除数            -->无符号整数
    input start,                         //启动除法运算    -->高电平有效
    input clock,                         //时钟信号
    input reset,                         //置位信号        -->高电平有效
    output [31:0]q,                      //商
    output [31:0]r,                      //余数
    output reg busy                      //触发器忙标志位
    );
    
//申请寄存器
reg [5:0]Count;                          //用于计数
reg [63:0]Storage;                       //存储中间数据
reg [31:0]HighCal;                       //高段存储

//开始计算
always@(posedge clock or posedge reset)begin
    if(reset==1)begin
        Count<=6'b000000;
        busy<=1'b0;
        Storage<=64'b0;
        HighCal<=32'b0;
    end
    else begin
        if(busy)begin
            Storage={Storage[62:0],1'b0};          //左移一位
            if(Storage[63:32]>=divisor)begin       //计算
                HighCal=Storage[63:32]-divisor;
                Storage={HighCal,Storage[31:0]};
                Storage=Storage+1;
            end
            Count=Count+1;
            if(Count==32)begin                    //计算32次
                busy=1'b0;                        //置不忙
            end
        end
        else if(start)begin
            busy=1'b1;
            Count=6'b0;
            HighCal=32'b0;
            Storage={32'b0,dividend};
        end
    end
end    
assign r=Storage[63:32];                          //高32位-->余数
assign q=Storage[31:0];                           //低32位-->商
endmodule
