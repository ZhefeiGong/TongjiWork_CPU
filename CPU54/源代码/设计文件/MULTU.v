`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.
//@function : 实现无符号乘法操作
module MULTU(
    input clk,            //乘法器时钟信号
    input reset,          //复位信号，高电平有效
    input ena,            //高电平有效
    input [31:0] a,       //输入数a(被乘数)
    input [31:0] b,       //输入数b(乘数)
    output [63:0] z       //乘积输出z
    );

//申请寄存器
reg [64:0] TempStore;
reg [32:0] ExpandA; 
reg [5:0] Count;

//begin to calculate
always@(posedge clk or posedge reset)
begin
    if(reset) begin
        TempStore = 64'b0;
    end
    else begin
        if(ena)begin
            ExpandA={1'b0,a};                                                                                 //扩充1位                        
            TempStore = {33'b00000000000000000000000000000000,b};
            for(Count=0;Count<32;Count=Count+1)begin
                if(TempStore & 65'b00000000000000000000000000000000000000000000000000000000000000001)begin
                    TempStore={TempStore[64:32]+ExpandA,TempStore[31:0]};
                end
                TempStore=TempStore>>1;                                                                      //逻辑右移1位
            end
        end
    end
end
assign z = TempStore[63:0];

endmodule
