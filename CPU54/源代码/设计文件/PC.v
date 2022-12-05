`timescale 1ns / 1ps
//@author   : gonzalez
//@time     : 2022.7.24 - 2022.7.24
//@function : 实现PC操作
module PC(
    input clk,// 上升沿有效
    input rst,// 高电平重置
    input ena,// 高电平有效
    input [31:0]data_in,
    output wire [31:0] data_out
    );
    
reg [31:0] pcRegister;
always @(posedge clk or posedge rst) begin
    if(rst)begin                    // 高电平初始化
        pcRegister <= 32'h00400000; // 根据MARS坐标映射
    end
    else if (ena) begin             // 高电平有效
        pcRegister <= data_in;
    end
end
assign data_out = pcRegister;       // 始终输出PC寄存器内存储的值

endmodule
