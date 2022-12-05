`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.
//@function : 实现有符号除法操作
module DIV(
    input [31:0]dividend,                //被除数          -->有符号整数
    input [31:0]divisor,                 //除数            -->有符号整数
    input start,                         //启动除法运算    -->高电平有效
    input clock,                         //时钟信号
    input reset,                         //置位信号        -->高电平有效
    output [31:0]q,                      //商
    output [31:0]r,                      //余数
    output reg busy                      //触发器忙标志位
    );
    
//申请寄存器
reg [5:0]Count;                          //统计运行次数
reg [31:0]UnsignDividend;                //无符号被除数
reg [31:0]UnsignDivisor;                 //无符号除数
reg [31:0]quotient;                      //商
reg [31:0]remainder;                     //余数
reg [63:0]Storage;                       //存储中间数据
reg [31:0]HighCal;                       //高段存储
reg q_sign;                              //记录q正负
reg r_sign;                              //记录r正负

//开始计算
always@(posedge clock or posedge reset)begin
if(reset==1)begin
        Count<=6'b000000;
        busy<=1'b0;
        q_sign<=1'b0;
        r_sign<=1'b0;
        Storage<=64'b0;
        HighCal<=32'b0;
        quotient<=32'b0;
        remainder<=32'b0;
    end
    else begin
        if(busy)begin
            Storage={Storage[62:0],1'b0};             //左移一位
            if(Storage[63:32]>=UnsignDivisor)begin    //计算
                HighCal=Storage[63:32]-UnsignDivisor;
                Storage={HighCal,Storage[31:0]};
                Storage=Storage+1;
            end
            Count=Count+1;
            if(Count==32)begin                       //计算32次
                if(q_sign==1)                        //商正负转换
                    quotient=~{Storage[31:0]}+1;
                else
                    quotient=Storage[31:0];
                if(r_sign==1)                        //余数正负转换
                    remainder=~{Storage[63:32]}+1;
                else
                    remainder=Storage[63:32];
                busy=1'b0;                           //置不忙
            end
        end
        else if(start)begin                         //高电平有效
            if(dividend[31]==1)
                UnsignDividend=~dividend+1;
            else
                UnsignDividend=dividend;
            if(divisor[31]==1)
                UnsignDivisor=~divisor+1;
            else
                UnsignDivisor=divisor;
            if(dividend[31]==divisor[31])
                q_sign=1'b0;                        //正数
            else
                q_sign=1'b1;                        //负数
            if(dividend[31]==0)
                r_sign=1'b0;                        //正数
            else
                r_sign=1'b1;                        //负数      
            busy=1'b1;
            Count=6'b0;
            HighCal=32'b0;
            Storage={32'b0,UnsignDividend};
        end
    end
end    
assign r=remainder;
assign q=quotient;

endmodule
